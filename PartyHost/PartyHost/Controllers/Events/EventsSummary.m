//
//  EventsVenueDetail.m
//  PartyHost
//
//  Created by Sunny Clark on 2/14/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "EventsSummary.h"
#import "AnalyticManager.h"
#import "AppDelegate.h"
#import "EventDetail.h"
#import "BaseModel.h"
#import "SVProgressHUD.h"
#import "JDFTooltips.h"
#import "JGTooltipHelper.h"
#import "JGInviteHelper.h"
#import "EventsGuestList.h"
#import "UIView+Animation.h"
#import "UIImageView+WebCache.h"
#import "UserManager.h"
#import "Room.h"
#import "Firebase.h"

#define PROFILE_PICS 4 //If more than 4 then last is +MORE
#define PROFILE_SIZE 40
#define PROFILE_PADDING 4

@interface EventsSummary ()

@property (strong, nonatomic) FIRDatabaseReference *reference;

@end

@implementation EventsSummary {
    NSString *lastEventId;
    CGSize picSize;
}

@synthesize fetchedResultsController, managedObjectContext;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    lastEventId = @"";
    self.backgroundColor = [UIColor whiteColor];
    
    self.sharedData = [SharedData sharedInstance];
    
    self.mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     self.sharedData.screenWidth,
                                                                     self.sharedData.screenHeight - PHTabHeight)];
    self.mainScroll.showsVerticalScrollIndicator    = NO;
    self.mainScroll.showsHorizontalScrollIndicator  = NO;
    self.mainScroll.scrollEnabled                   = YES;
    self.mainScroll.userInteractionEnabled          = YES;
    self.mainScroll.delegate                        = self;
    self.mainScroll.backgroundColor                 = [UIColor whiteColor];
    self.mainScroll.contentSize                     = CGSizeMake(self.sharedData.screenWidth, 1000);
    [self addSubview:self.mainScroll];
    
    UIView *tmpPurpleView = [[UIView alloc] initWithFrame:CGRectMake(0, -300, self.sharedData.screenWidth, 300)];
    tmpPurpleView.backgroundColor = [UIColor phPurpleColor];
    [self.mainScroll addSubview:tmpPurpleView];
    
    //Inner bg
    self.innerBg = [[UIView alloc] init];
    self.innerBg.backgroundColor = [UIColor whiteColor];
    [self.mainScroll addSubview:self.innerBg];
    
    //calculate picture size
    CGFloat pictureHeightRatio = 3.0 / 4.0;
    picSize = CGSizeMake(self.sharedData.screenWidth, pictureHeightRatio * self.sharedData.screenWidth);
    
    //Scrollable pictures
    self.picScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, picSize.width, picSize.height)];
    self.picScroll.showsVerticalScrollIndicator    = NO;
    self.picScroll.showsHorizontalScrollIndicator  = NO;
    self.picScroll.scrollEnabled                   = YES;
    self.picScroll.userInteractionEnabled          = YES;
    self.picScroll.pagingEnabled                   = YES;
    self.picScroll.delegate                        = self;
    self.picScroll.backgroundColor                 = [UIColor phDarkGrayColor];
    [self.mainScroll addSubview:self.picScroll];
    
    //Black fade bottom
    UIView *gradientView = [[UIView alloc] initWithFrame:CGRectMake(0,20,self.sharedData.screenWidth,50)];
    gradientView.userInteractionEnabled = NO;
    CAGradientLayer *gradientMask = [CAGradientLayer layer];
    gradientMask.frame = gradientView.bounds;
    gradientMask.colors = @[(id)[UIColor phDarkBodyColor].CGColor,(id)[UIColor colorWithWhite:0 alpha:0].CGColor];
    gradientMask.locations = @[@0.00,@1.00];
    [gradientView.layer insertSublayer:gradientMask atIndex:0];
    //[self addSubview:gradientView];
    
    //Picture paging
    self.pControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.picScroll.frame.size.height - 50, self.sharedData.screenWidth, 50)];
    self.pControl.userInteractionEnabled = NO;
    [self.mainScroll addSubview:self.pControl];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(0.0f, 20.0f, 40.0f, 40.0f)];
    [closeButton setImage:[UIImage imageNamed:@"nav_back_shadow"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScroll addSubview:closeButton];
    
    self.likeButton = [[UIButton alloc] initWithFrame:CGRectMake(11, CGRectGetMaxY(self.picScroll.frame) + 10, 40, 40)];
    [self.likeButton setImage:[UIImage imageNamed:@"icon_love_off"] forState:UIControlStateNormal];
    [self.likeButton setImage:[UIImage imageNamed:@"icon_love_on"] forState:UIControlStateSelected];
    [self.likeButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [self.likeButton addTarget:self action:@selector(likeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScroll addSubview:self.likeButton];
    
    self.likeCount = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.likeButton.frame) + 8, CGRectGetMaxY(self.picScroll.frame) + 20, 25, 20)];
    self.likeCount.textColor = [UIColor darkGrayColor];
    self.likeCount.adjustsFontSizeToFitWidth = YES;
    self.likeCount.font = [UIFont phBlond:15];
    [self.mainScroll addSubview:self.likeCount];
    
    self.chatButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.likeCount.frame) + 11, CGRectGetMaxY(self.picScroll.frame) + 10, 40, 40)];
    [self.chatButton setImage:[UIImage imageNamed:@"event-chat-icon"] forState:UIControlStateNormal];
    [self.chatButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [self.chatButton addTarget:self action:@selector(chatButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScroll addSubview:self.chatButton];
    
    self.membersCount = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.chatButton.frame) + 8, CGRectGetMaxY(self.picScroll.frame) + 20, 65, 20)];
    self.membersCount.textColor = [UIColor darkGrayColor];
    self.membersCount.adjustsFontSizeToFitWidth = YES;
    self.membersCount.font = [UIFont phBlond:15];
    self.membersCount.text = @"Chat";
    [self.mainScroll addSubview:self.membersCount];
    
    self.shareButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.membersCount.frame) + 11, CGRectGetMaxY(self.picScroll.frame) + 10, 40, 40)];
    [self.shareButton setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
    [self.shareButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [self.shareButton addTarget:self action:@selector(goShareHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScroll addSubview:self.shareButton];
    
    UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.shareButton.frame) + 8, CGRectGetMaxY(self.picScroll.frame) + 20, 40, 20)];
    shareLabel.text = @"Share";
    shareLabel.textColor = [UIColor darkGrayColor];
    shareLabel.adjustsFontSizeToFitWidth = YES;
    shareLabel.font = [UIFont phBlond:15];
    [self.mainScroll addSubview:shareLabel];
    
    self.infoView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.picScroll.frame) - 60, self.sharedData.screenWidth, 60)];
    [self.mainScroll addSubview:self.infoView];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 &&
        !UIAccessibilityIsReduceTransparencyEnabled()) {
        self.infoView.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = self.infoView.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.infoView addSubview:blurEffectView];
        self.infoView.alpha = 0.6;
    } else {
        self.infoView.backgroundColor = [UIColor blackColor];
        self.infoView.alpha = 0.4;
    }
    
    self.startFromLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(self.picScroll.frame) - 50, self.sharedData.screenWidth - 32, 18)];
    self.startFromLabel.textColor = [UIColor whiteColor];
    self.startFromLabel.text = @"Starts From";
    self.startFromLabel.font = [UIFont phBlond:12];
    [self.mainScroll addSubview:self.startFromLabel];
    
    self.minimumPrice = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(self.picScroll.frame) - 32, self.sharedData.screenWidth - 32, 20)];
    self.minimumPrice.textColor = [UIColor whiteColor];
    self.minimumPrice.text = @"FREE";
    self.minimumPrice.font = [UIFont phBold:18];
    [self.mainScroll addSubview:self.minimumPrice];
    
    self.eventName = [[UILabel alloc] init];
    self.eventName.textAlignment = NSTextAlignmentLeft;
    self.eventName.textColor = [UIColor blackColor];
    self.eventName.font = [UIFont phBold:16];
    self.eventName.userInteractionEnabled = NO;
    self.eventName.adjustsFontSizeToFitWidth = YES;
    self.eventName.numberOfLines = 3;
    [self.mainScroll addSubview:self.eventName];
    
    self.eventDate = [[UILabel alloc] init];
    self.eventDate.textAlignment = NSTextAlignmentLeft;
    self.eventDate.textColor = [UIColor darkGrayColor];
    self.eventDate.font = [UIFont phBlond:13];
    self.eventDate.userInteractionEnabled = NO;
    self.eventDate.adjustsFontSizeToFitWidth = YES;
    self.eventDate.numberOfLines = 2;
    [self.mainScroll addSubview:self.eventDate];
    
    self.venueName = [[UILabel alloc] init];
    self.venueName.font = [UIFont phBlond:13];
    self.venueName.textAlignment = NSTextAlignmentLeft;
    self.venueName.textColor = [UIColor darkGrayColor];
    self.venueName.userInteractionEnabled = NO;
    self.venueName.backgroundColor = [UIColor clearColor];
    self.venueName.adjustsFontSizeToFitWidth = YES;
    self.venueName.numberOfLines = 3;
    [self.mainScroll addSubview:self.venueName];
    
    self.separator1 = [[UIView alloc] init];
    self.separator1.backgroundColor = [UIColor phLightGrayColor];
    [self.mainScroll addSubview:self.separator1];
    
    self.listingContainer = [[UIView alloc] init];
    [self.mainScroll addSubview:self.listingContainer];
    UITapGestureRecognizer *seeAllTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infoButtonClicked)];
    [self.listingContainer addGestureRecognizer:seeAllTap];
    
    self.guestInterestedLabel = [[UILabel alloc] init];
    self.guestInterestedLabel.text = @"GUEST INTERESTED";
    self.guestInterestedLabel.textAlignment = NSTextAlignmentLeft;
    self.guestInterestedLabel.textColor = [UIColor blackColor];
    self.guestInterestedLabel.font = [UIFont phBold:13];
    self.guestInterestedLabel.userInteractionEnabled = NO;
    self.guestInterestedLabel.adjustsFontSizeToFitWidth = YES;
    [self.listingContainer addSubview:self.guestInterestedLabel];
    
    self.hostNum = [[UILabel alloc] init];
    self.hostNum.textColor = [UIColor phBlueColor];
    self.hostNum.font = [UIFont phBold:12];
    [self.listingContainer addSubview:self.hostNum];
    
    self.userContainer = [[UIView alloc] init];
    self.userContainer.backgroundColor = [UIColor clearColor];
    [self.listingContainer addSubview:self.userContainer];
    
    KTCenterFlowLayout *layout = [KTCenterFlowLayout new];
    layout.minimumInteritemSpacing = 8.f;
    layout.minimumLineSpacing = 8.f;
    
    self.tagCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.tagCollection registerClass:[SetupPickViewCell class] forCellWithReuseIdentifier:@"EventsSummaryTagCell"];
    self.tagCollection.delegate = self;
    self.tagCollection.dataSource = self;
    self.tagCollection.backgroundColor = [UIColor clearColor];
    [self.mainScroll addSubview:self.tagCollection];
    
    self.separator2 = [[UIView alloc] init];
    self.separator2.backgroundColor = [UIColor phLightGrayColor];
    [self.mainScroll addSubview:self.separator2];
    
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.text = @"DESCRIPTION";
    self.descriptionLabel.textAlignment = NSTextAlignmentLeft;
    self.descriptionLabel.textColor = [UIColor blackColor];
    self.descriptionLabel.font = [UIFont phBold:13];
    self.descriptionLabel.userInteractionEnabled = NO;
    self.descriptionLabel.adjustsFontSizeToFitWidth = YES;
    [self.mainScroll addSubview:self.descriptionLabel];
    
    self.aboutBody = [[UITextView alloc] init];
    self.aboutBody.font = [UIFont phBlond:13];
    self.aboutBody.textColor = [UIColor darkGrayColor];
    self.aboutBody.textAlignment = NSTextAlignmentLeft;
    self.aboutBody.userInteractionEnabled = NO;
    self.aboutBody.backgroundColor = [UIColor clearColor];
    [self.mainScroll addSubview:self.aboutBody];
    
    self.seeMapView = [[UIView alloc] init];
    self.seeMapView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *seeMapTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAddressInMap)];
    [self.seeMapView addGestureRecognizer:seeMapTap];
    [self.mainScroll addSubview:self.seeMapView];
    
    self.seeMapLabel = [[UILabel alloc] init];
    self.seeMapLabel.font = [UIFont phBlond:13];
    self.seeMapLabel.textAlignment = NSTextAlignmentCenter;
    self.seeMapLabel.textColor = [UIColor darkGrayColor];
    self.seeMapLabel.userInteractionEnabled = NO;
    self.seeMapLabel.backgroundColor = [UIColor clearColor];
    self.seeMapLabel.adjustsFontSizeToFitWidth = YES;
    self.seeMapLabel.numberOfLines = 2;
    [self.mainScroll addSubview:self.seeMapLabel];
    
    self.seeMapCaret = [[UIImageView alloc] init];
    self.seeMapCaret.image = [[UIImage imageNamed:@"btn_forward"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.seeMapCaret.tintColor = [UIColor lightGrayColor];
    [self.mainScroll addSubview:self.seeMapCaret];
    
    self.mapView = [[MKMapView alloc] init];
    self.mapView.userInteractionEnabled = YES;
    self.mapView.delegate = self;
    self.mapView.hidden = YES;
    [self.mainScroll addSubview:self.mapView];

    //Create big HOST HERE button
    self.btnHostHere = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.btnHostHere.frame = CGRectMake(0, self.sharedData.screenHeight - 44 - PHTabHeight, self.sharedData.screenWidth, 44);
    self.btnHostHere.titleLabel.font = [UIFont phBold:15];
    [self.btnHostHere setTitle:@"" forState:UIControlStateNormal];
    [self.btnHostHere setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0,0)];
    [self.btnHostHere setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnHostHere setBackgroundColor:[UIColor phBlueColor]];
    [self.btnHostHere addTarget:self action:@selector(hostHereButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnHostHere];
    
    self.externalSiteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 31, self.sharedData.screenWidth, 10)];
    self.externalSiteLabel.font = [UIFont phBlond:7];
    self.externalSiteLabel.textColor = [UIColor whiteColor];
    self.externalSiteLabel.text = @"(EXTERNAL SITE)";
    self.externalSiteLabel.textAlignment = NSTextAlignmentCenter;
    self.externalSiteLabel.hidden = YES;
    [self.btnHostHere addSubview:self.externalSiteLabel];
    
    self.emptyView = [[EmptyView alloc] initWithFrame:CGRectMake(0,
                                                                0,
                                                                self.sharedData.screenWidth,
                                                                self.sharedData.screenHeight - PHTabHeight)];
    [self.emptyView setData:@"The event is no longer available" subtitle:@"" imageNamed:@""];
    self.emptyView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.emptyView];
    
    //Nav Bar
    self.navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 60)];
    self.navBar.backgroundColor = [UIColor phPurpleColor];
    [self addSubview:self.navBar];
    
    self.btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnBack.frame = CGRectMake(0, 20, 40, 40);
    [self.btnBack setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [self.btnBack setImageEdgeInsets:UIEdgeInsetsMake(8, 14, 8, 14)];
    [self.btnBack addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:self.btnBack];
    
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, self.sharedData.screenWidth - 80, 40)];
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.textColor = [UIColor whiteColor];
    self.title.adjustsFontSizeToFitWidth = YES;
    self.title.font = [UIFont phBlond:15];
    [self.navBar addSubview:self.title];
    
    // hides navbar
    [self showNavBar:NO withAnimation:NO];
    
    //version_3.0
    return self;
}

