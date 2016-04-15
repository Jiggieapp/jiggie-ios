//
//  Dashboard.m
//  PartyHost
//
//  Created by Sunny Clark on 12/26/14.
//  Copyright (c) 2014 Sunny Clark. All rights reserved.
//

#import "Dashboard.h"
#import "AnalyticManager.h"

@implementation Dashboard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    
    self.sharedData = [SharedData sharedInstance];
    
    self.btnsA = [[NSMutableArray alloc] init];
    self.pagesA = [[NSMutableArray alloc] init];
    self.labelsA = [[NSMutableArray alloc] init];
    
    self.cIndex = 0;
    self.callInit = YES;
    
    self.didTapTwice = 0;
    self.mainCon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width * 2, frame.size.height)];
    
    
    self.tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 50, frame.size.width, 50)];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    
    UIButton *btnEvents = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnEvents.frame = CGRectMake(0, 0, frame.size.width/4, 50);
    [btnEvents setBackgroundColor:[UIColor clearColor]];
    btnEvents.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btnEvents setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnEvents addTarget:self action:@selector(showEvents) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:btnEvents];
    
    self.eventsIcon = [[UIImageView alloc] init];
    self.eventsIcon.frame = CGRectMake(((frame.size.width/4) - 21)/2, 9, 21, 21);
    self.eventsIcon.image = [UIImage imageNamed:@"tab_events"];
    self.eventsIcon.image = [self.eventsIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.eventsIcon.contentMode = UIViewContentModeScaleAspectFit;
    self.eventsIcon.tintColor = [UIColor whiteColor];
    [btnEvents addSubview:self.eventsIcon];
    
    
    UIButton *btnChat = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnChat.frame = CGRectMake((frame.size.width/4) * 2, 0, frame.size.width/4, 50);
    [btnChat setBackgroundColor:[UIColor clearColor]];
    btnChat.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btnChat setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnChat addTarget:self action:@selector(showChat) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:btnChat];
  
    self.chatIcon = [[UIImageView alloc] init];
    self.chatIcon.frame = CGRectMake(((frame.size.width/4) - 32)/2, 3, 32, 32);
    self.chatIcon.image = [UIImage imageNamed:@"tab_chat"];
    self.chatIcon.image = [self.chatIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.chatIcon.contentMode = UIViewContentModeScaleAspectFit;
    self.chatIcon.tintColor = [UIColor whiteColor];
    [btnChat addSubview:self.chatIcon];
    self.sharedData.chatIcon = self.chatIcon;
    
    //Chat Badge
    //int unread = (int)[UIApplication sharedApplication].applicationIconBadgeNumber;
    self.chatBadge = [[BadgeView alloc] initWithFrame:CGRectMake((btnChat.frame.size.width/2)+8,6,16,16)];
    [self.chatBadge updateValue:0]; //We should start with 0 at first until it loads
    [btnChat addSubview:self.chatBadge];
    self.sharedData.chatBadge = self.chatBadge;
    
    UIButton *btnFeed = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnFeed.frame = CGRectMake((frame.size.width/4) * 1, 0, frame.size.width/4, 50);
    [btnFeed setBackgroundColor:[UIColor clearColor]];
    btnFeed.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btnFeed setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnFeed addTarget:self action:@selector(showFeed) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:btnFeed];
    
    self.feedIcon = [[UIImageView alloc] init];
    self.feedIcon.frame = CGRectMake(((frame.size.width/4) - 32)/2, 3, 32, 32);
    self.feedIcon.image = [UIImage imageNamed:@"tab_feed"];
    self.feedIcon.contentMode = UIViewContentModeScaleAspectFit;
    self.feedIcon.image = [self.feedIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.feedIcon.tintColor = [UIColor whiteColor];
    [btnFeed addSubview:self.feedIcon];
    self.sharedData.feedIcon = self.feedIcon;
    
    //Feed Badge
    self.feedBadge = [[BadgeView alloc] initWithFrame:CGRectMake((btnFeed.frame.size.width/2)+8,6,16,16)];
    [self.feedBadge updateValue:0];
    [btnFeed addSubview:self.feedBadge];
    self.sharedData.feedBadge = self.feedBadge;
    
    UIButton *btnMore = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnMore.frame = CGRectMake((frame.size.width/4) * 3, 0, frame.size.width/4, 50);
    [btnMore setBackgroundColor:[UIColor clearColor]];
    btnMore.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btnMore setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnMore addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:btnMore];
    
    
    self.profileIcon = [[UIImageView alloc] init];
    self.profileIcon.frame = CGRectMake(((frame.size.width/4) - 32)/2, 3, 32, 32);
    self.profileIcon.image = [UIImage imageNamed:@"tab_more"];
    self.profileIcon.image = [self.profileIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.profileIcon.contentMode = UIViewContentModeScaleAspectFit;
    self.profileIcon.tintColor = [UIColor whiteColor];
    [btnMore addSubview:self.profileIcon];
    
    
    self.chatLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 33, frame.size.width/4, 15)];
    self.chatLabel.text = @"CHAT";
    self.chatLabel.font = [UIFont phBold:9];
    self.chatLabel.textAlignment = NSTextAlignmentCenter;
    self.chatLabel.textColor = [UIColor whiteColor];
    self.chatLabel.backgroundColor = [UIColor clearColor];
    self.chatLabel.alpha = 1;
    [btnChat addSubview:self.chatLabel];
    
    
    self.eventsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 33, frame.size.width/4, 15)];
    self.eventsLabel.text = @"EVENTS";
    self.eventsLabel.font = [UIFont phBold:9];
    self.eventsLabel.textAlignment = NSTextAlignmentCenter;
    self.eventsLabel.textColor = [UIColor whiteColor];
    self.eventsLabel.backgroundColor = [UIColor clearColor];
    self.eventsLabel.alpha = 1;
    [btnEvents addSubview:self.eventsLabel];
    
    
    self.feedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 33, frame.size.width/4, 15)];
    self.feedLabel.text = @"SOCIAL";
    self.feedLabel.font = [UIFont phBold:9];
    self.feedLabel.textAlignment = NSTextAlignmentCenter;
    self.feedLabel.textColor = [UIColor whiteColor];
    self.feedLabel.alpha = 1;
    self.feedLabel.backgroundColor = [UIColor clearColor];
    [btnFeed addSubview:self.feedLabel];
    
    self.profileLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 33, frame.size.width/4, 15)];
    self.profileLabel.text = @"MORE";
    self.profileLabel.font = [UIFont phBold:9];
    self.profileLabel.textAlignment = NSTextAlignmentCenter;
    self.profileLabel.alpha = 1;
    self.profileLabel.textColor = [UIColor whiteColor];
    self.profileLabel.backgroundColor = [UIColor clearColor];
    [btnMore addSubview:self.profileLabel];
    
    
    [self.labelsA addObject:self.eventsLabel];
    [self.labelsA addObject:self.chatLabel];
    [self.labelsA addObject:self.feedLabel];
    [self.labelsA addObject:self.profileLabel];
    
    [self.btnsA addObject:btnEvents];
    [self.btnsA addObject:btnChat];
    [self.btnsA addObject:btnFeed];
    [self.btnsA addObject:btnMore];
    
    
    
    CALayer *topBorder = [CALayer layer];
    topBorder.borderColor = [UIColor phLightGrayColor].CGColor;
    topBorder.borderWidth = 1;
    topBorder.frame = CGRectMake(-1,0,self.sharedData.screenWidth+2,1);
    [self.tabBar.layer addSublayer:topBorder];
    
    self.outsideCon = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width, 0, frame.size.width, frame.size.height)];
    
    CGRect pageRect = CGRectMake(0, 0, self.sharedData.screenWidth, self.sharedData.screenHeight - 50);
    
    self.eventsPage     = [[Events alloc] initWithFrame:pageRect];
    self.chatPage       = [[Chats alloc] initWithFrame:pageRect];
    self.messagesPage   = [[Messages alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    self.hostVenueDetailPage   = [[HostVenueDetail alloc] initWithFrame:CGRectMake(0, self.sharedData.screenHeight, self.sharedData.screenWidth, self.sharedData.screenHeight)];
    
    self.hostVenueDetailFromShare = [[HostVenueDetailFromShare alloc] initWithFrame:CGRectMake(0, self.sharedData.screenHeight, self.sharedData.screenWidth, self.sharedData.screenHeight)];
    
    
    self.feedPage       = [[Feed alloc] initWithFrame:pageRect];
    self.feedPage.layer.masksToBounds = YES;
    
    self.morePage       = [[More alloc] initWithFrame:pageRect];
    
    self.memberReviews = [[MemberReviews alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, self.sharedData.screenHeight)];
    self.memberReviews.hidden = YES;
    
    self.bookTable = [[BookTable alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, self.sharedData.screenHeight)];
    self.bookTable.hidden = YES;
    self.sharedData.bookTable = self.bookTable;
    
    self.phoneVerify = [[PhoneVerify alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, self.sharedData.screenHeight)];
    self.phoneVerify.hidden = YES;
    self.sharedData.phoneVerify = self.phoneVerify;
    
    self.creditCard = [[CreditCard alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, self.sharedData.screenHeight)];
    self.creditCard.hidden = YES;
    self.sharedData.creditCard = self.creditCard;
    
    self.eventModal = [[EventsSummaryModal alloc] initWithFrame:CGRectMake(0, self.sharedData.screenHeight, self.sharedData.screenWidth, self.sharedData.screenHeight)];
    self.eventModal.hidden = YES;
    
    
    self.writeReview = [[WriteReview alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, self.sharedData.screenHeight)];
    self.writeReview.hidden = YES;
    
    self.memberProfile = [[MemberProfile alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, self.sharedData.screenHeight)];
    self.memberProfile.hidden = YES;
    
    self.sharedData.popupView = [[PopupView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, self.sharedData.screenHeight)];
    
    self.sharedData.overlayView = [[OverlayView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, self.sharedData.screenHeight)];
    
    self.feedMatch = [[FeedMatch alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, self.sharedData.screenHeight)];
    self.feedMatch.hidden = YES;
    
    self.sharedData.messagesPage = self.messagesPage;
    self.sharedData.hostVenueDetailPage = self.hostVenueDetailPage;
    self.sharedData.memberProfile = self.memberProfile;
    self.sharedData.morePage = self.morePage;
    self.sharedData.eventsPage = self.eventsPage;
    
    [self.pagesA addObject:self.eventsPage];
    [self.pagesA addObject:self.chatPage];
    [self.pagesA addObject:self.feedPage];
    [self.pagesA addObject:self.morePage];
    
    [self addSubview:self.mainCon];
    
    [self.mainCon addSubview:self.eventsPage];
    [self.mainCon addSubview:self.chatPage];
    [self.mainCon addSubview:self.feedPage];
    [self.mainCon addSubview:self.morePage];
    [self.outsideCon addSubview:self.messagesPage];
    [self.mainCon addSubview:self.outsideCon];
    [self.mainCon addSubview:self.tabBar];
    [self addSubview:self.feedMatch];
    [self addSubview:self.memberProfile];
    [self addSubview:self.memberReviews];
    [self addSubview:self.writeReview];
    [self addSubview:self.bookTable];
    [self addSubview:self.phoneVerify];
    [self addSubview:self.creditCard];
    [self addSubview:self.eventModal];
    [self addSubview:self.hostVenueDetailPage];
    [self addSubview:self.hostVenueDetailFromShare];
    [self addSubview:self.sharedData.popupView];
    [self addSubview:self.sharedData.overlayView];
    
    
    self.walkthroughPage = [[SetupView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, self.sharedData.screenHeight)];
    self.walkthroughPage.hidden = YES;
    
    self.sharedData.setupPage = self.walkthroughPage;
    
    //Walkthrough should be removed after shown
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![defaults objectForKey:@"SHOWED_WALKTHROUGH"])
    {
        self.sharedData.walkthroughOn = YES;
        
//        [self addSubview:self.walkthroughPage];
    }
    else{
        self.sharedData.walkthroughOn = NO;
        //self.walkthroughPage = nil;
    }
    
    [self showEvents];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showWalkthrough)
     name:@"SHOW_WALKTHROUGH"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(exitWalkthrough)
     name:@"EXIT_WALKTHROUGH"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showEvents)
     name:@"SHOW_EVENTS"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showFeed)
     name:@"SHOW_FEED"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showChat)
     name:@"SHOW_CHAT"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showMessages)
     name:@"SHOW_MESSAGES"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(exitMessages)
     name:@"EXIT_MESSAGES"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showHostVenueDetail)
     name:@"SHOW_HOST_VENUE_DETAIL"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showHostVenueDetailFromShare)
     name:@"SHOW_HOST_VENUE_DETAIL_FROM_SHARE"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(exitHostVenueDetail)
     name:@"EXIT_HOST_VENUE_DETAIL"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(exitHostVenueDetailFromShare)
     name:@"EXIT_HOST_VENUE_DETAIL_FROM_SHARE"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(checkIfHadAPNOnLogin)
     name:@"APP_LOADED"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(resetApp)
     name:@"APP_UNLOADED"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showMemberProfile)
     name:@"SHOW_MEMBER_PROFILE"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showMemberReviews)
     name:@"SHOW_MEMBER_REVIEWS"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showMemberWriteReview)
     name:@"SHOW_MEMBER_WRITE_REVIEW"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(exitMemberProfile)
     name:@"EXIT_MEMBER_PROFILE"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(goToInitHosting)
     name:@"GO_TO_INIT_HOSTING"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showMoreAndGoToHosting)
     name:@"CREATE_HOSTING"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(goToEventsAndInvite)
     name:@"SHOW_EVENTS_TO_INVITE"
     object:nil];
    
    //This is a popup
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showBookTable)
     name:@"SHOW_BOOKTABLE"
     object:nil];
    
    //This is a popup
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(exitBookTable)
     name:@"EXIT_BOOKTABLE"
     object:nil];

    //This is a popup
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showPhoneVerify)
     name:@"SHOW_PHONE_VERIFY"
     object:nil];
    
    //This is a popup
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(exitPhoneVerify)
     name:@"EXIT_PHONE_VERIFY"
     object:nil];
    
    //This is a popup
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showCreditCard)
     name:@"SHOW_CREDIT_CARD"
     object:nil];
    
    //This is a popup
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(exitCreditCard)
     name:@"EXIT_CREDIT_CARD"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showEventModal)
     name:@"SHOW_EVENT_MODAL"
     object:nil];
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(exitEventModal)
     name:@"EXIT_EVENT_MODAL"
     object:nil];
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showFeed)
     name:@"SHOW_PARTYFEED"
     object:nil];
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showFeedMatch)
     name:@"SHOW_FEED_MATCH"
     object:nil];
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(exitFeedMatch)
     name:@"EXIT_FEED_MATCH"
     object:nil];
    
    
    //[self performSelector:@selector(testapp) withObject:nil afterDelay:8.0];
    
    return self;
}

