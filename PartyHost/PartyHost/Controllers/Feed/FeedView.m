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
#import "SocialFilterView.h"
#import "UserManager.h"
#import "AnalyticManager.h"
#import "SVProgressHUD.h"
#import "MSRangeSlider.h"

#define POLL_SECONDS 25
#define CARD_VIEW_TAG 1900

@interface FeedView () <SocialFilterViewDelegate, ZLSwipeableViewDataSource, ZLSwipeableViewDelegate, FeedCardViewDelegate, UIAlertViewDelegate>

@property(strong, nonatomic) SharedData *sharedData;
@property(strong, nonatomic) NSMutableArray *feedData;
@property(assign, nonatomic) NSInteger feedIndex;

@property (strong, nonatomic) ZLSwipeableView *swipeableView;
@property (strong, nonatomic) EmptyView *emptyView;
@property (strong, nonatomic) SocialFilterView *filterView;
@property (strong, nonatomic) UIView *transparentView;

@property (assign, nonatomic) BOOL isSwipedOut;

@property (assign, nonatomic) BOOL isLoadedUserSetting;
@property (assign, nonatomic) BOOL isFilterChanges;

@end

@implementation FeedView

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
    
    self.isFilterChanges = NO;
    
    // Load cards from file if available
    NSArray *feeds = [Feed unarchiveObject];
    
    if (feeds) {
        self.feedData = [NSMutableArray arrayWithArray:feeds];
        if (feeds.count > 0) {
            [self.swipeableView loadViewsIfNeeded];
        } else {
            [self showEmptyView];
        }
    } else {
        [self loadDataAndShowHUD:NO withCompletionHandler:nil];
    }
    
    // Load user setting
    if (!self.isLoadedUserSetting) {
        NSDictionary *params = @{ @"fb_id" : self.sharedData.fb_id };
        NSString *url = [Constants memberSettingsURL];
        AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
        
        [self.emptyView setMode:@"load"];
        [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *responseString = operation.responseString;
            NSError *error;
            NSDictionary *json = (NSDictionary *)[NSJSONSerialization
                                                  JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]
                                                  options:kNilOptions
                                                  error:&error];
            dispatch_async(dispatch_get_main_queue(), ^{
                @try {
                    NSDictionary *data = [json objectForKey:@"data"];
                    if (data && data != nil) {
                        NSDictionary *membersettings = [data objectForKey:@"membersettings"];
                        if (membersettings && membersettings != nil) {
                            [UserManager saveUserSetting:membersettings];
                            [UserManager updateLocalSetting];
                        }
                    }
                }
                @catch (NSException *exception) {
                }
                @finally {
                }
                
                [self.emptyView setMode:@"hide"];
            });
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.emptyView setMode:@"hide"];
        }];
        
        self.isLoadedUserSetting = YES;
    }
}

- (Feed *)getFeedFromCardView:(UIView *)view {
    ShadowView *shadowView = (ShadowView*)view;
    Feed *feed = ((FeedCardView *)shadowView.subviews.lastObject).feed;
    
    return feed;
}

#pragma mark - Lazy Instantiation
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
                                                                 CGRectGetHeight([UIScreen mainScreen].bounds) - 200)];
        
        CGRect frame = [UIScreen mainScreen].bounds;
        [_emptyView setCenter:CGPointMake(frame.size.width / 2, frame.size.height / 2 + 40)];
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

- (SocialFilterView *)filterView {
    if (!_filterView) {
        _filterView = [SocialFilterView instanceFromNib];
        [_filterView setDelegate:self];
        _filterView.alpha = .0f;
        _filterView.frame = CGRectMake(0,
                                       62,
                                       CGRectGetWidth(self.bounds),
                                       308);
    }
    
    return _filterView;
}

- (UIView *)transparentView {
    if (!_transparentView) {
        _transparentView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                    60,
                                                                    CGRectGetWidth(self.bounds),
                                                                    CGRectGetHeight(self.bounds))];
        _transparentView.alpha = .0f;
        _transparentView.backgroundColor = [UIColor colorWithWhite:.0f alpha:0.3f];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(didTapFilterButton:)];
        [_transparentView addGestureRecognizer:tapGesture];
    }
    
    return _transparentView;
}