-(void)reset
{
    self.btnHostHere.hidden = YES;
    
    if([lastEventId isEqualToString:self.event_id]) return;
    if(self.event_id!=nil) lastEventId = [NSString stringWithString:self.event_id];
    
    [self.emptyView setMode:@"load"];
    
    //Clear NavBar
    self.title.text = @"";
    self.eventName.text = @"";
    
    [self.likeButton setEnabled:NO];
    [self.likeButton setSelected:NO];
    
    [self.likeCount setText:@"Chat"];
    
    self.separator1.hidden = YES;
    
    self.separator2.hidden = YES;
    
    self.descriptionLabel.hidden = YES;
    
    //Clear text
    [self.btnHostHere setTitle:@"" forState:UIControlStateNormal];
    
    //Clear pics
    self.picScroll.contentOffset = CGPointMake(0, 0);
    [self.picScroll.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    //Clear users
    [self.userContainer.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    //Clear tags
    [self.tagArray removeAllObjects];
    [self.tagCollection reloadData];
    
    //Title
    self.venueName.text = @"";
    self.aboutBody.text = @"";
    self.hostNum.text = @"";
    self.eventDate.text = @"";
    
    //See map
    self.seeMapView.hidden = YES;
    self.seeMapCaret.hidden = YES;
    self.seeMapLabel.text = @"";
    
    //Clear ID
    self.sharedData.cEventId_Summary = @"";
    
    //Rescroll
    self.mainScroll.contentOffset = CGPointMake(0, 0);
    [self.mainScroll setFrame:CGRectMake(0,
                                         0,
                                         self.sharedData.screenWidth,
                                         self.sharedData.screenHeight - PHTabHeight)];
    
    self.isLoaded = NO;
}

#pragma mark - Initialization
-(void)initClassWithEvent:(Event *)event
{
    self.cEvent = nil;
    
    if (event) {
        self.cEvent = event;
        self.event_id = event.eventID;
    }
    
    [self reset];
    
    if ([self reloadFetch:nil]) {
        if ([[self.fetchedResultsController fetchedObjects] count]>0 && event) {
            [self populateData:nil];
        } else if (event) {
            [self loadPreloadData];
        }
    }
    
    if (event) {
        [self loadData:event.eventID];
    }
}

-(void)initClassWithEventID:(NSString *)eventID
{
    self.cEvent = nil;
    
    if (eventID) {
        self.event_id = eventID;
    }
    
    [self reset];
    
    if ([self reloadFetch:nil]) {
        if ([[self.fetchedResultsController fetchedObjects] count]>0) {
            [self populateData:nil];
        } else if (eventID) {
           [self loadData:eventID];
        }
    }
}

- (void)initClassModalWithEventID:(NSString *)eventID {
    [self initClassWithEventID:eventID];
    self.isModal = YES;
}

#pragma mark - Navigation
-(void)goBack
{
    if (self.isModal) {
        [self dismissViewAnimated:YES completion:nil];
    } else {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"EVENTS_GO_BACK"
         object:self];
    }
    
    [self.reference removeAllObservers];
}

- (void)showNavBar:(BOOL)isShow withAnimation:(BOOL)isAnimated {
    self.isNavBarShowing = isShow;
    
    CGFloat animateDuration = 0.0;
    if (isAnimated) {
        animateDuration = 0.25;
    }
    
    if (isShow) {
        [UIView animateWithDuration:animateDuration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.navBar setFrame:CGRectMake(0, 0, self.navBar.bounds.size.width, self.navBar.bounds.size.height)];
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [UIView animateWithDuration:animateDuration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.navBar setFrame:CGRectMake(0, - self.navBar.bounds.size.height, self.navBar.bounds.size.width, self.navBar.bounds.size.height)];
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark - Button Action
-(void)goShareHandler
{
//    NSLog(@">>> %@",self.sharedData.selectedHost);
    /*
     //Everything needed for share link
     self.sharedData.shareHostingId = self.sharedData.selectedHost[@"hosting"][@"_id"];
     self.sharedData.shareHostingVenueName = self.sharedData.selectedEvent[@"venue_name"];
     self.sharedData.shareHostingHostName = self.sharedData.selectedHost[@"first_name"];
     self.sharedData.shareHostingHostFbId = self.sharedData.selectedHost[@"fb_id"];
     self.sharedData.shareHostingHostDate = self.sharedData.selectedHost[@"hosting"][@"start_datetime_str"];
     self.sharedData.cHostVenuePicURL = [Constants eventImageURL:self.sharedData.selectedEvent[@"_id"]]; //Need for SHARE HOSTING
     */
    
    @try {
        [self.sharedData.mixPanelCEventDict removeAllObjects];
        [self.sharedData.mixPanelCEventDict setObject:self.sharedData.eventDict[@"_id"] forKey:@"Event Id"];
        [self.sharedData.mixPanelCEventDict setObject:self.sharedData.eventDict[@"title"] forKey:@"Event Name"];
        [self.sharedData.mixPanelCEventDict setObject:self.sharedData.eventDict[@"start_datetime_str"] forKey:@"Event Start Time"];
        [self.sharedData.mixPanelCEventDict setObject:self.sharedData.eventDict[@"end_datetime_str"] forKey:@"Event End Time"];
        [self.sharedData.mixPanelCEventDict setObject:self.sharedData.eventDict[@"description"] forKey:@"Event Description"];
        [self.sharedData.mixPanelCEventDict setObject:self.sharedData.eventDict[@"venue_name"] forKey:@"Event Venue Name"];
        [self.sharedData.mixPanelCEventDict setObject:self.sharedData.eventDict[@"venue"][@"neighborhood"] forKey:@"Event Venue Neighborhood"];
        [self.sharedData.mixPanelCEventDict setObject:self.sharedData.eventDict[@"venue"][@"city"] forKey:@"Event Venue City"];
        [self.sharedData.mixPanelCEventDict setObject:self.sharedData.eventDict[@"venue"][@"description"] forKey:@"Event Venue Description"];
        [self.sharedData.mixPanelCEventDict setObject:self.sharedData.eventDict[@"venue"][@"zip"] forKey:@"Event Venue Zip"];
        NSArray *mixpanelTags = self.sharedData.eventDict[@"tags"];
        if (mixpanelTags && mixpanelTags != nil) {
            [self.sharedData.mixPanelCEventDict setObject:mixpanelTags forKey:@"Event Tags"];
        }
        
        NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] init];
        [tmpDict setObject:self.sharedData.userDict[@"first_name"] forKey:@"Inviter First Name"];
        [tmpDict setObject:self.sharedData.userDict[@"last_name"] forKey:@"Inviter Last Name"];
        [tmpDict setObject:[NSString stringWithFormat:@"%@ %@",self.sharedData.userDict[@"first_name"],self.sharedData.userDict[@"last_name"]] forKey:@"Inviter Whole Name"];
        [tmpDict setObject:self.sharedData.userDict[@"fb_id"] forKey:@"Inviter FB ID"];
        [tmpDict setObject:self.sharedData.userDict[@"email"] forKey:@"Inviter Email"];
        [tmpDict setObject:self.sharedData.userDict[@"gender"] forKey:@"Inviter Gender"];
        [tmpDict setObject:self.sharedData.userDict[@"birthday"] forKey:@"Inviter Birthday"];
        [tmpDict setObject:@"event" forKey:@"type"];
        
        [self.sharedData.mixPanelCEventDict addEntriesFromDictionary:tmpDict];
        
        self.sharedData.shareHostingId = self.event_id;
        
        if (self.cEvent != nil) {
            self.sharedData.shareHostingVenueName = self.cEvent.title;
            
            self.sharedData.cHostVenuePicURL = self.cEvent.photo;
        } else {
            self.sharedData.shareHostingVenueName = self.sharedData.eventDict[@"venue_name"];
            
            self.sharedData.cHostVenuePicURL = self.sharedData.eventDict[@"photos"][0];
        }
        
        [JGTooltipHelper setShowed:@"Tooltip_ShareEvent_isShowed"];
        
        [[AnalyticManager sharedManager] trackMixPanelWithDict:@"Share Event" withDict:self.sharedData.mixPanelCEventDict];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_HOSTING_INVITE" object:self];
    }
    @catch (NSException *exception) {
        NSLog(@"SHARE_ERROR");
    }
    @finally {
        
    }
    
}

//Clicked 3 dots
-(void)infoButtonClicked
{
    //[self.sharedData trackMixPanelWithDict:@"Share Hosting" withDict:@{@"origin":@"HostDetails"}];
    if (self.isModal) {
        EventsGuestList *guestList = [[EventsGuestList alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [guestList loadModalData:self.sharedData.selectedEvent[@"_id"]];
        
        [self presentView:guestList
              withOverlay:NO
                 animated:YES
               completion:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"EVENTS_GO_GUEST_LIST"
                                                            object:self];
    }
}

//Go to the ADD HOSTING screen
-(void)hostHereButtonClicked:(UIButton *)button
{
    
    NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] init];
    [tmpDict addEntriesFromDictionary:self.sharedData.mixPanelCEventDict];
    [tmpDict setObject:self.fillValue forKey:@"fulfillment_value"];
    [tmpDict setObject:self.fillType forKey:@"fulfillment_type"];
    
    [[AnalyticManager sharedManager] trackMixPanelWithDict:@"Fufillment Request" withDict:tmpDict];
    [[AnalyticManager sharedManager] trackMixPanelIncrementWithDict:@{@"fulfillment_request":@1}];
    
    if([self.fillType isEqualToString:@"phone_number"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",self.fillValue]]];
    }
    
    if([self.fillType isEqualToString:@"link"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.fillValue]];
    }
    
    if([self.fillType isEqualToString:@"reservation"] || [self.fillType isEqualToString:@"purchase"])
    {
//        self.sharedData.cEventId_toLoad = self.mainDict[@"_id"];
//        
//        [self.sharedData.cAddEventDict removeAllObjects];
//        [self.sharedData.cAddEventDict addEntriesFromDictionary:self.mainDict];
//        
//        
//        
//        [[NSNotificationCenter defaultCenter]
//         postNotificationName:@"SHOW_BOOKTABLE"
//         object:self];
    }
    
    if([self.fillType isEqualToString:@"ticket"]) {
        
        // TICKET ACTION
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"SHOW_TICKET_LIST"
         object:self.event_id];

    }
}