-(void)resetApp
{
    self.cIndex = 0;
    self.sharedData.cPageIndex = self.cIndex;
    for (int i = 0; i < [self.pagesA count]; i++)
    {
        UIView *page = [self.pagesA objectAtIndex:i];
        page.hidden = YES;
        UILabel *label = [self.labelsA objectAtIndex:i];
        label.alpha = 1;
    }
    
    [self updateTabState];
}

-(void)updateTabState
{
    if(self.cIndex == 0) {
        self.eventsIcon.alpha = 1;
        self.eventsIcon.tintColor = [UIColor phPurpleColor];
        self.eventsLabel.textColor = [UIColor phPurpleColor];
    }
    else {
        self.eventsIcon.alpha = 1;
        self.eventsIcon.tintColor = [UIColor darkGrayColor];
        self.eventsLabel.textColor = [UIColor darkGrayColor];
    }
    
    if(self.cIndex == 1) {
        self.chatIcon.alpha = 1;
        self.chatIcon.tintColor = [UIColor phPurpleColor];
        self.chatLabel.textColor = [UIColor phPurpleColor];
    }
    else {
        self.chatIcon.alpha = 1;
        self.chatIcon.tintColor = [UIColor darkGrayColor];
        self.chatLabel.textColor = [UIColor darkGrayColor];
    }
    
    if(self.cIndex == 2) {
        self.feedIcon.alpha = 1;
        self.feedIcon.tintColor = [UIColor phPurpleColor];
        self.feedLabel.textColor = [UIColor phPurpleColor];
    }
    else {
        self.feedIcon.alpha = 1;
        self.feedIcon.tintColor = [UIColor darkGrayColor];
        self.feedLabel.textColor = [UIColor darkGrayColor];
    }
    
    if(self.cIndex == 3) {
        self.profileIcon.alpha = 1;
        self.profileIcon.tintColor = [UIColor phPurpleColor];
        self.profileLabel.textColor = [UIColor phPurpleColor];
    }
    else {
        self.profileIcon.alpha = 1;
        self.profileIcon.tintColor = [UIColor darkGrayColor];
        self.profileLabel.textColor = [UIColor darkGrayColor];
    }
    
    [self clearBtns];
}

