//
//  FeedViewController.m
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 4/25/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "Messages.h"
#import "Feed.h"
#import "FeedView.h"
#import "ShadowView.h"
#import "FeedCardView.h"
#import "ZLSwipeableView.h"
#import "AnalyticManager.h"
#import "SVProgressHUD.h"

#define POLL_SECONDS 25
#define CARD_VIEW_TAG 1900

@interface FeedView () <ZLSwipeableViewDataSource, ZLSwipeableViewDelegate, FeedCardViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *navigationBarView;
@property (strong, nonatomic) IBOutlet UILabel *navigationBarTitleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *discoverImageView;
@property (strong, nonatomic) IBOutlet UILabel *discoverLabel;
@property (strong, nonatomic) IBOutlet UISwitch *discoverSwitch;

@property(strong, nonatomic) SharedData *sharedData;
@property(strong, nonatomic) NSMutableArray *feedData;
@property(assign, nonatomic) NSInteger feedIndex;

@property (strong, nonatomic) ZLSwipeableView *swipeableView;
@property(nonatomic,strong) EmptyView *emptyView;

@end

@implementation FeedView

- (SharedData *)sharedData {
    if (!_sharedData) {
        _sharedData = [SharedData sharedInstance];
    }
    
    return _sharedData;
}

- (EmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc] initWithFrame:CGRectMake(15,
                                                                 0,
                                                                 CGRectGetWidth([UIScreen mainScreen].bounds) - 30,
                                                                 200)];
        
        CGRect frame = [UIScreen mainScreen].bounds;
        [ _emptyView setCenter:CGPointMake(frame.size.width / 2, frame.size.height / 2)];
        
        [_emptyView setMode:@"hide"];
    }
    
    return _emptyView;
}

- (ZLSwipeableView *)swipeableView {
    if (!_swipeableView) {
        _swipeableView = [[ZLSwipeableView alloc] initWithFrame:CGRectZero];
        [_swipeableView.layer setZPosition:1000];
        [_swipeableView setBackgroundColor:[UIColor clearColor]];
        [_swipeableView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_swipeableView setAllowedDirection:ZLSwipeableViewDirectionHorizontal];
        [_swipeableView setDataSource:self];
        [_swipeableView setDelegate:self];
    }
    
    return _swipeableView;
}

+ (FeedView *)instanceFromNib {
    return (FeedView *)[[UINib nibWithNibName:@"FeedView" bundle:nil] instantiateWithOwner:self options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.feedData = [[NSMutableArray alloc] init];
    [self setupSwipeableView];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

- (void)initClass {
    if (self.sharedData.matchMe) {
        [self.discoverImageView setImage:[UIImage imageNamed:@"discover_on"]];
    } else {
        [self.discoverImageView setImage:[UIImage imageNamed:@"discover_off"]];
    }
    
    NSArray *feeds = [Feed unarchiveObject];
    
    if (feeds) {
        self.feedData = [NSMutableArray arrayWithArray:feeds];
        [self.swipeableView loadViewsIfNeeded];
    } else {
        [self loadDataAndShowHUD:NO];
    }
}

- (IBAction)discoverDidValueChanged:(UISwitch *)sender {
    if (self.sharedData.matchMe) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Turn off socialize?"
                                                        message:@"while turned off, your profile card won't be shown to other users."
                                                       delegate:self
                                              cancelButtonTitle:@"Go Invisible"
                                              otherButtonTitles:@"Cancel",nil];
        [alert show];
    } else {
        self.sharedData.matchMe = YES;
        [self toggleMatch];
    }
}

- (Feed *)getFeedFromCardView:(UIView *)view {
    ShadowView *shadowView = (ShadowView*)view;
    Feed *feed = ((FeedCardView *)shadowView.subviews.lastObject).feed;
    
    return feed;
}