- (void)likeButtonDidTap:(id)sender {
    UIButton *likeButton = (UIButton *)sender;
    
    if ([likeButton isSelected]) {
        [likeButton setSelected:NO];
        
        NSInteger likeCount = [self.likeCount.text integerValue];
        likeCount--;
        [self.likeCount setText:[NSString stringWithFormat:@"%li", (long)likeCount]];
        
        [self postLikeEvent:NO];
        
        [[AnalyticManager sharedManager] trackMixPanelWithDict:@"Unlike Event Details" withDict:self.sharedData.mixPanelCEventDict];
    } else {
        [likeButton setSelected:YES];

        NSInteger likeCount = [self.likeCount.text integerValue];
        likeCount++;
        [self.likeCount setText:[NSString stringWithFormat:@"%li", (long)likeCount]];
        
        [self postLikeEvent:YES];
        
        [[AnalyticManager sharedManager] trackMixPanelWithDict:@"Like Event Details" withDict:self.sharedData.mixPanelCEventDict];
    }
}

- (void)chatButtonDidTap:(id)sender {
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    NSString *url = [NSString stringWithFormat:@"%@/group/firebase", PHBaseNewURL];
    NSDictionary *parameters = @{@"fb_id" : self.sharedData.fb_id,
                                 @"event_id" : self.event_id};
    
    [SVProgressHUD show];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == 200) {
            NSDictionary *object = @{@"roomId" : self.event_id,
                                     @"members" : @{},
                                     @"eventName" : self.eventName.text};
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_MESSAGES"
                                                                object:object];
        }
        
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - Fetch
- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *globalManagedObjectContext = [appDelegate managedObjectContext];
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDescription =
    [NSEntityDescription entityForName:NSStringFromClass([EventDetail class])
                inManagedObjectContext:globalManagedObjectContext];
    NSSortDescriptor *sortDescriptor =
    [NSSortDescriptor sortDescriptorWithKey:@"modified"
                                  ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    [fetchRequest setSortDescriptors:sortDescriptors];
    if (self.event_id) {
        NSPredicate *eventPredicate = [NSPredicate predicateWithFormat:@"eventID = %@", self.event_id];
        [fetchRequest setPredicate:eventPredicate];
    } else {
        [fetchRequest setPredicate:nil];
    }
    
    fetchedResultsController = nil;
    fetchedResultsController = [[NSFetchedResultsController alloc]
                                initWithFetchRequest:fetchRequest
                                managedObjectContext:globalManagedObjectContext
                                sectionNameKeyPath:nil
                                cacheName:@"eventDetailListCache"];
    [fetchedResultsController setDelegate:self];
    
    return fetchedResultsController;
}