-(void)checkIfHadAPNOnLogin
{
    if(self.sharedData.hasMessageToLoad) {
        self.sharedData.hasMessageToLoad = NO;
     
        if ([self.sharedData.fromMailId isEqualToString:@""]) {
            [self showChat];
        } else {
            self.sharedData.conversationId = self.sharedData.fromMailId;
            self.sharedData.messagesPage.toId = self.sharedData.fromMailId;
            self.sharedData.messagesPage.toLabel.text = [self.sharedData.fromMailName uppercaseString];
            self.sharedData.toImgURL = [self.sharedData profileImg:self.sharedData.fromMailId];
            [self performSelector:@selector(showMessages) withObject:nil afterDelay:2.0];
        }
        
    } else if (self.sharedData.hasFeedToLoad) {
        [self showFeed];
        
    } else {
        [self showEvents];
        
        if(self.sharedData.isLoggedIn && self.sharedData.hasInitEventSelection)
        {
            self.sharedData.hasInitEventSelection = NO;
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"SHOW_EVENT_MODAL"
             object:self];
        }
    }
    
    self.sharedData.btnYesTxt = MPTweakValue(@"PartyFeedButtonYesText", @"YES");
    self.sharedData.btnNOTxt = MPTweakValue(@"PartyFeedButtonNoText", @"NO");
    self.sharedData.ABTestChat = MPTweakValue(@"PartyFeedABTestChat", @"YES");
}


