//
//  HostVenueDetail.h
//  PartyHost
//
//  Created by Tony Suriyathep on 6/15/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MKMapView+ZoomLevel.h"
#import "PHImage.h"

@interface HostVenueDetailFromShare : UIView<UIScrollViewDelegate,CLLocationManagerDelegate,MKMapViewDelegate>

@property(strong,nonatomic) SharedData *sharedData;

@property(nonatomic,strong) UIButton *btnBack;
@property(nonatomic,strong) UIView *tabBar;
@property(nonatomic,strong) UILabel *title;
@property(nonatomic,strong) UILabel *hostingBegins;
@property(nonatomic,strong) UIScrollView *mainScroll;
@property(nonatomic,strong) UIScrollView *picScroll;
@property(nonatomic,strong) UITextView *aboutBody;
@property(nonatomic,strong) UIPageControl *pControl;
@property(nonatomic,strong) MKMapView *mapView;
@property(nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,strong) MKPlacemark *cPlaceMark;
@property(nonatomic,strong) UITextView *shoutBody;
@property(nonatomic,strong) UILabel *imageTitle;
@property(nonatomic,strong) UILabel *imageSubtitle;
@property(nonatomic,strong) UILabel *imageTimeLabel;
@property(nonatomic,strong) UIButton *btnHostHere;

@property(nonatomic,strong) NSMutableDictionary *mainData;

-(void)loadData:(NSDictionary *)dict;
-(void)initClass;

@end