- (BOOL)reloadFetch:(NSError **)error {
    //    NSLog(@"--- reloadAndPerformFetch");
    // delete cache
    [NSFetchedResultsController deleteCacheWithName:@"eventDetailListCache"];
    if(fetchedResultsController){
        [fetchedResultsController setDelegate:nil];
        fetchedResultsController = nil;
    }
    
    BOOL performFetchResult = [[self fetchedResultsController] performFetch:error];
    
    return performFetchResult;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self populateData:self.sharedData.eventDict];
}

#pragma mark - API
-(void)loadPreloadData {
    [self.emptyView setMode:@"hide"];
    
    [self.mainScroll setFrame:CGRectMake(0,
                                         0,
                                         self.sharedData.screenWidth,
                                         self.sharedData.screenHeight - PHTabHeight)];
    
    //ID
    self.sharedData.cEventId_Summary = self.cEvent.eventID;
    
    if ([self.cEvent.fullfillmentType isEqualToString:@"ticket"]) {
        if (self.cEvent.lowestPrice.integerValue > 0) {
            SharedData *sharedData = [SharedData sharedInstance];
            NSString *formattedPrice = [sharedData formatCurrencyString:self.cEvent.lowestPrice.stringValue];
            [self.minimumPrice setText:[NSString stringWithFormat:@"Rp%@", formattedPrice]];
        } else {
            [self.minimumPrice setText:@"FREE"];
        }
        
        self.infoView.hidden = NO;
        self.minimumPrice.hidden = NO;
        self.startFromLabel.hidden = NO;
        
    } else {
        self.infoView.hidden = YES;
        self.minimumPrice.hidden = YES;
        self.startFromLabel.hidden = YES;
    }
        
    //Title
    self.title.text = [self.cEvent.title uppercaseString];

    self.eventName.text = [self.cEvent.title uppercaseString];
    self.eventName.frame = CGRectMake(16, CGRectGetMaxY(self.likeButton.frame) + 16, self.sharedData.screenWidth - 32, 60);
    [self.eventName sizeToFit];
    
    self.eventDate.text = [Constants toTitleDate:self.cEvent.startDatetime dbEndDate:self.cEvent.endDatetime];
    self.eventDate.frame = CGRectMake(16, CGRectGetMaxY(self.eventName.frame) + 12, self.sharedData.screenWidth-80, 40);
    [self.eventDate sizeToFit];

    self.venueName.text = [self.cEvent.venue uppercaseString];
    self.venueName.frame = CGRectMake(16, CGRectGetMaxY(self.eventDate.frame) + 12, self.sharedData.screenWidth - 32, 60);
    [self.venueName sizeToFit];
    
    //Likes
    self.likeCount.text = [NSString stringWithFormat:@"%@", self.cEvent.likes];
    
    //Page control
    self.pControl.currentPage = 0;
    self.pControl.numberOfPages = 0;
    
    //Load pics
    [self.picScroll.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    self.picScroll.contentOffset = CGPointMake(0, 0);
    UIView *imgCon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, picSize.width, picSize.height)];
    imgCon.layer.masksToBounds = YES;
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indicatorView setFrame:CGRectMake(0, 0, picSize.width, picSize.height)];
    [imgCon addSubview:indicatorView];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, picSize.width, picSize.height)];
    img.contentMode = UIViewContentModeScaleAspectFill;
    NSString *picURL = self.cEvent.photo;
    [img sd_setImageWithURL:[NSURL URLWithString:picURL]
           placeholderImage:nil];
    [imgCon addSubview:img];
    [self.picScroll addSubview:imgCon];
    
    self.picScroll.contentSize = CGSizeMake(picSize.width, picSize.height);

    self.tagCollection.frame = CGRectMake(20, self.venueName.frame.size.height + self.venueName.frame.origin.y, self.sharedData.screenWidth - 40, 0);
    
    //Separator 1
    self.separator1.frame = CGRectMake(0,self.tagCollection.frame.size.height + self.tagCollection.frame.origin.y + 20, self.sharedData.screenWidth, 1);
    self.separator1.hidden = NO;
    
    self.mainScroll.contentSize = CGSizeMake(self.sharedData.screenWidth, self.separator1.frame.origin.y + 30);
    
}