-(void)initClass
{
    
}

-(void)goToEventsAndInvite
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    self.cIndex = 0;
    self.callInit = NO;
    [self updatePages];
}

-(void)showEvents
{
    if(self.cIndex == 0)
    {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"EVENTS_TAPPED"
         object:self];
    }
    self.cIndex = 0;
    [self updatePages];
}

-(void)goToInitHosting
{
    self.cIndex = 0;
    [self updatePages];
    
    if(self.sharedData.isInConversation)
    {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"EXIT_MESSAGES"
         object:self];
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"EXIT_MEMBER_PROFILE"
     object:self];
}

-(void)showChat
{
    //Scroll to top
    if(self.cIndex == 1)
    {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"CHAT_TAPPED"
         object:self];
    }
    
    self.cIndex = 1;
    [self updatePages];
    
    [[AnalyticManager sharedManager] trackMixPanelWithDict:@"Conversations List" withDict:@{}];
}

-(void)showFeed
{
    //Scroll to top
    if(self.cIndex == 2)
    {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"FEED_TAPPED"
         object:self];
    }
    
    int oldIndex = self.cIndex;
    self.cIndex = 2;
    [self updatePages];
    if(oldIndex == 2)
    {
        //[self.feedPage goBack];
    }
    
    [[AnalyticManager sharedManager] trackMixPanelWithDict:@"View Social Feed" withDict:@{}];
}