#pragma mark - Action
- (IBAction)discoverDidValueChanged:(UISwitch *)sender {
    if (!sender.isOn) {
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

- (IBAction)didTapFilterButton:(id)sender {
    if (self.filterView.alpha == .0f) {
        self.isFilterChanges = NO;
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.transparentView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.filterView];
    }
    
    [UIView animateWithDuration:0.2 delay:.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        if (self.filterView.alpha == 1.0f) {
            self.filterView.alpha = .0f;
            self.transparentView.alpha = .0f;
            [self.swipeableView setUserInteractionEnabled:YES];
        } else {
            self.filterView.alpha = 1.0f;
            self.transparentView.alpha = 1.0f;
            [self.swipeableView setUserInteractionEnabled:NO];
        }
    } completion:^(BOOL finished) {
        if (self.filterView.alpha == .0f) {
            [self.transparentView removeFromSuperview];
            [self.filterView removeFromSuperview];
            
            if (self.isFilterChanges) {
                AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
                NSString *url = [Constants memberSettingsURL];
                NSDictionary *params = [self.sharedData createSaveSettingsParams];
                
                [SVProgressHUD show];
                [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [SVProgressHUD dismiss];
                    if(responseObject[@"response"]) {
                        [self toggleMatch];
                        [self.sharedData saveSettingsResponse];
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [SVProgressHUD dismiss];
                }];
            }
        }
    }];
}