- (void)loadData:(NSString*)event_id {
    self.event_id = event_id;
    self.sharedData.cEventId_Summary = event_id;
    
    self.reference = [[Room membersReference] child:event_id];
    [self.reference observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (![snapshot.value isEqual:[NSNull null]]) {
            NSUInteger totalMembers = [snapshot.value allKeys].count;
            if (totalMembers > 99) {
                [self.membersCount setText:@"Chat (99+)"];
            } else {
                [self.membersCount setText:[NSString stringWithFormat:@"Chat (%lu)", (unsigned long)totalMembers]];
            }
        } else {
            [self.membersCount setText:@"Chat"];
        }
    }];
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    NSString *url = nil;
    if(self.sharedData.isGuest && ![self.sharedData isMember]) url = [Constants hostListingsURL:event_id fb_id:self.sharedData.fb_id];
    else url = [Constants guestListingsURL:event_id fb_id:self.sharedData.fb_id];
    
    url = [NSString stringWithFormat:@"%@/event/details/%@/%@/%@",PHBaseNewURL,event_id,self.sharedData.fb_id,self.sharedData.gender_interest];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //[self.sharedData trackMixPanelWithDict:@"View Host Listings" withDict:@{}];
         
         NSInteger responseStatusCode = operation.response.statusCode;
         if (responseStatusCode == 204) {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Event Removed" message:@"The event is no longer available." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             alert.tag = 1;
             [alert show];
             
             [self goBack];
             
             [self.emptyView setMode:@"empty"];
             
             return;
         }
         
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
                     NSDictionary *eventDetail = [data objectForKey:@"event_detail"];
                     if (!eventDetail || eventDetail.count == 0) {
                         return;
                     }
                    
                     //Store this object for further pages
                     [self.sharedData.mixPanelCEventDict removeAllObjects];
                     [self.sharedData.mixPanelCEventDict setObject:eventDetail[@"title"] forKey:@"Event Name"];
                     [self.sharedData.mixPanelCEventDict setObject:eventDetail[@"start_datetime_str"] forKey:@"Event Start Time"];
                     [self.sharedData.mixPanelCEventDict setObject:eventDetail[@"end_datetime_str"] forKey:@"Event End Time"];
                     [self.sharedData.mixPanelCEventDict setObject:eventDetail[@"description"] forKey:@"Event Description"];
                     [self.sharedData.mixPanelCEventDict setObject:eventDetail[@"venue_name"] forKey:@"Event Venue Name"];
                     [self.sharedData.mixPanelCEventDict setObject:eventDetail[@"venue"][@"neighborhood"] forKey:@"Event Venue Neighborhood"];
                     [self.sharedData.mixPanelCEventDict setObject:eventDetail[@"venue"][@"city"] forKey:@"Event Venue City"];
                     [self.sharedData.mixPanelCEventDict setObject:eventDetail[@"venue"][@"description"] forKey:@"Event Venue Description"];
                     [self.sharedData.mixPanelCEventDict setObject:eventDetail[@"venue"][@"zip"] forKey:@"Event Venue Zip"];
                     NSArray *mixpanelTags = [eventDetail objectForKey:@"tags"];
                     if (mixpanelTags && mixpanelTags != nil) {
                         [self.sharedData.mixPanelCEventDict setObject:mixpanelTags forKey:@"Event Tags"];
                     }
                     
                     [self.sharedData.eventDict removeAllObjects];
                     [self.sharedData.eventDict addEntriesFromDictionary:eventDetail];
                     
                     [[AnalyticManager sharedManager] trackMixPanelWithDict:@"View Event Details" withDict:self.sharedData.mixPanelCEventDict];
                     
                     NSPredicate *eventPredicate = [NSPredicate predicateWithFormat:@"eventID = %@", [eventDetail objectForKey:@"_id"]];
                     NSArray *fetchEventDetail = [BaseModel fetchManagedObject:self.managedObjectContext
                                                                      inEntity:NSStringFromClass([EventDetail class])
                                                                  andPredicate:eventPredicate];
                     
                     for (EventDetail *fetchEvent in fetchEventDetail) {
                         if ([fetchEvent.eventID isEqualToString:[eventDetail objectForKey:@"_id"]]) {
                             [self.managedObjectContext deleteObject:fetchEvent];
                         }
                     }
                     
                     EventDetail *item = (EventDetail *)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([EventDetail class])
                                                                                      inManagedObjectContext:self.managedObjectContext];
                     
                     NSString *title = [eventDetail objectForKey:@"title"];
                     if (title && ![title isEqual:[NSNull null]]) {
                         item.title = title;
                     } else {
                         item.title = @"";
                     }
                     
                     NSNumber *likes = [eventDetail objectForKey:@"likes"];
                     if (likes && ![likes isEqual:[NSNull null]]) {
                         item.likes = likes;
                     } else {
                         item.likes = [NSNumber numberWithInteger:0];
                     }
                     
                     NSNumber *lowest_price = [eventDetail objectForKey:@"lowest_price"];
                     if (lowest_price && ![lowest_price isEqual:[NSNull null]]) {
                         item.lowestPrice = lowest_price;
                     } else {
                         item.lowestPrice = [NSNumber numberWithInteger:0];
                     }
                     
                     NSNumber *is_liked = [eventDetail objectForKey:@"is_liked"];
                     if (is_liked && ![is_liked isEqual:[NSNull null]]) {
                         item.isLiked = is_liked;
                     } else {
                        item.isLiked = [NSNumber numberWithBool:NO];
                     }
                     
                     NSString *_id = [eventDetail objectForKey:@"_id"];
                     if (_id && ![_id isEqual:[NSNull null]]) {
                         item.eventID = _id;
                     } else {
                         item.eventID = @"";
                     }
                     
                     NSString *start_datetime_str = [eventDetail objectForKey:@"start_datetime_str"];
                     if (start_datetime_str && ![start_datetime_str isEqual:[NSNull null]]) {
                         item.startDatetimeStr = start_datetime_str;
                     } else {
                         item.startDatetimeStr = @"";
                     }
                     
                     NSString *end_datetime_str = [eventDetail objectForKey:@"end_datetime_str"];
                     if (end_datetime_str && ![end_datetime_str isEqual:[NSNull null]]) {
                         item.endDatetimeStr = end_datetime_str;
                     } else {
                         item.endDatetimeStr = @"";
                     }
                     
                     NSString *venue_id = [eventDetail objectForKey:@"venue_id"];
                     if (venue_id && ![venue_id isEqual:[NSNull null]]) {
                         item.venueID = venue_id;
                     } else {
                         item.venueID = @"";
                     }
                     
                     NSString *venue_name = [eventDetail objectForKey:@"venue_name"];
                     if (venue_name && ![venue_name isEqual:[NSNull null]]) {
                         item.venueName = venue_name;
                     } else {
                         item.venueName = @"";
                     }
                     
                     NSString *fullfillment_type = [eventDetail objectForKey:@"fullfillment_type"];
                     if (fullfillment_type && ![fullfillment_type isEqual:[NSNull null]]) {
                         item.fullfillmentType = fullfillment_type;
                     } else {
                         item.fullfillmentType = @"";
                     }
                     
                     NSString *fullfillment_value = [eventDetail objectForKey:@"fullfillment_value"];
                     if (fullfillment_value && ![fullfillment_value isEqual:[NSNull null]]) {
                         item.fullfillmentValue = fullfillment_value;
                     } else {
                         item.fullfillmentValue = @"";
                     }
                     
                     NSString *description = [eventDetail objectForKey:@"description"];
                     if (description && ![description isEqual:[NSNull null]]) {
                         item.eventDescription = description;
                     } else {
                         item.eventDescription = @"";
                     }
                     
                     NSArray *tags = [eventDetail objectForKey:@"tags"];
                     if (tags && ![tags isEqual:[NSNull null]]) {
                         item.tags = [NSKeyedArchiver archivedDataWithRootObject:tags];
                     }
                     
                     NSArray *photos = [eventDetail objectForKey:@"photos"];
                     if (photos && ![photos isEqual:[NSNull null]]) {
                         item.photos = [NSKeyedArchiver archivedDataWithRootObject:photos];
                     }
                     
                     NSArray *guests_viewed = [eventDetail objectForKey:@"guests_viewed"];
                     if (guests_viewed && ![guests_viewed isEqual:[NSNull null]]) {
                         item.guestViewed = [NSKeyedArchiver archivedDataWithRootObject:guests_viewed];
                     }
                     
                     NSArray *venue = [eventDetail objectForKey:@"venue"];
                     if (venue && ![venue isEqual:[NSNull null]]) {
                         item.venue = [NSKeyedArchiver archivedDataWithRootObject:venue];
                     }
                     
                     NSString *start_datetime = [eventDetail objectForKey:@"start_datetime"];
                     NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                     [formatter setDateFormat:PHDateFormatServer];
                     NSDate *startDatetime = [formatter dateFromString:start_datetime];
                     if (startDatetime != nil) {
                         item.startDatetime = startDatetime;
                     }
                     
                     NSString *end_datetime = [eventDetail objectForKey:@"end_datetime"];
                     NSDate *endDatetime = [formatter dateFromString:end_datetime];
                     if (endDatetime != nil) {
                         item.endDatetime = endDatetime;
                     }
                     
                     item.modified = [NSDate date];
                     
                     NSError *error;
                     if (![self.managedObjectContext save:&error]) NSLog(@"Error: %@", [error localizedDescription]);
                     
                     // Show Invite Friends screen if user already visited Events Detail twice.
                     if ([JGInviteHelper isValidShowInvite]) {
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_INVITE_CONTACT_FRIENDS"
                                                                                 object:nil];
                         });
                     }
                 }
             }
             @catch (NSException *exception) {

             }
             @finally {
                 
             }
             
         });
         
         [self.emptyView setMode:@"hide"];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if (error.code == -1009 || error.code == -1005) {
             [SVProgressHUD showInfoWithStatus:@"Please check your internet connection"];
         }
         [self.emptyView setMode:@"hide"];
     }];
}

