//
//  HostVenueDetail.m
//  PartyHost
//
//  Created by Tony Suriyathep on 6/15/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "HostVenueDetailFromShare.h"

@implementation HostVenueDetailFromShare

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor phDarkTitleColor];
    
    self.sharedData = [SharedData sharedInstance];
    
    UIView *tmpOPurpleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 600)];
    tmpOPurpleView.backgroundColor = [UIColor phDarkTitleColor];
    [self addSubview:tmpOPurpleView];
    
    self.tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 60)];
    self.tabBar.backgroundColor = [UIColor phDarkTitleColor];
    [self addSubview:self.tabBar];
    
    /*
    self.sharedData = [SharedData sharedInstance];
    
    self.tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 60)];
    self.tabBar.backgroundColor = [self.sharedData purpleColor];
    [self addSubview:self.tabBar];
    */
    
    //Title will have ellipses if its too wide
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, self.sharedData.screenWidth-120, 40)];
    self.title.text = @"";
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.textColor = [UIColor whiteColor];
    self.title.adjustsFontSizeToFitWidth = NO;
    self.title.lineBreakMode = NSLineBreakByTruncatingTail;
    self.title.font = [UIFont phBold:18];
    [self.tabBar addSubview:self.title];
    
    self.btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnBack.frame = CGRectMake(self.sharedData.screenWidth - 44 + 2, 17, 44, 44);
    [self.btnBack setBackgroundImage:[UIImage imageNamed:@"nav_cancel"] forState:UIControlStateNormal];
    [self.btnBack addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:self.btnBack];
    
    self.mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.tabBar.frame.size.height + self.tabBar.frame.origin.y, self.sharedData.screenWidth, self.frame.size.height - self.tabBar.frame.size.height + self.tabBar.frame.origin.y)];
    self.mainScroll.showsVerticalScrollIndicator    = NO;
    self.mainScroll.showsHorizontalScrollIndicator  = NO;
    self.mainScroll.scrollEnabled                   = YES;
    self.mainScroll.userInteractionEnabled          = YES;
    self.mainScroll.delegate                        = self;
    self.mainScroll.backgroundColor                 = [UIColor phDarkBodyColor];
    self.mainScroll.contentSize                     = CGSizeMake(self.sharedData.screenWidth, 1000);
    [self addSubview:self.mainScroll];
    
    UIView *tmpPurpleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 600)];
    tmpPurpleView.backgroundColor = [UIColor phDarkBodyColor];
    [self.mainScroll addSubview:tmpPurpleView];
    
    self.shoutBody = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, self.sharedData.screenWidth - 20, 100)];
    self.shoutBody.font = [UIFont phBlond:15];
    [self.shoutBody setTextContainerInset:UIEdgeInsetsMake(10,5,10,5)];
    self.shoutBody.textColor = [UIColor blackColor];
    self.shoutBody.textAlignment = NSTextAlignmentLeft;
    self.shoutBody.userInteractionEnabled = NO;
    self.shoutBody.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.75];
    self.shoutBody.text = @"";
    self.shoutBody.layer.cornerRadius = 10;
    self.shoutBody.layer.masksToBounds = YES;
    [self.mainScroll addSubview:self.shoutBody];
    
    self.picScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.shoutBody.frame.origin.y + self.shoutBody.frame.size.height+10, self.sharedData.screenWidth, 300)];
    self.picScroll.showsVerticalScrollIndicator    = NO;
    self.picScroll.showsHorizontalScrollIndicator  = NO;
    self.picScroll.scrollEnabled                   = YES;
    self.picScroll.userInteractionEnabled          = YES;
    self.picScroll.pagingEnabled                   = YES;
    self.picScroll.delegate                        = self;
    self.picScroll.backgroundColor                 = [UIColor blackColor];
    [self.mainScroll addSubview:self.picScroll];
    
    //Big white title of venue
    self.imageTitle = [[UILabel alloc] init];
    self.imageTitle.frame = CGRectMake(8, self.picScroll.frame.origin.y+8, self.sharedData.screenWidth - 32, 24);
    self.imageTitle.textColor = [UIColor whiteColor];
    self.imageTitle.textAlignment = NSTextAlignmentLeft;
    self.imageTitle.font = [UIFont phBold:24];
    self.imageTitle.shadowColor = [UIColor blackColor];
    self.imageTitle.shadowOffset = CGSizeMake(0.5,0.5);
    [self.mainScroll addSubview:self.imageTitle];
    
    
    //Neighborhood of venue
    self.imageSubtitle = [[UILabel alloc] init];
    self.imageSubtitle.frame = CGRectMake(8, self.imageTitle.frame.origin.y+self.imageTitle.frame.size.height+3, self.sharedData.screenWidth - 32, 16);
    self.imageSubtitle.textColor = [UIColor whiteColor];
    self.imageSubtitle.textAlignment = NSTextAlignmentLeft;
    self.imageSubtitle.font = [UIFont phBlond:16];
    self.imageSubtitle.shadowColor = [UIColor blackColor];
    self.imageSubtitle.shadowOffset = CGSizeMake(0.25,0.25);
    [self.mainScroll addSubview:self.imageSubtitle];
    
    //Time
    self.imageTimeLabel = [[UILabel alloc] init];
    self.imageTimeLabel.frame = CGRectMake(8, self.imageSubtitle.frame.origin.y+self.imageSubtitle.frame.size.height+3, self.sharedData.screenWidth - 32, 16);
    self.imageTimeLabel.textColor = [UIColor colorFromHexCode:@"EEEEEE"];
    self.imageTimeLabel.textAlignment = NSTextAlignmentLeft;
    self.imageTimeLabel.font = [UIFont phBlond:12];
    self.imageTimeLabel.shadowColor = [UIColor blackColor];
    self.imageTimeLabel.shadowOffset = CGSizeMake(0.25,0.25);
    [self.mainScroll addSubview:self.imageTimeLabel];

    self.aboutBody = [[UITextView alloc] initWithFrame:CGRectMake(20, self.picScroll.frame.size.height + self.picScroll.frame.origin.y + 10, self.sharedData.screenWidth - 40, 400)];
    self.aboutBody.font = [UIFont phBlond:15];
    self.aboutBody.textColor = [UIColor whiteColor];
    self.aboutBody.textAlignment = NSTextAlignmentLeft;
    self.aboutBody.userInteractionEnabled = NO;
    self.aboutBody.backgroundColor = [UIColor clearColor];
    self.aboutBody.text = @"";
    [self.mainScroll addSubview:self.aboutBody];
    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 300)];
    self.mapView.userInteractionEnabled = YES;
    self.mapView.delegate = self;
    [self.mainScroll addSubview:self.mapView];
    
    self.pControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.picScroll.frame.origin.y + self.picScroll.frame.size.height - 50 - 50, self.sharedData.screenWidth, 50)];
    self.pControl.userInteractionEnabled = NO;
    [self.mainScroll addSubview:self.pControl];
    
    self.btnHostHere = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.btnHostHere.frame = CGRectMake(0, self.sharedData.screenHeight - 50, self.sharedData.screenWidth, 50);
    self.btnHostHere.titleLabel.font = [UIFont phBold:18];
    [self.btnHostHere setTitle:@"I'M INTERESTED" forState:UIControlStateNormal];
    [self.btnHostHere setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnHostHere setBackgroundColor:[UIColor phPurpleColor]];
    [self.btnHostHere addTarget:self action:@selector(hostHereButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnHostHere];
    self.btnHostHere.hidden = YES;
    
    self.mainData = [[NSMutableDictionary alloc] init];
    
    return self;
}


