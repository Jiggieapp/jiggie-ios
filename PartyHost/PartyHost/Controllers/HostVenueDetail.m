//
//  HostVenueDetail.m
//  PartyHost
//
//  Created by Tony Suriyathep on 6/15/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "HostVenueDetail.h"


@implementation HostVenueDetail

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    
    self.sharedData = [SharedData sharedInstance];
    
    self.tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 60)];
    self.tabBar.backgroundColor = [UIColor phLightTitleColor];
    [self addSubview:self.tabBar];
    
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
    self.btnBack.frame = CGRectMake(self.sharedData.screenWidth - 50 - 8, 15, 50, 50);
    [self.btnBack setTitle:@"Done" forState:UIControlStateNormal];
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
    
    return self;
}


-(void)loadData:(NSDictionary *)dict
{
    //NSLog(@">>> %@",dict);
    
    self.title.text = @"EVENT DETAILS";
    
    //Adjust shout
    self.shoutBody.frame = CGRectMake(10, 8, self.sharedData.screenWidth - 20, 100);
    self.shoutBody.text = dict[@"hosting"][@"description"];
    [self.shoutBody sizeToFit];
    self.shoutBody.frame = CGRectMake(10, 8, self.sharedData.screenWidth - 20, self.shoutBody.frame.size.height);
    
    //Reset pic scroll
    self.picScroll.frame = CGRectMake(0, self.shoutBody.frame.origin.y + self.shoutBody.frame.size.height+10, self.sharedData.screenWidth, 300);
    [self.picScroll.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    self.picScroll.contentOffset = CGPointMake(0, 0);
    
    //Event Info
    NSString* eventName = dict[@"event"][@"title"];
    NSString* eventAddress = dict[@"event"][@"venue"][@"address"];
    NSString* eventStartDate = dict[@"event"][@"start_datetime_str"];
    NSString* eventEndDate = dict[@"event"][@"end_datetime_str"];
    
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
    self.aboutBody.text = [self.sharedData clipSpace:dict[@"event"][@"description"]];
    [self.aboutBody sizeToFit];
    
    self.mapView.frame = CGRectMake(0, self.aboutBody.frame.size.height + self.aboutBody.frame.origin.y + 10, self.sharedData.screenWidth, 300);
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    self.pControl.currentPage = 0;
    self.pControl.numberOfPages = [dict[@"event"][@"photos"] count];
    
    for (int i = 0; i < self.pControl.numberOfPages; i++)
    {
        UIView *imgCon = [[UIView alloc] initWithFrame:CGRectMake(i * self.sharedData.screenWidth, 0, self.sharedData.screenWidth, 300)];
        imgCon.layer.masksToBounds = YES;
        
        PHImage *img = [[PHImage alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 300)];
        img.contentMode = UIViewContentModeScaleAspectFill;
        NSString *picURL = dict[@"event"][@"photos"][i];
        picURL = [self.sharedData picURL:picURL];
        img.showLoading = YES;
        [img loadImage:picURL defaultImageNamed:nil];
        [imgCon addSubview:img];
        [self.picScroll addSubview:imgCon];
    }
    
    self.picScroll.contentSize = CGSizeMake(self.pControl.numberOfPages * self.sharedData.screenWidth, 300);
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    NSString *fullAddress = [NSString stringWithFormat:@"%@,%@ %@",dict[@"event"][@"venue"][@"address"],dict[@"event"][@"venue"][@"city"],dict[@"event"][@"venue"][@"zip"]];
    
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
    //[self.sharedData trackMixPanel:@"display_host_venue_details"];
    
    self.picScroll.contentOffset = CGPointMake(0, 0);
    self.mainScroll.contentOffset = CGPointMake(0, 0);
}

-(void)goBack
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"EXIT_HOST_VENUE_DETAIL"
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