-(void)showFeedMatch
{
    self.feedMatch.frame = CGRectMake(0, self.sharedData.screenHeight, self.sharedData.screenWidth, self.sharedData.screenHeight);
    self.feedMatch.hidden = NO;
    [self.feedMatch reset];
    [self.feedMatch initClass];
    
    [UIView animateWithDuration:0.30 animations:^(void)
     {
         self.feedMatch.frame = CGRectMake(0, 0, self.sharedData.screenWidth, self.sharedData.screenHeight);
     }];
}

-(void)exitFeedMatch
{
    [UIView animateWithDuration:0.30 animations:^()
     {
         self.feedMatch.frame = CGRectMake(0, self.sharedData.screenHeight, self.sharedData.screenWidth, self.sharedData.screenHeight);
     } completion:^(BOOL finished)
     {
         self.feedMatch.hidden = YES;
     }];
}

-(void)showMore
{
    if(self.cIndex == 3)
    {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"MORE_TAPPED"
         object:self];
    }
    
    int oldIndex = self.cIndex;
    self.cIndex = 3;
    [self updatePages];
    if(oldIndex == 3)
    {
//        [self.morePage checkIfGoBack];
    }
    
    [[AnalyticManager sharedManager] trackMixPanelWithDict:@"View Settings" withDict:@{}];
}

-(void)showMoreAndGoToHosting
{
    int oldIndex = self.cIndex;
    self.cIndex = 3;
    [self updatePages];
    if(oldIndex == 3)
    {
//        [self.morePage checkIfGoBack];
    }
    [self.morePage goToHosting];
}

