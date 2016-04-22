//
//  LocationManager.h
//  Jiggie
//
//  Created by Uuds on 4/22/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LocationManagerUpdateLocationsCompletion)(CLLocationDegrees latitude,
                                                         CLLocationDegrees longitude);

@interface LocationManager : NSObject

+ (LocationManager *)manager;

- (void)didUpdateLocationsWithCompletion:(LocationManagerUpdateLocationsCompletion)completion;

@end