#pragma mark - Load Data
- (void)loadDataAndShowHUD:(BOOL)show {
    if (self.sharedData.fb_id == nil ||
        [self.sharedData.fb_id isEqualToString:@""]) {
        return;
    }
    
    if (show) {
        [SVProgressHUD show];
    } else {
        [self.emptyView setMode:@"load"];
    }
    
    [Feed retrieveFeedsWithCompletionHandler:^(NSArray *feeds, NSInteger statusCode, NSError *error) {
        if (show) {
            [SVProgressHUD dismiss];
        } else {
            [self.emptyView setMode:@"hide"];
        }
        
        self.feedIndex = 0;
        
        if (error) {
            [self.emptyView setMode:@"empty"];
            [SVProgressHUD showInfoWithStatus:@"Please check your internet connection"];
        } else {
            [self.feedData removeAllObjects];
            
            if (statusCode == 204) {
                [self.emptyView setData:@"Check back soon"
                               subtitle:@"Browse some events and your social feed will show members who like the same events."
                             imageNamed:@"PickIcon"];
                [self.emptyView setMode:@"empty"];
                [self.feedData removeAllObjects];
                [self.swipeableView setHidden:YES];
                
                [Feed removeArchivedObject];
                
                return;
            }
            
            [self.emptyView setMode:@"hide"];
            [self.feedData addObjectsFromArray:feeds];
            
            [self.swipeableView setHidden:NO];
            [self.swipeableView loadViewsIfNeeded];
            
            if (self.feedData.count > 0) {
                [Feed archiveObject:feeds];
                [[AnalyticManager sharedManager] trackMixPanelWithDict:@"New Feed Item" withDict:@{}];
            }
        }
    }];
}

- (void)toggleMatch {
    NSString *matchMe = (self.sharedData.matchMe == YES)?@"yes":@"no";
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    NSString *url = [NSString stringWithFormat:@"%@/partyfeed/settings/%@/%@", PHBaseURL, self.sharedData.fb_id, matchMe];
    
    [SVProgressHUD show];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        [self.swipeableView setHidden:!self.sharedData.matchMe];
        [self.discoverSwitch setOn:self.sharedData.matchMe animated:YES];
        
        if (self.sharedData.matchMe) {
            [self.discoverImageView setImage:[UIImage imageNamed:@"discover_on"]];
            [self.discoverLabel setText:@"Turn off if you do not wish to be seen by others"];
        } else {
            [self.emptyView setMode:@"hide"];
            [self.discoverImageView setImage:[UIImage imageNamed:@"discover_off"]];
            [self.discoverLabel setText:@"Turn on if you wish to be seen by others"];
        }
        
        self.sharedData.feedBadge.hidden = !self.sharedData.matchMe;
        self.sharedData.feedBadge.canShow = self.sharedData.matchMe;
        
        if (self.sharedData.matchMe) {
            [self loadDataAndShowHUD:YES];
        }
        
        [[AnalyticManager sharedManager] trackMixPanelWithDict:@"Socialize Toggle" withDict:@{@"toggle":matchMe}];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [SVProgressHUD dismiss];
     }];
}

#pragma mark - View
- (void)setupSwipeableView {
    if (![self.swipeableView isDescendantOfView:self]) {
        [self addSubview:self.swipeableView];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_swipeableView);
        
        NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_swipeableView]-15-|"
                                                                                 options:kNilOptions
                                                                                 metrics:kNilOptions
                                                                                   views:views];
        
        NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-160-[_swipeableView]-50-|"
                                                                               options:kNilOptions
                                                                               metrics:kNilOptions
                                                                                 views:views];
        
        [self addConstraints:horizontalConstraints];
        [self addConstraints:verticalConstraints];
    }
    
    if (![self.emptyView isDescendantOfView:self]) {
        [self addSubview:self.emptyView];
    }
}

#pragma mark - MixPanel
- (void)trackViewFeedItem {
    Feed *feed = [self getFeedFromCardView:self.swipeableView.topView];
    
    NSString *val = @"";
    if ([self.sharedData.ABTestChat isEqualToString:@"YES"]) {
        val = @"Connect";
    } else {
        val = @"Chat";
    }
    
    NSMutableDictionary *paramsToSend = [[NSMutableDictionary alloc] init];
    [paramsToSend setObject:val forKey:@"ABTestChat"];
    [paramsToSend setObject:[Feed feedTypeAsString:feed.type] forKey:@"feed_item_type"];
    [[AnalyticManager sharedManager] trackMixPanelWithDict:@"View Feed Item" withDict:paramsToSend];
}