-(void)clearBtns
{
    for (int i = 0; i < [self.btnsA count]; i++)
    {
        UIButton *btn = [self.btnsA objectAtIndex:i];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        if(i==self.cIndex) [btn setBackgroundColor:[UIColor whiteColor]];
        else [btn setBackgroundColor:[UIColor clearColor]];
    }
}


-(void)updatePages
{
    self.sharedData.cPageIndex = self.cIndex;
    for (int i = 0; i < [self.pagesA count]; i++)
    {
        UIView *page = [self.pagesA objectAtIndex:i];
        page.hidden = YES;
        UILabel *label = [self.labelsA objectAtIndex:i];
        label.alpha = 1;
    }
    
    self.didTapTwice = (self.cIndex != 0)?0:self.didTapTwice + 1;
    
    UIView *cPage = [self.pagesA objectAtIndex:self.cIndex];
    cPage.hidden = NO;
    
    UILabel *cLabel = [self.labelsA objectAtIndex:self.cIndex];
    cLabel.alpha = 0.8;
    self.sharedData.isInFeed = (self.cIndex == 2);
    NSLog(@"self.sharedData.isInFeed :: %@",(self.sharedData.isInFeed == YES)?@"YES":@"NO");
    
    if(self.callInit)
    {
        SEL selector = NSSelectorFromString(@"initClass");
        IMP imp = [cPage methodForSelector:selector];
        void (*func)(id, SEL) = (void *)imp;
        func(cPage, selector);
    }
    self.callInit = YES;
    
    
    
    [self updateTabState];
}

-(void)showMessages
{
    [self.messagesPage reset];
    [UIView animateWithDuration:0.25 animations:^()
    {
        self.mainCon.frame = CGRectMake(-self.frame.size.width, 0, self.frame.size.width * 2, self.frame.size.height);
    } completion:^(BOOL finished)
    {
        [self.messagesPage initClass];
    }];
}

-(void)showMemberProfile
{
    
    [self.memberProfile initClass];
    /*
    if(self.sharedData.isInConversation)
    {
        self.memberProfile.hidden = NO;
        [self.memberProfile initClass];
        
        [UIView transitionWithView:self.outsideCon
                          duration:0.6
                           options:UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionCurveEaseOut
                        animations:^{ [self.messagesPage removeFromSuperview]; [self.outsideCon addSubview:self.memberProfile]; }
                        completion:NULL];
    }else{
        self.memberProfile.hidden = NO;
        self.messagesPage.hidden = YES;
        [self.memberProfile initClass];
        [self.outsideCon addSubview:self.memberProfile];
        [UIView animateWithDuration:0.25 animations:^()
         {
             self.mainCon.frame = CGRectMake(-self.frame.size.width, 0, self.frame.size.width * 2, self.frame.size.height);
         } completion:^(BOOL finished)
         {
             
         }];
    }
    */
}

-(void)exitMemberProfile
{
    [self.memberProfile exit];
    /*
    if(self.sharedData.isInConversation)
    {
        [self.outsideCon addSubview:self.messagesPage];
        self.messagesPage.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [UIView transitionWithView:self.outsideCon
                          duration:0.6
                           options:UIViewAnimationOptionTransitionFlipFromRight | UIViewAnimationOptionCurveEaseOut
                        animations:^{ [self.memberProfile removeFromSuperview]; [self.outsideCon addSubview:self.messagesPage]; }
                        completion:^(BOOL finished)
        {

        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^()
         {
             self.mainCon.frame = CGRectMake(0, 0, self.frame.size.width * 2, self.frame.size.height);
         } completion:^(BOOL finished)
         {
             self.memberProfile.hidden = YES;
             self.messagesPage.hidden = NO;
             [self.outsideCon addSubview:self.memberProfile];
             [self.outsideCon addSubview:self.messagesPage];
         }];
    }
    */
}

-(void)exitMessages
{
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.mainCon.frame = CGRectMake(0, 0, self.frame.size.width * 2, self.frame.size.height);
     } completion:^(BOOL finished)
     {
         
     }];
}


/* SHOW BOOK TABLE */

-(void)showBookTable
{
    [self.bookTable initClass];
}

-(void)exitBookTable
{
    [self.bookTable exitHandler];
}


/* SHOW PHONE VERIFY */

-(void)showPhoneVerify
{
    [self.phoneVerify initClass];
}

