//
//  LocationManager.m
//  Jiggie
//
//  Created by Uuds on 4/22/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *location;
@property (nonatomic, strong) LocationManagerUpdateLocationsCompletion locationManagerUpdateLocationsCompletion;
@property (nonatomic, assign) BOOL didUpdatedLocation;

@end

@implementation LocationManager

+ (LocationManager *)manager {
    static LocationManager *_sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (instancetype)init {
    if (self = [super init]) {
        self.location  = [CLLocationManager new];
        [self.location setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        
        if (!self.location.delegate) {
            self.location.delegate = self;
        }
    }
    
    return self;
}

- (void)startUpdatingLocation {
    if ([self.location respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.location requestWhenInUseAuthorization];
    } else {
        [self.location startUpdatingLocation];
    }
    
    if([CLLocationManager locationServicesEnabled]) {
        if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
           [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        } else {
            [self.location startUpdatingLocation];
        }
    }
    
    self.didUpdatedLocation = false;
}

- (void)didUpdateLocationsWithCompletion:(LocationManagerUpdateLocationsCompletion)completion {
    self.locationManagerUpdateLocationsCompletion = completion;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse: {
            [self.location startUpdatingLocation];
        }
            
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (!self.didUpdatedLocation) {
        if (self.locationManagerUpdateLocationsCompletion) {
            self.locationManagerUpdateLocationsCompletion(locations[0].coordinate.latitude,
                                                          locations[0].coordinate.longitude);
        }
    }
    
    self.didUpdatedLocation = true;
}

@end
