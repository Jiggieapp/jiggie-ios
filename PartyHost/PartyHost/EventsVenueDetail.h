//
//  EventsVenueDetail.h
//  PartyHost
//
//  Created by Sunny Clark on 2/14/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MKMapView+ZoomLevel.h"
#import "PHImage.h"

@interface EventsVenueDetail : UIView<UIScrollViewDelegate,CLLocationManagerDelegate,MKMapViewDelegate>


@property (strong, nonatomic) SharedData    *sharedData;



@property(nonatomic,strong) UIButton        *btnBack;
@property(nonatomic,strong) UIView          *tabBar;
@property(nonatomic,strong) UILabel         *title;
@property(nonatomic,strong) UILabel         *subtitle;
@property(nonatomic,strong) UIScrollView    *mainScroll;
@property(nonatomic,strong) UIScrollView    *picScroll;
@property(nonatomic,strong) UITextView      *aboutBody;

@property (nonatomic,strong)  UIPageControl *pControl;


@property(nonatomic,strong) MKMapView *mapView;
@property(nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,strong) MKPlacemark *cPlaceMark;


-(void)loadData:(NSDictionary *)dict;
-(void)initClass;

@end
