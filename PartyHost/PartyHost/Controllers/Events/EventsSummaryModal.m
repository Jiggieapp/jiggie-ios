//
//  EventsVenueDetail.m
//  PartyHost
//
//  Created by Sunny Clark on 2/14/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "EventsSummaryModal.h"
#import "AnalyticManager.h"

#define PROFILE_PICS 4 //If more than 4 then last is +MORE
#define PROFILE_SIZE 40
#define PROFILE_PADDING 8

@implementation EventsSummaryModal {
    NSString *lastEventId;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    lastEventId = @"";
    //self.backgroundColor = [UIColor redColor];
    
    self.sharedData = [SharedData sharedInstance];
    
    self.mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, self.sharedData.screenWidth, self.sharedData.screenHeight - 20)];
    self.mainScroll.showsVerticalScrollIndicator    = NO;
    self.mainScroll.showsHorizontalScrollIndicator  = NO;
    self.mainScroll.scrollEnabled                   = YES;
    self.mainScroll.userInteractionEnabled          = YES;
    self.mainScroll.delegate                        = self;
    self.mainScroll.backgroundColor                 = [UIColor phDarkBodyColor];
    self.mainScroll.contentSize                     = CGSizeMake(self.sharedData.screenWidth, 1000);
    [self addSubview:self.mainScroll];
    
    //Inner bg
    self.innerBg = [[UIView alloc] init];
    self.innerBg.backgroundColor = [UIColor whiteColor];
    [self.mainScroll addSubview:self.innerBg];
    
    //Scrollable pictures
    self.picScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 300)];
    self.picScroll.showsVerticalScrollIndicator    = NO;
    self.picScroll.showsHorizontalScrollIndicator  = NO;
    self.picScroll.scrollEnabled                   = YES;
    self.picScroll.userInteractionEnabled          = YES;
    self.picScroll.pagingEnabled                   = YES;
    self.picScroll.delegate                        = self;
    self.picScroll.backgroundColor                 = [UIColor phLightGrayColor];
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
    
    //Back button
    self.btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnBack.frame = CGRectMake(4, 0 + 20, 50, 50);
    [self.btnBack setBackgroundImage:[UIImage imageNamed:@"nav_cancel"] forState:UIControlStateNormal];
    [self.btnBack addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnBack];
    
    self.btnInfo = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnInfo.frame = CGRectMake(self.sharedData.screenWidth - (93/4) - 5, 4 + 20, 93/4, 128/4);
    [self.btnInfo setImage:[UIImage imageNamed:@"share_action"] forState:UIControlStateNormal];
    self.btnInfo.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.btnInfo addTarget:self action:@selector(goShareHandler) forControlEvents:UIControlEventTouchUpInside];
    self.btnInfo.hidden = YES;
    //[self addSubview:self.btnInfo];
    
    //Picture paging
    self.pControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.picScroll.frame.size.height - 50, self.sharedData.screenWidth, 50)];
    self.pControl.userInteractionEnabled = NO;
    [self.mainScroll addSubview:self.pControl];
    
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(40, self.picScroll.frame.origin.y + self.picScroll.frame.size.height + 16 + 8, self.sharedData.screenWidth-80, 24)];
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.textColor = [UIColor blackColor];
    self.title.font = [UIFont phBold:19];
    self.title.userInteractionEnabled = NO;
    self.title.adjustsFontSizeToFitWidth = YES;
    [self.mainScroll addSubview:self.title];
    
    self.venueName = [[UILabel alloc] initWithFrame:CGRectMake(30, self.title.frame.origin.y + self.title.frame.size.height, self.sharedData.screenWidth - 60, 20)];
    self.venueName.font = [UIFont phBold:12];
    self.venueName.textAlignment = NSTextAlignmentCenter;
    self.venueName.textColor = [UIColor darkGrayColor];
    self.venueName.userInteractionEnabled = NO;
    self.venueName.backgroundColor = [UIColor clearColor];
    self.venueName.adjustsFontSizeToFitWidth = YES;
    [self.mainScroll addSubview:self.venueName];
    
    self.separator1 = [[UIView alloc] init];
    self.separator1.backgroundColor = [UIColor phDarkGrayColor];
    [self.mainScroll addSubview:self.separator1];
    
    self.listingContainer = [[UIView alloc] init];
    //self.listingContainer.backgroundColor = [UIColor greenColor];
    [self.mainScroll addSubview:self.listingContainer];
    //UITapGestureRecognizer *seeAllTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infoButtonClicked)];
    //[self.listingContainer addGestureRecognizer:seeAllTap];
    
    self.hostNum = [[UILabel alloc] init];
    self.hostNum.textColor = [UIColor colorWithWhite:0 alpha:0.25];
    self.hostNum.font = [UIFont phBold:12];
    [self.listingContainer addSubview:self.hostNum];
    
    self.userContainer = [[UIView alloc] init];
    self.userContainer.backgroundColor = [UIColor clearColor];
    [self.listingContainer addSubview:self.userContainer];
    
    self.seeAllView = [[UIView alloc] init];
    self.seeAllView.backgroundColor = [UIColor colorFromHexCode:@"F0F0F0"];
    self.seeAllView.layer.borderColor = [UIColor colorFromHexCode:@"E8E8E8"].CGColor;
    self.seeAllView.layer.borderWidth = 1;
    [self.listingContainer addSubview:self.seeAllView];
    
    self.seeAllLabel = [[UILabel alloc] init];
    self.seeAllLabel.font = [UIFont phBold:14];
    self.seeAllLabel.textAlignment = NSTextAlignmentCenter;
    self.seeAllLabel.textColor = [UIColor blackColor];
    self.seeAllLabel.userInteractionEnabled = NO;
    self.seeAllLabel.backgroundColor = [UIColor clearColor];
    self.seeAllLabel.adjustsFontSizeToFitWidth = YES;
    [self.listingContainer addSubview:self.seeAllLabel];
    
    self.seeAllCaret = [[UIImageView alloc] init];
    self.seeAllCaret.image = [[UIImage imageNamed:@"btn_forward"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.seeAllCaret.tintColor = [UIColor lightGrayColor];
    [self.listingContainer addSubview:self.seeAllCaret];
    
    self.separator2 = [[UIView alloc] init];
    self.separator2.backgroundColor = [UIColor phDarkGrayColor];
    [self.mainScroll addSubview:self.separator2];
    
    KTCenterFlowLayout *layout = [KTCenterFlowLayout new];
    layout.minimumInteritemSpacing = 8.f;
    layout.minimumLineSpacing = 8.f;
    
    //UICollectionViewLeftAlignedLayout *layout=[[UICollectionViewLeftAlignedLayout alloc] init];
    //UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    self.tagCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.tagCollection registerClass:[SetupPickViewCell class] forCellWithReuseIdentifier:@"EventsSummaryTagCell"];
    self.tagCollection.delegate = self;
    self.tagCollection.dataSource = self;
    self.tagCollection.backgroundColor = [UIColor clearColor];
    [self.mainScroll addSubview:self.tagCollection];
    
    self.eventDate = [[UILabel alloc] init];
    self.eventDate.font = [UIFont phBold:12];
    self.eventDate.textAlignment = NSTextAlignmentCenter;
    self.eventDate.textColor = [UIColor darkGrayColor];
    self.eventDate.userInteractionEnabled = NO;
    self.eventDate.backgroundColor = [UIColor clearColor];
    self.eventDate.adjustsFontSizeToFitWidth = YES;
    [self.mainScroll addSubview:self.eventDate];
    
    self.separator3 = [[UIView alloc] init];
    self.separator3.backgroundColor = [UIColor phDarkGrayColor];
    [self.mainScroll addSubview:self.separator3];
    
    self.aboutBody = [[UITextView alloc] init];
    self.aboutBody.font = [UIFont phBlond:12];
    self.aboutBody.textColor = [UIColor blackColor];
    self.aboutBody.textAlignment = NSTextAlignmentLeft;
    self.aboutBody.userInteractionEnabled = NO;
    self.aboutBody.backgroundColor = [UIColor clearColor];
    [self.mainScroll addSubview:self.aboutBody];
    
    self.seeMapView = [[UIView alloc] init];
    self.seeMapView.backgroundColor = [UIColor colorFromHexCode:@"F0F0F0"];
    self.seeMapView.layer.borderColor = [UIColor colorFromHexCode:@"E8E8E8"].CGColor;
    self.seeMapView.layer.borderWidth = 1;
    UITapGestureRecognizer *seeMapTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAddressInMap)];
    [self.seeMapView addGestureRecognizer:seeMapTap];
    [self.mainScroll addSubview:self.seeMapView];
    
    self.seeMapLabel = [[UILabel alloc] init];
    self.seeMapLabel.font = [UIFont phBold:11];
    self.seeMapLabel.textAlignment = NSTextAlignmentCenter;
    self.seeMapLabel.textColor = [UIColor blackColor];
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
    self.btnHostHere.titleLabel.font = [UIFont phBold:18];
    [self.btnHostHere setTitleEdgeInsets:UIEdgeInsetsMake(3,0,0,0)];
    [self.btnHostHere setTitle:@"" forState:UIControlStateNormal];
    [self.btnHostHere setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnHostHere setBackgroundColor:[UIColor phLightTitleColor]];
    [self.btnHostHere addTarget:self action:@selector(hostHereButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //[self addSubview:self.btnHostHere];
    
    return self;
}


-(void)goShareHandler
{
    NSLog(@">>> %@",self.sharedData.selectedHost);
    /*
     //Everything needed for share link
     self.sharedData.shareHostingId = self.sharedData.selectedHost[@"hosting"][@"_id"];
     self.sharedData.shareHostingVenueName = self.sharedData.selectedEvent[@"venue_name"];
     self.sharedData.shareHostingHostName = self.sharedData.selectedHost[@"first_name"];
     self.sharedData.shareHostingHostFbId = self.sharedData.selectedHost[@"fb_id"];
     self.sharedData.shareHostingHostDate = self.sharedData.selectedHost[@"hosting"][@"start_datetime_str"];
     self.sharedData.cHostVenuePicURL = [Constants eventImageURL:self.sharedData.selectedEvent[@"_id"]]; //Need for SHARE HOSTING
     */
    
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_GENERAL_INVITE" object:self];
}

//Clicked 3 dots
-(void)infoButtonClicked
{
    //[self.sharedData trackMixPanelWithDict:@"Share Hosting" withDict:@{@"origin":@"HostDetails"}];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"EVENTS_GO_GUEST_LIST"
     object:self];
    
    
    
    
    
    /*
     if([self.sharedData isGuest] && ![self.sharedData isMember])
     {
     [[NSNotificationCenter defaultCenter]
     postNotificationName:@"EVENTS_GO_HOST_LIST"
     object:self];
     }
     else{
     [[NSNotificationCenter defaultCenter]
     postNotificationName:@"EVENTS_GO_GUEST_LIST"
     object:self];
     }
     */
}

