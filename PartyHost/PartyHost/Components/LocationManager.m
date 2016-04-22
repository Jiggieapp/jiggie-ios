//
//  LocationManager.m
//  Jiggie
//
//  Created by Jiggie - Muhammad Nuruddin Effendi on 4/22/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) LocationManagerUpdateLocationsCompletion locationManagerUpdateLocationsCompletion;

@end

@implementation LocationManager

+ (LocationManager *)manager {
    static LocationManager *_sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
        [_sharedManager enableLocationService];
    });
    
    return _sharedManager;
}

- (void)enableLocationService {
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    if (!self.locationManager.delegate) {
        self.locationManager.delegate = self;
    }
    
    if([CLLocationManager locationServicesEnabled]) {
        if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
           [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        } else {
        }
    }
}

- (void)didUpdateLocationsWithCompletion:(LocationManagerUpdateLocationsCompletion)completion {
    [self.locationManager startUpdatingLocation];
    self.locationManagerUpdateLocationsCompletion = completion;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (self.locationManagerUpdateLocationsCompletion) {
        self.locationManagerUpdateLocationsCompletion(locations[0].coordinate.latitude,
                                                      locations[0].coordinate.longitude);
    }
}

@end