-(void)exitPhoneVerify
{
    [self.phoneVerify exitHandler];
}



/* SHOW CREDIT CARD */

-(void)showCreditCard
{
    [self.creditCard initClass];
}

-(void)exitCreditCard
{
    [self.creditCard exitHandler];
}


/* SHOW REVIEWS */

-(void)showMemberReviews
{
    [self.memberReviews initClass];
}

-(void)exitMemberReviews
{
    [self.memberReviews exitHandler];
}



/* WRITE REVIEW */

-(void)showMemberWriteReview
{
    [self.writeReview initClass];
}


-(void)exitMemberWriteReview
{
    [self.writeReview exitHandler];
}


/* HOST VENUE DETAILS */

-(void)showHostVenueDetail
{
    self.hostVenueDetailPage.frame = CGRectMake(0, self.sharedData.screenHeight, self.sharedData.screenWidth, self.sharedData.screenHeight);
    self.hostVenueDetailPage.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.hostVenueDetailPage.frame = CGRectMake(0, 0, self.sharedData.screenWidth, self.sharedData.screenHeight);
     } completion:^(BOOL finished)
     {
         [self.hostVenueDetailPage initClass];
     }];
}


-(void)exitHostVenueDetail
{
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.hostVenueDetailPage.frame = CGRectMake(0, self.sharedData.screenHeight, self.sharedData.screenWidth, self.sharedData.screenHeight);
     } completion:^(BOOL finished)
     {
         self.hostVenueDetailPage.hidden = YES;
     }];
}


/* HOST VENUE DETAILS FROM SHARE */

-(void)showHostVenueDetailFromShare
{
    NSLog(@"showHostVenueDetailFromShare");
    [self.hostVenueDetailFromShare initClass];
    self.hostVenueDetailFromShare.frame = CGRectMake(0, self.sharedData.screenHeight, self.sharedData.screenWidth, self.sharedData.screenHeight);
    self.hostVenueDetailFromShare.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.hostVenueDetailFromShare.frame = CGRectMake(0, 0, self.sharedData.screenWidth, self.sharedData.screenHeight);
     } completion:^(BOOL finished)
     {
         //[self.hostVenueDetailFromShare initClass];
     }];
}

-(void)exitHostVenueDetailFromShare
{
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.hostVenueDetailFromShare.frame = CGRectMake(0, self.sharedData.screenHeight, self.sharedData.screenWidth, self.sharedData.screenHeight);
     } completion:^(BOOL finished)
     {
         self.hostVenueDetailFromShare.hidden = YES;
     }];
}

/* WALKTHROUGH */

-(void)showWalkthrough
{
    self.sharedData.walkthroughOn = YES;
    self.walkthroughPage.hidden = NO;
    [self.walkthroughPage initClass];
    
    if (self.walkthroughPage) {
        [self.walkthroughPage setFrame:CGRectMake(0, 0, self.sharedData.screenWidth, self.sharedData.screenHeight)];
        [self addSubview:self.walkthroughPage];
    }
}

-(void)exitWalkthrough
{
    [UIView animateWithDuration:0.50 animations:^()
     {
         self.walkthroughPage.frame = CGRectMake(0, self.sharedData.screenHeight*2, self.sharedData.screenWidth,self.sharedData.screenHeight*3);
     } completion:^(BOOL finished) {
         [self.walkthroughPage removeFromSuperview];
         //self.walkthroughPage = NULL;
         
         //Start app now!
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"APP_LOADED"
          object:self];
     }];
}


-(void)showEventModal
{
    self.eventModal.frame = CGRectMake(0, self.sharedData.screenHeight, self.sharedData.screenWidth, self.sharedData.screenHeight);
    self.eventModal.hidden = NO;
    [self.eventModal reset];
    [self.eventModal initClass];
    [UIView animateWithDuration:0.30 animations:^()
     {
         self.eventModal.frame = CGRectMake(0, 0, self.sharedData.screenWidth, self.sharedData.screenHeight);
     }];
}

-(void)exitEventModal
{
    [UIView animateWithDuration:0.30 animations:^()
     {
         self.eventModal.frame = CGRectMake(0, self.sharedData.screenHeight, self.sharedData.screenWidth, self.sharedData.screenHeight);
     } completion:^(BOOL finished)
    {
        self.eventModal.hidden = YES;
     }];
}

@end