-(void)loadData:(NSDictionary *)dict
{
    /*
    if([self.sharedData.gender isEqualToString:@"female"] && [self.sharedData.gender_interest isEqualToString:@"male"] && [self.sharedData.account_type isEqualToString:@"guest"])
    {
        self.btnHostHere.hidden = NO;
        self.mainScroll.frame = CGRectMake(0, self.tabBar.frame.size.height + self.tabBar.frame.origin.y, self.sharedData.screenWidth, self.frame.size.height - self.tabBar.frame.size.height + self.tabBar.frame.origin.y - self.btnHostHere.frame.size.height);
        
    }else{
        self.btnHostHere.hidden = YES;
        self.mainScroll.frame = CGRectMake(0, self.tabBar.frame.size.height + self.tabBar.frame.origin.y, self.sharedData.screenWidth, self.frame.size.height - self.tabBar.frame.size.height + self.tabBar.frame.origin.y);
    }
    */
    
    self.title.text = @"EVENT DETAILS";
    self.btnHostHere.hidden = YES;
    
    
    
    
    [self.mainData removeAllObjects];
    [self.mainData addEntriesFromDictionary:dict];
    
    //Adjust shout
    self.shoutBody.frame = CGRectMake(10, 0, self.sharedData.screenWidth - 20, 100);
    self.shoutBody.text = dict[@"description"];
    [self.shoutBody sizeToFit];
    self.shoutBody.frame = CGRectMake(10, 0, self.sharedData.screenWidth - 20, self.shoutBody.frame.size.height);
    self.shoutBody.hidden = YES;
    self.shoutBody.frame = CGRectMake(10, 0, 0, 0);
    //Reset pic scroll
    self.picScroll.frame = CGRectMake(0, self.shoutBody.frame.origin.y + self.shoutBody.frame.size.height+10, self.sharedData.screenWidth, 300);
    [self.picScroll.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    self.picScroll.contentOffset = CGPointMake(0, 0);
    
    //Event Info
    NSString* eventName = dict[@"title"];
    NSString* eventAddress = dict[@"venue"][@"address"];
    NSString* eventStartDate = dict[@"start_datetime_str"];
    NSString* eventEndDate = dict[@"end_datetime_str"];
    
    self.imageTitle.frame = CGRectMake(8, self.picScroll.frame.origin.y+8, self.sharedData.screenWidth - 32, 24);
    self.imageTitle.text = eventName;
    
    self.imageSubtitle.frame = CGRectMake(8, self.imageTitle.frame.origin.y+self.imageTitle.frame.size.height+3, self.sharedData.screenWidth - 32, 16);
    self.imageSubtitle.text = eventAddress;
    
    //Show event date range? I'm gonna null check just in case
    if(eventStartDate!=NULL && eventEndDate!=NULL)
    {
        self.imageTimeLabel.frame = CGRectMake(8, self.imageSubtitle.frame.origin.y+self.imageSubtitle.frame.size.height+3, self.sharedData.screenWidth - 32, 16);
        self.imageTimeLabel.text = [Constants toDisplayDateRange:eventStartDate dbEndDateString:eventEndDate];
    }
    else {
        self.imageTimeLabel.text = @"";
    }
    
    //self.aboutBody.backgroundColor = [UIColor redColor];
    self.aboutBody.frame = CGRectMake(20, self.picScroll.frame.size.height + self.picScroll.frame.origin.y + 10, self.sharedData.screenWidth - 40, 400);
    self.aboutBody.text = [self.sharedData clipSpace:dict[@"description"]];
    [self.aboutBody sizeToFit];
    
    self.mapView.frame = CGRectMake(0, self.aboutBody.frame.size.height + self.aboutBody.frame.origin.y + 10, self.sharedData.screenWidth, 300);
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    self.pControl.currentPage = 0;
    self.pControl.numberOfPages = [dict[@"photos"] count];
    
    for (int i = 0; i < self.pControl.numberOfPages; i++)
    {
        UIView *imgCon = [[UIView alloc] initWithFrame:CGRectMake(i * self.sharedData.screenWidth, 0, self.sharedData.screenWidth, 300)];
        imgCon.layer.masksToBounds = YES;
        
        PHImage *img = [[PHImage alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 300)];
        img.contentMode = UIViewContentModeScaleAspectFill;
        NSString *picURL = dict[@"photos"][i];
        picURL = [self.sharedData picURL:picURL];
        img.showLoading = YES;
        [img loadImage:picURL defaultImageNamed:nil];
        [imgCon addSubview:img];
        [self.picScroll addSubview:imgCon];
    }
    
    self.picScroll.contentSize = CGSizeMake(self.pControl.numberOfPages * self.sharedData.screenWidth, 300);
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    NSString *fullAddress = [NSString stringWithFormat:@"%@,%@ %@",dict[@"venue"][@"address"],dict[@"venue"][@"city"],dict[@"venue"][@"zip"]];
    
    [geocoder geocodeAddressString:fullAddress completionHandler:^(NSArray *placemarks, NSError *error) {
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
    
    self.mainScroll.contentSize = CGSizeMake(self.sharedData.screenWidth, self.mapView.frame.origin.y + self.mapView.frame.size.height);
}

-(void)initClass
{
    self.btnHostHere.hidden = YES;
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    self.mainScroll.hidden = YES;
    [self loadHostingInfo];
    //[self performSelector:@selector(loadHostingInfo) withObject:nil afterDelay:3.0];
    //[self.sharedData trackMixPanel:@"display_host_venue_details"];
    
    self.picScroll.contentOffset = CGPointMake(0, 0);
    self.mainScroll.contentOffset = CGPointMake(0, 0);
}

-(void)loadHostingInfo
{
    ///user/hostings/details/
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    NSString *urlToLoad = [NSString stringWithFormat:@"%@/user/hostings/details/%@",PHBaseURL,self.sharedData.cHostingIdFromInvite];
    
    urlToLoad = [NSString stringWithFormat:@"%@/event/details/%@/%@/%@",PHBaseURL,self.sharedData.cEventId_Feed,self.sharedData.fb_id,self.sharedData.gender];
    
    NSLog(@"HOSTING_DETAILS_FROM_SHARE URL :: %@",urlToLoad);
    
    [manager GET:urlToLoad parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         NSLog(@"EVENT_DETAILS_RESPONSE :: %@",responseObject);
         [self.sharedData trackMixPanelWithDict:@"Event Details Popup From Share" withDict:@{}];
         
         [self loadData:responseObject];
         
         self.mainScroll.hidden = NO;
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
         NSLog(@"HOSTING_DETAILS_FROM_SHARE RESPONSE :: %@",responseObject);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"HOSTING_DETAILS_FROM_SHARE ERROR :: %@",error);
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
     }];
    
}

-(void)hostHereButtonClicked
{
    //Start spinner
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    //NSString *facebookId = [self.sharedData.userDict objectForKey:@"fb_id"];
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    NSDictionary *params = @{
                             @"message" : @"I'm interested in joining, please tell me more.",
                             @"from_fb_id" : self.sharedData.fb_id,
                             @"event_id": self.mainData[@"event_id"]
                             };
    
    NSLog(@"EVENTHOSTDETAIL-ACCEPT Started :: %@",self.mainData);
    NSLog(@"EVENTHOSTDETAIL-ACCEPT Params Sent :: %@",params);
    
    NSString *url = [NSString stringWithFormat:@"%@/user/hostings/forceaccepted/%@/%@",PHBaseURL,self.mainData[@"user_fb_id"],self.mainData[@"_id"]];
    
    NSLog(@"EVENTHOSTDETAIL-ACCEPT :: %@",url);
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"EVENTHOSTDETAIL-SAVE responseObject :: %@",responseObject);
         
         if(responseObject[@"success"])
         {
             if(![responseObject[@"success"] boolValue])
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Connection"
                                                                 message:@"Accept could not be set. Please try again."
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
                 [alert show];
                 
                 return;
             }
         }
         
          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your message was sent to the host" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
         [alert show];
        //[self.sharedData trackMixPanel:responseObject[@"chat_state"]];
         
         
         [self.sharedData trackMixPanelWithDict:@"Accept Invite" withDict:@{@"origin":@"Host Details Popup Share"}];
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         //[self.mainData[@"hosting"] setValue:[NSNumber numberWithBool:YES] forKey:@"is_accepted"];
         /*
          //Hide spinner
          [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
          */
         [self goBack];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"EVENTHOSTDETAIL-ERROR :: %@",error);
         
         //Hide spinner
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
         //Alert error!
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Connection"
                                                         message:@"Accept could not be set. Please try again."
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
         [alert show];
     }];
}

-(void)goBack
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"EXIT_HOST_VENUE_DETAIL_FROM_SHARE"
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

@end