#pragma mark - Load Data
- (void)loadDataAndShowHUD:(BOOL)show withCompletionHandler:(PartyFeedCompletionHandler)completion {
    if (self.sharedData.fb_id == nil ||
        [self.sharedData.fb_id isEqualToString:@""]) {
        return;
    }
    
    if (show) {
        [SVProgressHUD show];
    } else {
        [self.emptyView setMode:@"load"];
    }
    
    [self.filterButton setEnabled:NO];
    [Feed retrieveFeedsWithCompletionHandler:^(NSArray *feeds, NSInteger statusCode, NSError *error) {
        if (show) {
            [SVProgressHUD dismiss];
        } else {
            [self.emptyView setMode:@"hide"];
        }
        
        self.feedIndex = 0;
        
        [self.filterButton setEnabled:YES];
        
        if (error) {
            [self.emptyView setMode:@"empty"];
            [SVProgressHUD showInfoWithStatus:@"Please check your internet connection"];
        } else {
            [self.feedData removeAllObjects];
            
            if ((!feeds || feeds.count == 0) && statusCode == 204) {
                [self showEmptyView];
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
        
        if (completion) {
            completion(feeds, statusCode, error);
        }
    }];
}

- (void)toggleMatch {
    [SVProgressHUD show];
    [Feed enableSocialFeed:self.sharedData.matchMe withCompletionHandler:^(NSError *error) {
        if (error) {
            [self.discoverSwitch setOn:!self.sharedData.matchMe animated:YES];
            [self setMatchViewToOn:!self.sharedData.matchMe];
        } else {
            [self.swipeableView setHidden:!self.sharedData.matchMe];
            [self.discoverSwitch setOn:self.sharedData.matchMe animated:YES];
            [self setMatchViewToOn:self.sharedData.matchMe];
            
            self.sharedData.feedBadge.hidden = !self.sharedData.matchMe;
            self.sharedData.feedBadge.canShow = self.sharedData.matchMe;
            
            [self.swipeableView discardAllViews];
            
            if (self.sharedData.matchMe) {
                [self loadDataAndShowHUD:YES withCompletionHandler:nil];
            } else {
                [self.emptyView setMode:@"hide"];
            }
            
            [[AnalyticManager sharedManager] trackMixPanelWithDict:@"Socialize Toggle" withDict:@{@"toggle":self.sharedData.matchMe ? @"yes" : @"no"}];
        }
        
        [SVProgressHUD dismiss];
    }];
}

- (void)approveFeed:(BOOL)approved withFeed:(Feed *)feed {
    if (approved) {
        switch (feed.type) {
            case FeedTypeApproved: {
                [self trackApprovedFeedItemWithType:feed.type];
                
                [SVProgressHUD show];
                [Feed approveFeed:approved withFbId:feed.fromFbId andCompletionHandler:^(NSError *error) {
                    [SVProgressHUD dismiss];
                    if (error == nil) {
                        self.sharedData.conversationId = feed.fromFbId;
                        self.sharedData.messagesPage.toId = feed.fromFbId;
                        self.sharedData.messagesPage.toLabel.text = [feed.fromFirstName uppercaseString];
                        self.sharedData.feedMatchEvent = feed.eventName;
                        self.sharedData.feedMatchImage = feed.fromImageURL;
                        self.sharedData.toImgURL = [self.sharedData profileImg:self.sharedData.fromMailId];
                        
                        if (self.feedData.count == 0) {
                            [self showEmptyView];
                        }
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_FEED_MATCH"
                                                                            object:self];
                        
                    }
                }];
                break;
            }
            case FeedTypeViewed: {
                [self trackDeniedFeedItemWithType:feed.type];
                [Feed approveFeed:YES withFbId:feed.fromFbId andCompletionHandler:^(NSError *error) {
                    if (self.feedData.count == 0) {
                        [self showEmptyView];
                    }
                }];
                break;
            }
        }
    } else {
        [Feed approveFeed:approved withFbId:feed.fromFbId andCompletionHandler:^(NSError *error) {
            if (self.feedData.count == 0) {
                [self showEmptyView];
            }
        }];
    }
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

- (void)showEmptyView {
    [self.emptyView setData:@"Check back soon"
                   subtitle:@"Browse some events and your social feed will show members who like the same events."
                 imageNamed:@"PickIcon"];
    [self.emptyView setMode:@"empty"];
}

- (void)setMatchViewToOn:(BOOL)matched {
    if (matched) {
        [self.discoverImageView setImage:[UIImage imageNamed:@"discover_on"]];
        [self.discoverLabel setText:@"Turn off if you do not wish to be seen by others"];
    } else {
        [self.discoverImageView setImage:[UIImage imageNamed:@"discover_off"]];
        [self.discoverLabel setText:@"Turn on if you wish to be seen by others"];
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

- (void)trackApprovedFeedItemWithType:(FeedType)type {
    NSString *val = @"";
    if ([self.sharedData.ABTestChat isEqualToString:@"YES"]) {
        val = @"Connect";
    } else {
        val = @"Chat";
    }
    
    AnalyticManager *analyticManager = [AnalyticManager sharedManager];
    [analyticManager trackMixPanelWithDict:@"Accept Feed Item" withDict:@{@"ABTestChat":val,
                                                                          @"feed_item_type":[Feed feedTypeAsString:type]}];
    
    [analyticManager trackMixPanelIncrementWithDict:@{@"feed_item_accept":@1}];
    [analyticManager trackMixPanelIncrementWithDict:@{@"feed_item_response":@1}];
}

- (void)trackDeniedFeedItemWithType:(FeedType)type {
    NSString *val = @"";
    if ([self.sharedData.ABTestChat isEqualToString:@"YES"]) {
        val = @"Connect";
    } else {
        val = @"Chat";
    }
    
    AnalyticManager *analyticManager = [AnalyticManager sharedManager];
    [analyticManager trackMixPanelWithDict:@"Passed Feed Item" withDict:@{@"ABTestChat":val,
                                                                          @"feed_item_type":[Feed feedTypeAsString:type]}];
    
    [analyticManager trackMixPanelIncrementWithDict:@{@"feed_item_passed":@1}];
    [analyticManager trackMixPanelIncrementWithDict:@{@"feed_item_response":@1}];
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
- (void)swipeableView:(ZLSwipeableView *)swipeableView didEndSwipingView:(UIView *)view atLocation:(CGPoint)location {
    if (self.isSwipedOut) {
        Feed *feed = [self getFeedFromCardView:view];
    
        [Feed archiveObject:self.feedData];
        
        if (location.x > CGRectGetWidth(self.bounds) / 2 ) {
            [self approveFeed:YES withFeed:feed];
        } else {
            [self approveFeed:NO withFeed:feed];
        }
        
        [self trackViewFeedItem];
    }
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView didCancelSwipe:(UIView *)view {
    self.isSwipedOut = NO;
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView didSwipeView:(UIView *)view inDirection:(ZLSwipeableViewDirection)direction {
    self.isSwipedOut = YES;
    [self.swipeableView setUserInteractionEnabled:NO];
    
    Feed *feed = [self getFeedFromCardView:view];
    [self.feedData removeObject:feed];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(0.7 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       NSInteger feedIndex = view.tag-CARD_VIEW_TAG;
                       NSInteger numberOfCardsLeft = self.feedData.count - feedIndex;
                       if (numberOfCardsLeft <= 0) {
                           [self loadDataAndShowHUD:NO withCompletionHandler:nil];
                       }
                       
                       [self.swipeableView setUserInteractionEnabled:YES];
                   });
}

#pragma mark - FeedCardViewDelegate
- (void)feedCardView:(FeedCardView *)view didTapButton:(UIButton *)button withFeed:(Feed *)feed {
    if ([[button.titleLabel.text lowercaseString] isEqualToString:@"connect"]) {
        [self.swipeableView swipeTopViewToRight];
        [self approveFeed:YES withFeed:feed];
    } else if ([[button.titleLabel.text lowercaseString] isEqualToString:@"skip"]) {
        [self.swipeableView swipeTopViewToLeft];
        [self approveFeed:NO withFeed:feed];
    } else if ([[button.titleLabel.text lowercaseString] isEqualToString:@"yes"]) {
        [self.swipeableView swipeTopViewToRight];
        [self approveFeed:YES withFeed:feed];
    } else {
        [self.swipeableView swipeTopViewToLeft];
        [self approveFeed:NO withFeed:feed];
    }
}

- (void)feedCardView:(FeedCardView *)view didTapPersonImageButton:(UIButton *)button withFeed:(Feed *)feed {
    self.sharedData.member_fb_id = feed.fromFbId;
    self.sharedData.member_user_id = feed.fromFbId;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_MEMBER_PROFILE"
                                                        object:self];
}

- (void)feedCardView:(FeedCardView *)view didTapEventNameLabel:(UILabel *)label withFeed:(Feed *)feed {
    self.sharedData.cEventId_Feed = feed.eventId;
    self.sharedData.cEventId_Modal = feed.eventId;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_EVENT_MODAL"
                                                        object:self];
}

#pragma mark - SocialFilterViewDelegate
- (void)socialFilterView:(SocialFilterView *)view discoverDidValueChanged:(UISwitch *)sender {
    if (sender.isOn) {
        self.sharedData.matchMe = YES;
    } else {
        self.sharedData.matchMe = NO;
    }
    
    self.isFilterChanges = YES;
}

- (void)socialFilterView:(SocialFilterView *)view interestDidValueChanged:(NSString *)genderInterest {
    if ([genderInterest isEqualToString:@"Women"]) {
        self.sharedData.gender_interest = @"female";
    } else if([genderInterest isEqualToString:@"Men"]) {
        self.sharedData.gender_interest = @"male";
    } else {
        self.sharedData.gender_interest = @"both";
    }
    
    self.isFilterChanges = YES;
}

- (void)socialFilterView:(SocialFilterView *)view distanceDidValueChanged:(UISlider *)sender {
    self.sharedData.distance = [NSString stringWithFormat:@"%d", (int)roundf(sender.value)];
    self.isFilterChanges = YES;
}

- (void)socialFilterView:(SocialFilterView *)view ageDidValueChanged:(MSRangeSlider *)sender {
    self.sharedData.from_age = [NSString stringWithFormat:@"%d", (int)roundf(sender.fromValue)];
    self.sharedData.to_age = [NSString stringWithFormat:@"%d", (int)roundf(sender.toValue)];
    self.isFilterChanges = YES;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        self.sharedData.matchMe = NO;
        [self toggleMatch];
    } else {
        [self.discoverSwitch setOn:YES animated:YES];
        [self setMatchViewToOn:self.sharedData.matchMe];
    }
}

@end