//Go to the ADD HOSTING screen
-(void)hostHereButtonClicked:(UIButton *)button
{
    self.sharedData.cEventId_toLoad = self.mainDict[@"_id"];
    
    [self.sharedData.cAddEventDict removeAllObjects];
    [self.sharedData.cAddEventDict addEntriesFromDictionary:self.mainDict];
    
    [[AnalyticManager sharedManager] trackMixPanelIncrementWithDict:@{@"host_here":@1}];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_BOOKTABLE"
     object:self];
}

-(void)loadData:(NSString*)event_id
{
    self.event_id = event_id;
    [self reset];
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    NSString *url = nil;
    if(self.sharedData.isGuest && ![self.sharedData isMember]) url = [Constants hostListingsURL:event_id fb_id:self.sharedData.fb_id];
    else url = [Constants guestListingsURL:event_id fb_id:self.sharedData.fb_id];
    
    
    url = [NSString stringWithFormat:@"%@/event/details/%@/%@/%@",PHBaseNewURL,event_id,self.sharedData.fb_id,self.sharedData.gender];
    
    NSLog(@"EVENTS_SUMMARY_URL (%@) :: %@",self.sharedData.account_type,url);
    //event/details
    
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"EVENTS_SUMMARY_RESPONSE (%@) :: %@",self.sharedData.account_type,responseObject);
         
         //[self.sharedData trackMixPanelWithDict:@"View Host Listings" withDict:@{}];
         
         NSInteger responseStatusCode = operation.response.statusCode;
         if (responseStatusCode == 204) {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Event Removed" message:@"The event is no longer available." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             alert.tag = 1;
             [alert show];
             
             [self goBack];
             
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"HIDE_LOADING"
              object:self];
             
             return;
         }
         
         @try {
             NSDictionary *data = [responseObject objectForKey:@"data"];
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
                 
                 [self.sharedData.eventDict removeAllObjects];
                 [self.sharedData.eventDict addEntriesFromDictionary:eventDetail];
                 [self populateData:self.sharedData.eventDict];
             }
         }
         @catch (NSException *exception) {
             
         }
         @finally {
             
         }

         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"EVENTS_SUMMARY_LIST_ERROR (%@) :: %@",self.sharedData.account_type,error);
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
     }];
}