-(void)populateData:(NSDictionary *)dict {
    [self.emptyView setMode:@"hide"];
    
    [self showTooltip];
    
    EventDetail *eventDetail = [[self fetchedResultsController] objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (!eventDetail || eventDetail == nil) {
        return;
    }
    
    if ([eventDetail.fullfillmentType isEqualToString:@"ticket"]) {
        if (eventDetail.lowestPrice.integerValue > 0) {
            SharedData *sharedData = [SharedData sharedInstance];
            NSString *formattedPrice = [sharedData formatCurrencyString:eventDetail.lowestPrice.stringValue];
            [self.minimumPrice setText:[NSString stringWithFormat:@"Rp%@", formattedPrice]];
        } else {
            [self.minimumPrice setText:@"FREE"];
        }
        
        self.infoView.hidden = NO;
        self.minimumPrice.hidden = NO;
        self.startFromLabel.hidden = NO;
        
    } else {
        self.infoView.hidden = YES;
        self.minimumPrice.hidden = YES;
        self.startFromLabel.hidden = YES;
    }
    
    //Title
    self.title.text = [eventDetail.title uppercaseString];
    
    self.eventName.text = [eventDetail.title uppercaseString];
    self.eventName.frame = CGRectMake(16, CGRectGetMaxY(self.likeButton.frame) + 16, self.sharedData.screenWidth - 32, 60);
    [self.eventName sizeToFit];
    
    self.eventDate.text = [Constants toTitleDate:eventDetail.startDatetime dbEndDate:eventDetail.endDatetime];
    self.eventDate.frame = CGRectMake(16, CGRectGetMaxY(self.eventName.frame) + 12, self.sharedData.screenWidth-80, 40);
    [self.eventDate sizeToFit];
    
    self.venueName.text = [self.cEvent.venue uppercaseString];
    self.venueName.frame = CGRectMake(16, CGRectGetMaxY(self.eventDate.frame) + 12, self.sharedData.screenWidth - 32, 60);
    [self.venueName sizeToFit];
    
    //Likes
    self.likeButton.enabled = YES;
    [self.likeButton setSelected:[eventDetail.isLiked boolValue]];
    
    self.likeCount.text = [NSString stringWithFormat:@"%@", eventDetail.likes];
    
    //Get list of users
    NSArray *userList;
    if([self.sharedData isHost] || [self.sharedData isMember])
    {
        userList = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:eventDetail.guestViewed];
    }
    
    //Get tags
    self.tagArray = [[NSMutableArray alloc] init];
    [self.tagArray removeAllObjects];
    [self.tagArray addObjectsFromArray:(NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:eventDetail.tags]];
    
    //Tags!!!
//    if([self.tagArray count]>0)
//    {
//        self.tagCollection.frame = CGRectMake(20, self.venueName.frame.size.height + self.venueName.frame.origin.y + 16, self.sharedData.screenWidth - 40, 44);
//        [self.tagCollection reloadData];
//        self.tagCollection.frame = CGRectMake(20, self.venueName.frame.size.height + self.venueName .frame.origin.y + 16, self.sharedData.screenWidth - 40, self.tagCollection.collectionViewLayout.collectionViewContentSize.height);
//    }
//    else
//    {
//        self.tagCollection.frame = CGRectMake(20, self.venueName.frame.size.height + self.venueName.frame.origin.y, self.sharedData.screenWidth - 40, 0);
//    }
    
    self.tagCollection.frame = CGRectMake(20, self.venueName.frame.size.height + self.venueName.frame.origin.y, self.sharedData.screenWidth - 40, 0);
    
    //Separator 1
    self.separator1.frame = CGRectMake(0,self.tagCollection.frame.size.height + self.tagCollection.frame.origin.y + 20, self.sharedData.screenWidth, 1);
    self.separator1.hidden = NO;
    
    long totalUsers = [userList count];
    if(totalUsers>0)
    {
        self.listingContainer.frame = CGRectMake(0, self.separator1.frame.origin.y + self.separator1.frame.size.height + 16, self.sharedData.screenWidth, PROFILE_SIZE + 56 + 12);
        self.listingContainer.hidden = NO;
     
        self.guestInterestedLabel.frame = CGRectMake(16, 0, self.sharedData.screenWidth - 32, 20);
        
        //Hosts or Guests COUNT
        self.hostNum.frame = CGRectMake(16, CGRectGetMaxY(self.guestInterestedLabel.frame) + 16, self.sharedData.screenWidth - 32, PROFILE_SIZE);
        self.hostNum.textAlignment = NSTextAlignmentRight;
        self.hostNum.text = @"SEE ALL GUESTS";
        self.hostNum.numberOfLines = 2;
        
        [self.userContainer.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        self.userContainer.frame = self.hostNum.frame;
        
        long x1 = 0;
        //Get total pics
        if(totalUsers > PROFILE_PICS) totalUsers = PROFILE_PICS - 1;
        
        //Loop through pics
        for (int i = 0; i < totalUsers; i++) {
            NSDictionary *user = userList[i];
            UserBubble *btnPic = [[UserBubble alloc] initWithFrame:CGRectMake(x1, 0, PROFILE_SIZE, PROFILE_SIZE)];
            btnPic.userInteractionEnabled = NO;
            [btnPic setName:user[@"first_name"] lastName:nil];
            [btnPic loadPicture:user[@"profile_image"]];
            [self.userContainer addSubview:btnPic];
            x1 += PROFILE_SIZE + PROFILE_PADDING;
        }
        
        //Show +MORE button
        if([userList count] > PROFILE_PICS) {
            UIButton *btnPic = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btnPic.userInteractionEnabled = NO;
            btnPic.frame = CGRectMake( x1, 0, PROFILE_SIZE, PROFILE_SIZE);

            btnPic.layer.cornerRadius = PROFILE_SIZE/2;
            btnPic.layer.masksToBounds = YES;
            btnPic.backgroundColor = [UIColor phBlueColor];
            [btnPic setTitle:[NSString stringWithFormat:@"%d+",(int)[userList count] - PROFILE_PICS + 1] forState:UIControlStateNormal];
            btnPic.titleLabel.font = [UIFont phBlond:16];
            [btnPic setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.userContainer addSubview:btnPic];
        }
    } else {
        
        self.listingContainer.frame = CGRectMake(0, self.separator1.frame.origin.y + self.separator1.frame.size.height, self.sharedData.screenWidth, 0);
        self.listingContainer.hidden = YES;
    }
 
    //Separator 2
    self.separator2.frame = CGRectMake(0, CGRectGetMaxY(self.listingContainer.frame), self.sharedData.screenWidth, 1);
    self.separator2.hidden = NO;
    
    self.descriptionLabel.frame = CGRectMake(16, CGRectGetMaxY(self.separator2.frame) + 20, self.sharedData.screenWidth - 32, 20);
    if (eventDetail.eventDescription.length > 0) {
        self.descriptionLabel.hidden = NO;
    }
    
    NSDictionary *venue = (NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:eventDetail.venue];
    
    //About body
    self.aboutBody.frame = CGRectMake(14, CGRectGetMaxY(self.descriptionLabel.frame) + 4, self.sharedData.screenWidth - 28, 0);
    self.aboutBody.text = eventDetail.eventDescription;
    [self.aboutBody sizeToFit];
    
    //White inner bg
    self.innerBg.frame = CGRectMake(0, self.picScroll.frame.origin.y + self.picScroll.frame.size.height, self.sharedData.screenWidth, 20+ self.aboutBody.frame.origin.y + self.aboutBody.frame.size.height -(self.picScroll.frame.origin.y + self.picScroll.frame.size.height));
    
    //Config map
    self.mapView.frame = CGRectMake(0, CGRectGetMaxY(self.aboutBody.frame) + 16, self.sharedData.screenWidth, 200);
    //[self.mapView setCenterCoordinate:location zoomLevel:10 animated:YES];
    [self.mapView removeAnnotations:self.mapView.annotations];
    self.mapView.hidden = NO;
    
    //See map button
    self.seeMapView.frame = CGRectMake(-4, CGRectGetMaxY(self.mapView.frame), self.sharedData.screenWidth + 8, 56);
    self.seeMapView.hidden = NO;
    
    //See all label
    self.seeMapLabel.frame = CGRectMake(52, CGRectGetMaxY(self.mapView.frame), self.sharedData.screenWidth-40-64, 56);
    self.seeMapLabel.text = venue[@"address"];
    
    //See all caret
    self.seeMapCaret.frame = CGRectMake(self.sharedData.screenWidth-20-32,self.seeMapView.frame.origin.y + 12, 32, 32);
    self.seeMapCaret.hidden = YES;
    
    //Get photos from event then venue
    NSArray *photos = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:eventDetail.photos];
    
    //Page control
    self.pControl.currentPage = 0;
    self.pControl.numberOfPages = [photos count];
    
    //Load pics
    [self.picScroll.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    self.picScroll.contentOffset = CGPointMake(0, 0);
    for (int i = 0; i < [photos count]; i++)
    {
        UIView *imgCon = [[UIView alloc] initWithFrame:CGRectMake(i * self.sharedData.screenWidth, 0, picSize.width, picSize.height)];
        imgCon.layer.masksToBounds = YES;
        
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [indicatorView setFrame:CGRectMake(0, 0, picSize.width, picSize.height)];
        [imgCon addSubview:indicatorView];
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, picSize.width, picSize.height)];
        img.contentMode = UIViewContentModeScaleAspectFill;
        NSString *picURL = photos[i];
        [img sd_setImageWithURL:[NSURL URLWithString:picURL]
               placeholderImage:nil];
        [imgCon addSubview:img];
        [self.picScroll addSubview:imgCon];
    }
    
    if (photos.count > 1) {
        self.pControl.hidden = NO;
    } else {
        self.pControl.hidden = YES;
    }
    
    self.picScroll.contentSize = CGSizeMake([photos count] * picSize.width, picSize.height);
    
    //Map
    CLLocationDegrees latitude = [venue[@"lat"] doubleValue];
    CLLocationDegrees longitude = [venue[@"long"] doubleValue];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks) {
            if([placemarks count] == 0)
            {
                return ;
            }
            
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:placemarks[0]];
            self.cPlaceMark = placemark;
            [self.mapView addAnnotation:placemark];
            self.mapView.centerCoordinate = ((CLPlacemark *)placemarks[0]).location.coordinate;
            MKCoordinateRegion region = MKCoordinateRegionMake(((CLPlacemark *)placemarks[0]).location.coordinate, MKCoordinateSpanMake(.01f, .01f));
            self.mapView.region = region;
        }
    }];
    
    self.mainScroll.contentSize = CGSizeMake(self.sharedData.screenWidth, self.seeMapView.frame.origin.y + self.seeMapView.frame.size.height);
    
    self.isLoaded = YES;
    
    self.fillType = eventDetail.fullfillmentType;
    self.fillValue = eventDetail.fullfillmentValue;
    
    self.sharedData.cFillType = self.fillType;
    self.sharedData.cFillValue = self.fillValue;
    
    self.externalSiteLabel.hidden = ![self.fillType isEqualToString:@"link"];
    
    if([self.fillType isEqualToString:@"none"]) {
        [self.mainScroll setFrame:CGRectMake(0,
                                             0,
                                             self.sharedData.screenWidth,
                                             self.sharedData.screenHeight - PHTabHeight)];
    } else
    {
        [self.mainScroll setFrame:CGRectMake(0,
                                             0,
                                             self.sharedData.screenWidth,
                                             self.sharedData.screenHeight - PHTabHeight - 44)];
    }

    if([self.fillType isEqualToString:@"none"])
    {
        self.btnHostHere.hidden = YES;
        
    } else if([self.fillType isEqualToString:@"phone_number"])
    {
        self.btnHostHere.hidden = NO;
        [self.btnHostHere setTitle:[NSString stringWithFormat:@"CALL"] forState:UIControlStateNormal];
        
    } else if([self.fillType isEqualToString:@"link"])
    {
        self.btnHostHere.hidden = NO;
        [self.btnHostHere setTitle:[NSString stringWithFormat:@"BOOK NOW"] forState:UIControlStateNormal];
        
    } else if([self.fillType isEqualToString:@"reservation"])
    {
        self.btnHostHere.hidden = NO;
        [self.btnHostHere setTitle:@"RESERVE TABLE" forState:UIControlStateNormal];
        
    } else if([self.fillType isEqualToString:@"purchase"])
    {
        self.btnHostHere.hidden = NO;
        [self.btnHostHere setTitle:@"BOOK NOW" forState:UIControlStateNormal];
    } else if([self.fillType isEqualToString:@"ticket"])
    {
        self.btnHostHere.hidden = NO;
        [self.btnHostHere setTitle:@"BOOK NOW" forState:UIControlStateNormal];
    }
}