#pragma mark - ZLSwipeableViewDataSource
- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView {
    if (self.feedIndex < self.feedData.count) {
        CGRect frame = CGRectMake(15,
                                  160,
                                  CGRectGetWidth([UIScreen mainScreen].bounds) - 30,
                                  CGRectGetHeight(self.bounds) - 185);
        ShadowView *cardView = [[ShadowView alloc] initWithFrame:frame];
        cardView.tag = CARD_VIEW_TAG+self.feedIndex;
        FeedCardView *contentView = [FeedCardView instanceFromNib];
        if (!contentView.delegate) {
            [contentView setDelegate:self];
        }
        [cardView addSubview:contentView];
        
        [contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [contentView configureCardWithFeed:self.feedData[self.feedIndex]];
        
        NSDictionary *metrics = @{ @"width" : @(cardView.bounds.size.width),
                                   @"height" : @(cardView.bounds.size.height)};
        NSDictionary *views = NSDictionaryOfVariableBindings(contentView);
        
        [cardView addConstraints:[NSLayoutConstraint
                                  constraintsWithVisualFormat:@"H:|[contentView(width)]"
                                  options:kNilOptions
                                  metrics:metrics
                                  views:views]];
        [cardView addConstraints:[NSLayoutConstraint
                                  constraintsWithVisualFormat:@"V:|[contentView(height)]"
                                  options:kNilOptions
                                  metrics:metrics
                                  views:views]];
        
        // track first top view item
        if (self.feedIndex == 1) {
            [self trackViewFeedItem];
        }
        
        self.feedIndex++;
        
        return cardView;
    }
    
    return nil;
}

#pragma mark - ZLSwipeableViewDelegate
- (void)swipeableView:(ZLSwipeableView *)swipeableView didSwipeView:(UIView *)view inDirection:(ZLSwipeableViewDirection)direction {
    NSInteger feedIndex = view.tag-CARD_VIEW_TAG;
    if (feedIndex == self.feedData.count-4) {
        [self loadDataAndShowHUD:NO];
    }
    
    [self.swipeableView setUserInteractionEnabled:NO];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(0.7 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       [self.swipeableView setUserInteractionEnabled:YES];
                   });
    
    [self trackViewFeedItem];
    
    Feed *feed = [self getFeedFromCardView:view];
    
    [self.feedData removeObject:feed];
    
    [Feed archiveObject:self.feedData];
    
    if (direction == ZLSwipeableViewDirectionRight) {
        switch (feed.type) {
            case FeedTypeApproved: {
                [SVProgressHUD show];
                [Feed approveFeed:YES withFbId:feed.fromFbId andCompletionHandler:^(NSError *error) {
                    [SVProgressHUD dismiss];
                    if (error == nil) {
                        self.sharedData.conversationId = feed.fromFbId;
                        self.sharedData.messagesPage.toId = feed.fromFbId;
                        self.sharedData.messagesPage.toLabel.text = [feed.fromFirstName uppercaseString];
                        self.sharedData.feedMatchEvent = feed.eventName;
                        self.sharedData.feedMatchImage = feed.fromImageURL;
                        self.sharedData.toImgURL = [self.sharedData profileImg:self.sharedData.fromMailId];
                        
                        if (self.feedIndex == self.feedData.count-1) {
                            [self.emptyView setMode:@"empty"];
                        }
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_FEED_MATCH"
                                                                            object:self];
                        
                    }
                }];
                break;
            }
            case FeedTypeViewed: {
                [Feed approveFeed:YES withFbId:feed.fromFbId andCompletionHandler:nil];
                break;
            }
        }
    } else {
        [Feed approveFeed:NO withFbId:feed.fbId andCompletionHandler:nil];
    }
}

#pragma mark - FeedCardViewDelegate
- (void)feedCardView:(FeedCardView *)view didTapButton:(UIButton *)button withFbId:(NSString *)fbId {
    if ([[button.titleLabel.text lowercaseString] isEqualToString:@"connect"]) {
        [self.swipeableView swipeTopViewToRight];
    } else if ([[button.titleLabel.text lowercaseString] isEqualToString:@"skip"]) {
        [self.swipeableView swipeTopViewToLeft];
    } else if ([[button.titleLabel.text lowercaseString] isEqualToString:@"yes"]) {
        [self.swipeableView swipeTopViewToRight];
    } else {
        [self.swipeableView swipeTopViewToLeft];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        self.sharedData.matchMe = NO;
        [self toggleMatch];
    } else {
        if (self.sharedData.matchMe) {
            [self.discoverImageView setImage:[UIImage imageNamed:@"discover_on"]];
            [self.discoverLabel setText:@"Turn off if you do not wish to be seen by others"];
        } else {
            [self.discoverImageView setImage:[UIImage imageNamed:@"discover_off"]];
            [self.discoverLabel setText:@"Turn on if you wish to be seen by others"];
        }
    }
}

@end