-(void)showViewed:(NSString *)event_id
{
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    NSString *url = [Constants guestListingsURL:event_id fb_id:self.sharedData.fb_id];
    url = [NSString stringWithFormat:@"%@/event/details/%@/%@/%@",PHBaseURL,event_id,self.sharedData.fb_id,self.sharedData.gender];
    
    NSLog(@"EVENTS_GUEST_LIST_URL :: %@",url);
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
     }  failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
     }];
}

-(void)populateData:(NSDictionary *)dict
{
    NSLog(@"EVENTS_DICT :: %@",self.sharedData.mixPanelCEventDict);
    [[AnalyticManager sharedManager] trackMixPanelWithDict:@"View Event Details Modal" withDict:self.sharedData.mixPanelCEventDict];
    //[self.sharedData trackMixPanel:@"display_venue_details"];
    
    //Title
    self.title.text = [dict[@"title"] uppercaseString];
    
    //Venue
    self.venueName.text = [dict[@"venue_name"] uppercaseString];
    
    //Get list of users
    NSMutableArray *userList;
    if([self.sharedData isHost] || [self.sharedData isMember])
    {
        userList = [dict objectForKey:@"guests_viewed"];
    }
    else if([self.sharedData isGuest])
    {
        userList = [dict objectForKey:@"hosters"];
    }
    
    //Separator 1
    self.separator1.frame = CGRectMake(20,self.venueName.frame.size.height + self.venueName.frame.origin.y + 16, self.sharedData.screenWidth - 40, 1);
    
    long totalUsers = 0;//[userList count];
    if(totalUsers>0)
    {
        self.listingContainer.frame = CGRectMake(0, self.separator1.frame.origin.y + self.separator1.frame.size.height + 16, self.sharedData.screenWidth, PROFILE_SIZE + 56 + 16);
        self.listingContainer.hidden = NO;
        
        //Hosts or Guests COUNT
        self.hostNum.frame = CGRectMake(20, 0, self.sharedData.screenWidth - 40, PROFILE_SIZE);
        if([self.sharedData isHost] || [self.sharedData isMember])
        {
            self.btnInfo.hidden = NO;
            self.hostNum.textAlignment = NSTextAlignmentLeft;
            self.hostNum.text = [NSString stringWithFormat:@"%d GUEST%@\nINTERESTED",(int)[userList count],([userList count] > 1)?@"S":@""];
            self.hostNum.numberOfLines = 2;
        }
        else if([self.sharedData isGuest])
        {
            self.btnInfo.hidden = NO;
            self.hostNum.textAlignment = NSTextAlignmentLeft;
            self.hostNum.text = [NSString stringWithFormat:@"%d HOST%@",(int)[userList count],([userList count] > 1)?@"S":@""];
            self.hostNum.numberOfLines = 1;
        }
        
        [self.userContainer.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        self.userContainer.frame = self.hostNum.frame;
        
        //Get starting location
        long hostingWidth = (PROFILE_PICS * (PROFILE_SIZE+PROFILE_PADDING)) - PROFILE_PADDING;
        long x1 = self.hostNum.frame.size.width - hostingWidth;
        if([userList count]<PROFILE_PICS) {
            x1 += (PROFILE_PICS - [userList count]) * (PROFILE_SIZE+PROFILE_PADDING);
        }
        
        //Get total pics
        if(totalUsers > PROFILE_PICS) totalUsers = PROFILE_PICS - 1;
        
        //Loop through pics
        for (int i = 0; i < totalUsers; i++) {
            NSDictionary *user = userList[i];
            UserBubble *btnPic = [[UserBubble alloc] initWithFrame:CGRectMake(x1, 0, PROFILE_SIZE, PROFILE_SIZE)];
            btnPic.userInteractionEnabled = NO;
            [btnPic setName:user[@"first_name"] lastName:nil];
            [btnPic loadFacebookImage:user[@"fb_id"]];
            [self.userContainer addSubview:btnPic];
            x1 += PROFILE_SIZE + PROFILE_PADDING;
        }
        
        //Show +MORE button
        if([userList count] > PROFILE_PICS)
        {
            UIButton *btnPic = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btnPic.userInteractionEnabled = NO;
            btnPic.frame = CGRectMake( x1, 0, PROFILE_SIZE, PROFILE_SIZE);
            
            btnPic.layer.cornerRadius = PROFILE_SIZE/2;
            btnPic.layer.masksToBounds = YES;
            btnPic.layer.borderColor = [UIColor phCyanColor].CGColor;
            btnPic.layer.borderWidth = 2.0;
            btnPic.backgroundColor = [UIColor clearColor];
            [btnPic setTitleEdgeInsets:UIEdgeInsetsMake(2,0,0,2)];
            [btnPic setTitle:[NSString stringWithFormat:@"+%d",(int)[userList count] - PROFILE_PICS + 1] forState:UIControlStateNormal];
            btnPic.titleLabel.font = [UIFont phBold:18];
            [btnPic setTitleColor:[UIColor phCyanColor] forState:UIControlStateNormal];
            [self.userContainer addSubview:btnPic];
        }
        
        //See all button
        self.seeAllView.frame = CGRectMake(-4,self.hostNum.frame.size.height + self.hostNum.frame.origin.y + 16, self.sharedData.screenWidth + 8, 56);
        
        //See all label
        self.seeAllLabel.frame = CGRectMake(-4,self.hostNum.frame.size.height + self.hostNum.frame.origin.y + 17, self.seeAllView.frame.size.width, self.seeAllView.frame.size.height);
        if([self.sharedData isHost] || [self.sharedData isMember]) {self.seeAllLabel.text = @"SEE ALL GUESTS";}
        else {self.seeAllLabel.text = @"SEE ALL HOSTS";}
        
        //See all caret
        self.seeAllCaret.frame = CGRectMake(self.sharedData.screenWidth-20-32,self.seeAllView.frame.origin.y + 12, 32, 32);
        
        self.btnInfo.hidden = NO;
    }
    else
    {
        self.listingContainer.frame = CGRectMake(0, self.separator1.frame.origin.y + self.separator1.frame.size.height, self.sharedData.screenWidth, 0);
        self.listingContainer.hidden = YES;
        
        self.btnInfo.hidden = YES;
    }
    
    //Get tags
    self.tagArray = [[NSMutableArray alloc] init];
    [self.tagArray removeAllObjects];
    [self.tagArray addObjectsFromArray:dict[@"tags"]];
    
    //Tags!!!
    if([self.tagArray count]>0)
    {
        self.tagCollection.frame = CGRectMake(20, self.listingContainer.frame.size.height + self.listingContainer.frame.origin.y + 16, self.sharedData.screenWidth - 40, 44);
        //[self.tagArray addObjectsFromArray:@[@"HOUSE",@"TECHO",@"RAP",@"BLUES",@"HOUSE",@"TECHO",@"RAP",@"BLUES"]];
        [self.tagCollection reloadData];
        self.tagCollection.frame = CGRectMake(20, self.listingContainer.frame.size.height + self.listingContainer.frame.origin.y + 16, self.sharedData.screenWidth - 40, self.tagCollection.collectionViewLayout.collectionViewContentSize.height);
        
        //Separator 2
        self.separator2.frame = CGRectMake(20,self.tagCollection.frame.size.height + self.tagCollection.frame.origin.y + 16, self.sharedData.screenWidth - 40, 1);
        self.separator2.hidden = NO;
    }
    else
    {
        self.tagCollection.frame = CGRectMake(20, self.listingContainer.frame.size.height + self.listingContainer.frame.origin.y, self.sharedData.screenWidth - 40, 0);
        
        //Separator 2
        self.separator2.frame = CGRectMake(20,self.tagCollection.frame.size.height + self.tagCollection.frame.origin.y, self.sharedData.screenWidth - 40, 1);
        self.separator2.hidden = YES;
    }
    
    //Event Date
    self.eventDate.text = [[Constants toTitleDateRange:dict[@"start_datetime_str"] dbEndDateString:dict[@"end_datetime_str"]] uppercaseString];
    self.eventDate.frame = CGRectMake(30, self.separator2.frame.origin.y + self.separator2.frame.size.height + 16, self.sharedData.screenWidth - 60, 20);
    
    //Separator 3
    self.separator3.frame = CGRectMake(20,self.eventDate.frame.size.height + self.eventDate.frame.origin.y + 14, self.sharedData.screenWidth - 40, 1);
    
    //About body
    self.aboutBody.frame = CGRectMake(16, self.separator3.frame.size.height + self.separator3.frame.origin.y + 10, self.sharedData.screenWidth - 32, 0);
    self.aboutBody.text = dict[@"description"];
    [self.aboutBody sizeToFit];
    
    //White inner bg
    self.innerBg.frame = CGRectMake(0, self.picScroll.frame.origin.y + self.picScroll.frame.size.height, self.sharedData.screenWidth, 20+ self.aboutBody.frame.origin.y + self.aboutBody.frame.size.height -(self.picScroll.frame.origin.y + self.picScroll.frame.size.height));
    
    //See map button
    self.seeMapView.frame = CGRectMake(-4,self.aboutBody.frame.size.height + self.aboutBody.frame.origin.y + 16, self.sharedData.screenWidth + 8, 56);
    
    //See all label
    self.seeMapLabel.frame = CGRectMake(52,self.aboutBody.frame.size.height + self.aboutBody.frame.origin.y + 17, self.seeMapView.frame.size.width-40-64, self.seeMapView.frame.size.height);
    self.seeMapLabel.text = [dict[@"venue"][@"address"] uppercaseString];
    
    //See all caret
    self.seeMapCaret.frame = CGRectMake(self.sharedData.screenWidth-20-32,self.seeMapView.frame.origin.y + 12, 32, 32);
    
    //Config map
    self.mapView.frame = CGRectMake(0, self.seeMapView.frame.size.height + self.seeMapView.frame.origin.y, self.sharedData.screenWidth, 200);
    //[self.mapView setCenterCoordinate:location zoomLevel:10 animated:YES];
    [self.mapView removeAnnotations:self.mapView.annotations];
    self.mapView.hidden = NO;
    
    //Get photos from event then venue
    NSArray *photos = dict[@"photos"];
    //if([photos count]==0) {photos = dict[@"venue"][@"photos"];}
    
    NSLog(@"VENUE_PHOTOS :: %@",photos);
    //Page control
    self.pControl.currentPage = 0;
    self.pControl.numberOfPages = [photos count];
    
    //Load pics
    [self.picScroll.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    self.picScroll.contentOffset = CGPointMake(0, 0);
    for (int i = 0; i < [photos count]; i++)
    {
        UIView *imgCon = [[UIView alloc] initWithFrame:CGRectMake(i * self.sharedData.screenWidth, 0, self.sharedData.screenWidth, 300)];
        imgCon.layer.masksToBounds = YES;
        
        PHImage *img = [[PHImage alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 300)];
        img.contentMode = UIViewContentModeScaleAspectFill;
        NSString *picURL = photos[i];
        picURL = [self.sharedData picURL:picURL];
        img.showLoading = YES;
        [img loadImage:picURL defaultImageNamed:nil];
        [imgCon addSubview:img];
        [self.picScroll addSubview:imgCon];
    }
    self.picScroll.contentSize = CGSizeMake([photos count] * self.sharedData.screenWidth, 300);
    
    //Map
    CLLocationDegrees latitude = [dict[@"venue"][@"lat"] doubleValue];
    CLLocationDegrees longitude = [dict[@"venue"][@"long"] doubleValue];
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
    
    //Calc host here
    if([self.sharedData isHost] || [self.sharedData isMember]) //Host mode has HOST HERE button
    {
        self.btnHostHere.hidden = NO;
        self.mainScroll.frame = CGRectMake(0, 20, self.sharedData.screenWidth, self.frame.size.height-20);
        
        
        self.btnHostHere.userInteractionEnabled = YES;
        self.btnHostHere.backgroundColor = [UIColor phPurpleColor];
        [self.btnHostHere setTitle:@"BOOK TABLE" forState:UIControlStateNormal];
        
        /*
         if([dict[@"has_hostings"] boolValue]==NO)
         {
         self.btnHostHere.userInteractionEnabled = YES;
         self.btnHostHere.backgroundColor = [UIColor phPurpleColor];
         [self.btnHostHere setTitle:@"BOOK TABLE" forState:UIControlStateNormal];
         }
         else
         {
         self.btnHostHere.userInteractionEnabled = NO;
         self.btnHostHere.backgroundColor = [UIColor phLightTitleColor];
         [self.btnHostHere setTitle:@"YOU ARE HOSTING HERE" forState:UIControlStateNormal];
         }
         */
    }
    else //Guest mode
    {
        self.btnHostHere.hidden = YES;
        self.mainScroll.frame = CGRectMake(0, 20, self.sharedData.screenWidth, self.sharedData.screenHeight-20-PHTabHeight);
    }
    
    
    self.mainScroll.contentSize = CGSizeMake(self.sharedData.screenWidth, self.mapView.frame.origin.y + self.mapView.frame.size.height);
    
    self.isLoaded = YES;
    
    //Show overlay
    /*
    if(totalUsers>0)
    {
        if(self.sharedData.isGuest && ![self.sharedData isMember])
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if(![defaults objectForKey:@"SHOWED_EVENTS_SUMMARY_HOST_OVERLAY"])
            {
                [defaults setValue:@"YES" forKey:@"SHOWED_EVENTS_SUMMARY_HOST_OVERLAY"];
                [defaults synchronize];
                
                [self.mainScroll setContentOffset:CGPointMake(0,300) animated:NO];
                CGPoint pt = [[[UIApplication sharedApplication] keyWindow] convertPoint:CGPointZero fromView:self.seeAllView];
                pt.x += CGRectGetMidX(self.seeAllView.frame) + 4;
                pt.y += 28;
                
                [self.sharedData.overlayView popup:@"Get connected" subtitle: @"Find out who is hosting at this event." x:pt.x y:pt.y];
            }
        }
        else
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if(![defaults objectForKey:@"SHOWED_EVENTS_SUMMARY_GUEST_OVERLAY"])
            {
                [defaults setValue:@"YES" forKey:@"SHOWED_EVENTS_SUMMARY_GUEST_OVERLAY"];
                [defaults synchronize];
                
                [self.mainScroll setContentOffset:CGPointMake(0,300) animated:NO];
                CGPoint pt = [[[UIApplication sharedApplication] keyWindow] convertPoint:CGPointZero fromView:self.seeAllView];
                pt.x += CGRectGetMidX(self.seeAllView.frame) + 4;
                pt.y += 28;
                
                [self.sharedData.overlayView popup:@"Who's interested?" subtitle: @"Check out guests interested in attending." x:pt.x y:pt.y];
            }
        }
    }
     */
}

-(void)initClass
{
    [self loadData:self.sharedData.cEventId_Modal];
}

-(void)goBack
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"EXIT_EVENT_MODAL"
     object:self];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int width = self.picScroll.frame.size.width;
    float xPos = scrollView.contentOffset.x+10;
    
    //Calculate the page we are on based on x coordinate position and width of scroll view
    self.pControl.currentPage = (int)xPos/width;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAddressInMap)];
    [view addGestureRecognizer:tap];
}

