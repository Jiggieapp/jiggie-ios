//
//  EventsVenueDetail.m
//  PartyHost
//
//  Created by Sunny Clark on 2/14/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "EventsVenueDetail.h"

@implementation EventsVenueDetail

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    
    self.sharedData = [SharedData sharedInstance];
    
    self.tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 77)];
    self.tabBar.backgroundColor = [UIColor phLightTitleColor];
    [self addSubview:self.tabBar];
    
    self.btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnBack.frame = CGRectMake(0, 20, 40, 40);
    [self.btnBack setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [self.btnBack setImageEdgeInsets:UIEdgeInsetsMake(8, 14, 8, 14)];
    [self.btnBack addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:self.btnBack];
    
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(40, 32, self.sharedData.screenWidth-80, 22)];
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.textColor = [UIColor whiteColor];
    self.title.font = [UIFont phBold:18];
    self.title.adjustsFontSizeToFitWidth = YES;
    [self.tabBar addSubview:self.title];
    
    self.subtitle = [[UILabel alloc] initWithFrame:CGRectMake(30, self.title.frame.origin.y + self.title.frame.size.height -2, self.sharedData.screenWidth - 60, 20)];
    self.subtitle.font = [UIFont phBold:9];
    self.subtitle.textAlignment = NSTextAlignmentCenter;
    self.subtitle.textColor = [UIColor colorWithWhite:1 alpha:0.75];
    self.subtitle.userInteractionEnabled = NO;
    self.subtitle.backgroundColor = [UIColor clearColor];
    [self.tabBar addSubview:self.subtitle];
    
    self.mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.tabBar.frame.size.height + self.tabBar.frame.origin.y, self.sharedData.screenWidth, self.frame.size.height - self.tabBar.frame.size.height + self.tabBar.frame.origin.y)];
    self.mainScroll.showsVerticalScrollIndicator    = NO;
    self.mainScroll.showsHorizontalScrollIndicator  = NO;
    self.mainScroll.scrollEnabled                   = YES;
    self.mainScroll.userInteractionEnabled          = YES;
    self.mainScroll.delegate                        = self;
    self.mainScroll.backgroundColor                 = [UIColor phDarkBodyColor];
    self.mainScroll.contentSize                     = CGSizeMake(self.sharedData.screenWidth, 1000);
    [self addSubview:self.mainScroll];
    
    UIView *tmpPurpleView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, self.sharedData.screenWidth, 600)];
    tmpPurpleView.backgroundColor = [UIColor phDarkBodyColor];
    [self.mainScroll addSubview:tmpPurpleView];
    
    self.picScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 300)];
    self.picScroll.showsVerticalScrollIndicator    = NO;
    self.picScroll.showsHorizontalScrollIndicator  = NO;
    self.picScroll.scrollEnabled                   = YES;
    self.picScroll.userInteractionEnabled          = YES;
    self.picScroll.pagingEnabled                   = YES;
    self.picScroll.delegate                        = self;
    self.picScroll.backgroundColor                 = [UIColor blackColor];
    [self.mainScroll addSubview:self.picScroll];
    
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
    
    
    self.pControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.picScroll.frame.size.height - 50, self.sharedData.screenWidth, 50)];
    self.pControl.userInteractionEnabled = NO;
    [self.mainScroll addSubview:self.pControl];
    
    return self;
}


-(void)loadData:(NSDictionary *)dict
{
    NSString *description = dict[@"description"];
    //if([description length]==0) {description = dict[@"venue"][@"description"];}
    
    
    
    [self.sharedData.mixPanelCEventDict removeAllObjects];
    [self.sharedData.mixPanelCEventDict setObject:dict[@"title"] forKey:@"Event Name"];
    [self.sharedData.mixPanelCEventDict setObject:dict[@"start_datetime_str"] forKey:@"Event Start Time"];
    [self.sharedData.mixPanelCEventDict setObject:dict[@"end_datetime_str"] forKey:@"Event End Time"];
    [self.sharedData.mixPanelCEventDict setObject:dict[@"description"] forKey:@"Event Description"];
    [self.sharedData.mixPanelCEventDict setObject:dict[@"venue_name"] forKey:@"Event Venue Name"];
    [self.sharedData.mixPanelCEventDict setObject:dict[@"venue"][@"neighborhood"] forKey:@"Event Venue Neighborhood"];
    [self.sharedData.mixPanelCEventDict setObject:dict[@"venue"][@"city"] forKey:@"Event Venue City"];
    //[self.sharedData.mixPanelCEventDict setObject:dict[@"venue"][@"state"] forKey:@"Event Venue State"];
    [self.sharedData.mixPanelCEventDict setObject:dict[@"venue"][@"description"] forKey:@"Event Venue Description"];
    [self.sharedData.mixPanelCEventDict setObject:dict[@"venue"][@"zip"] forKey:@"Event Venue Zip"];
    
    [self.sharedData trackMixPanelWithDict:@"View Event Details" withDict:self.sharedData.mixPanelCEventDict];
    //[self.sharedData trackMixPanel:@"display_venue_details"];
    
    //Title
    self.title.text = [dict[@"title"] uppercaseString];
    
    //Date
    self.subtitle.text = [[Constants toTitleDate:dict[@"start_datetime_str"]] uppercaseString];
    
    self.aboutBody.frame = CGRectMake(20, self.picScroll.frame.size.height + self.picScroll.frame.origin.y + 10, self.sharedData.screenWidth - 40, 0);
    self.aboutBody.text = [self.sharedData clipSpace:description];
    [self.aboutBody sizeToFit];
    
    self.mapView.frame = CGRectMake(0, self.aboutBody.frame.size.height + self.aboutBody.frame.origin.y + 10, self.sharedData.screenWidth, 300);
    //[self.mapView setCenterCoordinate:location zoomLevel:10 animated:YES];
    [self.mapView removeAnnotations:self.mapView.annotations];
    
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
    
    self.mainScroll.contentSize = CGSizeMake(self.sharedData.screenWidth, 630 + self.aboutBody.frame.size.height);
}

-(void)initClass
{
    self.picScroll.contentOffset = CGPointMake(0, 0);
    self.mainScroll.contentOffset = CGPointMake(0, 0);
}

-(void)goBack
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"EVENTS_GO_HOSTINGS_LIST"
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