- (void)showAddressInMap {
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:self.cPlaceMark];
    MKMapItem *endingItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    NSMutableDictionary *launchOptions = [[NSMutableDictionary alloc] init];
    [endingItem openInMapsWithLaunchOptions:launchOptions];
}

- (void)postLikeEvent:(BOOL)isLike {
    if (!self.event_id || self.event_id == nil) {
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    NSString *url = [NSString stringWithFormat:@"%@/event/likes/%@/%@/%@",PHBaseNewURL,self.event_id, self.sharedData.fb_id, (isLike)?@"yes":@"no"];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [JGTooltipHelper setShowed:@"Tooltip_LikeEvent_isShowed"];
         [self showTooltip];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     }];
    
    
    EventDetail *eventDetail = [[self fetchedResultsController] objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (eventDetail && eventDetail != nil) {
        eventDetail.isLiked = [NSNumber numberWithBool:isLike];
        eventDetail.likes = [NSNumber numberWithInteger:[self.likeCount.text integerValue]];
        
        self.cEvent.likes = [NSNumber numberWithInteger:[self.likeCount.text integerValue]];
        
        NSError *error;
        if (![self.managedObjectContext save:&error]) NSLog(@"Error: %@", [error localizedDescription]);
    }
}

#pragma mark - Tooltip
- (void)showTooltip {
    
    if (self.tooltip == nil) {
        self.tooltip = [[JDFSequentialTooltipManager alloc] initWithHostView:self];
    }
    
    if ([JGTooltipHelper isLikeEventTooltipValid]) {
        [self.tooltip addTooltipWithTargetView:self.likeButton
                                      hostView:self
                                   tooltipText:@"Go ahead and tap here to let others know you like an event. This will also help teach Jiggie what events you like."
                                arrowDirection:JDFTooltipViewArrowDirectionUp
                                         width:self.sharedData.screenWidth - 20];
        [self.tooltip setBackgroundColourForAllTooltips:[UIColor phBlueColor]];
        [self.tooltip setFontForAllTooltips:[UIFont phBlond:14]];
        self.tooltip.showsBackdropView = YES;
        self.tooltip.backdropTapActionEnabled = YES;
        [self.tooltip showAllTooltips];
        
        [JGTooltipHelper setLastDateShowed:@"Tooltip_LikeEvent_LastDateShowed"];
        
    } else if ([JGTooltipHelper isSocialTabTooltipValidAfter:@"Tooltip_LikeEvent_isShowed"]) {
        if (self.tooltip != nil) {
            self.tooltip = nil;
            self.tooltip = [[JDFSequentialTooltipManager alloc] initWithHostView:self];
        }
        
        [self.tooltip addTooltipWithTargetPoint:CGPointMake(self.bounds.size.width * 3/8, self.bounds.size.height)
                                    tooltipText:@"Lucky you, we found other guests who also like this event. Connect now!"
                                 arrowDirection:JDFTooltipViewArrowDirectionDown
                                       hostView:self
                                          width:self.sharedData.screenWidth - 20];
        [self.tooltip setBackgroundColourForAllTooltips:[UIColor phBlueColor]];
        [self.tooltip setFontForAllTooltips:[UIFont phBlond:14]];
        self.tooltip.showsBackdropView = YES;
        self.tooltip.backdropTapActionEnabled = YES;
        [self.tooltip showAllTooltips];
        
        [JGTooltipHelper setLastDateShowed:@"Tooltip_SocialTab_LastDateShowed"];
    } else if ([JGTooltipHelper isShareEventTooltipValid]) {
        if (self.tooltip != nil) {
            self.tooltip = nil;
            self.tooltip = [[JDFSequentialTooltipManager alloc] initWithHostView:self];
        }
        
        [self.tooltip addTooltipWithTargetView:self.shareButton
                                      hostView:self
                                   tooltipText:@"Share this event with your friends and see who wants to go."
                                arrowDirection:JDFTooltipViewArrowDirectionUp
                                         width:self.sharedData.screenWidth - 20];
        [self.tooltip setBackgroundColourForAllTooltips:[UIColor phBlueColor]];
        [self.tooltip setFontForAllTooltips:[UIFont phBlond:14]];
        self.tooltip.showsBackdropView = YES;
        self.tooltip.backdropTapActionEnabled = YES;
        [self.tooltip showNextTooltip];
        
        [JGTooltipHelper setLastDateShowed:@"Tooltip_ShareEvent_LastDateShowed"];
        
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.mainScroll]) {
        CGPoint offset = scrollView.contentOffset;
        if (offset.y > 180) {
            if (!self.isNavBarShowing) {
                [self showNavBar:YES withAnimation:YES];
            }
        } else if (self.isNavBarShowing) {
            [self showNavBar:NO withAnimation:YES];
        }
    } else {
        int width = self.picScroll.frame.size.width;
        float xPos = scrollView.contentOffset.x+10;
        
        //Calculate the page we are on based on x coordinate position and width of scroll view
        self.pControl.currentPage = (int)xPos/width;
    }
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAddressInMap)];
    [view addGestureRecognizer:tap];
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
//    return 1;
    return 0;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    return [self.tagArray count]; turn off
    
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"EventsSummaryTagCell";
    SetupPickViewCell *cell = (SetupPickViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSString *title = self.tagArray[indexPath.row];
    [cell.button.button setTitle:[title uppercaseString] forState:UIControlStateNormal];
    cell.button.button.titleLabel.font = [UIFont phBold:12];
    cell.button.offTextColor = [UIColor whiteColor];
    cell.button.offBackgroundColor = [UIColor clearColor];
    
    cell.button.offBackgroundColor = [UserManager colorForTag:title];
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    //Get select state now
    if ([collectionView.indexPathsForSelectedItems containsObject:indexPath])
    {
        [collectionView selectItemAtIndexPath:indexPath animated:FALSE scrollPosition:UICollectionViewScrollPositionNone];
        [cell.button buttonSelect:YES checkmark:YES animated:NO];
    }
    else
    {
        [cell.button buttonSelect:NO checkmark:NO animated:NO];
    }
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    NSString *title = self.tagArray[indexPath.row];
    NSDictionary *fontDict = @{NSFontAttributeName:[UIFont phBold:12]};
    CGSize stringSize = [title sizeWithAttributes:fontDict];
    
    return CGSizeMake(stringSize.width + 40,32);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    SetupPickViewCell *cell = (SetupPickViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    if (![self.selectedArray containsObject:cell.button.button.titleLabel.text])
        [self.selectedArray addObject:cell.button.button.titleLabel.text];
    [cell.button buttonSelect:YES animated:YES];
    [self updateSelected];
     */
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    SetupPickViewCell *cell = (SetupPickViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [self.selectedArray removeObject:cell.button.button.titleLabel.text];
    [cell.button buttonSelect:NO animated:YES];
    [self updateSelected];
     */
}

@end