-(void)showAddressInMap
{
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:self.cPlaceMark];
    MKMapItem *endingItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    NSMutableDictionary *launchOptions = [[NSMutableDictionary alloc] init];
    [endingItem openInMapsWithLaunchOptions:launchOptions];
}

-(void)reset
{
    if([lastEventId isEqualToString:self.event_id]) return;
    if(self.event_id!=nil) lastEventId = [NSString stringWithString:self.event_id];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    //Add to view count if guest
    //[self addViewCount];
    
    self.btnInfo.hidden = YES;
    
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
    self.title.text = @"";
    self.venueName.text = @"";
    self.aboutBody.text = @"";
    self.seeAllLabel.text = @"";
    self.hostNum.text = @"";
    self.eventDate.text = @"";
    
    //Rescroll
    self.mainScroll.contentOffset = CGPointMake(0, 0);
    
    self.isLoaded = NO;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.tagArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",[self.tagArray count]);
    
    static NSString *cellIdentifier = @"EventsSummaryTagCell";
    SetupPickViewCell *cell = (SetupPickViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSString *title = self.tagArray[indexPath.row];
    [cell.button.button setTitle:[title uppercaseString] forState:UIControlStateNormal];
    cell.button.button.titleLabel.font = [UIFont phBold:12];
    cell.button.offTextColor = [UIColor whiteColor];
    cell.button.offBackgroundColor = [UIColor clearColor];
    
    if ([title isEqualToString:@"Featured"]) {
        cell.button.offBackgroundColor = [UIColor colorFromHexCode:@"D9603E"];
    } else if ([title isEqualToString:@"Music"]) {
        cell.button.offBackgroundColor = [UIColor colorFromHexCode:@"5E3ED9"];
    } else if ([title isEqualToString:@"Nightlife"]) {
        cell.button.offBackgroundColor = [UIColor colorFromHexCode:@"4A555A"];
    } else if ([title isEqualToString:@"Food & Drink"]) {
        cell.button.offBackgroundColor = [UIColor colorFromHexCode:@"DDC54D"];
    } else if ([title isEqualToString:@"Fashion"]) {
        cell.button.offBackgroundColor = [UIColor colorFromHexCode:@"68CE49"];
    } else {
        cell.button.offBackgroundColor = [UIColor colorFromHexCode:@"ED4FC4"];
    }
    
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

-(void)addViewCount
{
    //Guests only
    //if(self.sharedData.isHost) return;
    
    NSLog(@"VIEW_COUNT :: %@",self.event_id);
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    NSString *url = [Constants guestEventsViewedURL:self.event_id fb_id:self.sharedData.fb_id];
    
    NSLog(@"VIEW_COUNT_URL :: %@",url);
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"VIEW_COUNT_UPDATED");
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"VIEW_COUNT_ERROR :: %@",error);
     }];
}

@end



