//
//  City.h
//  Jiggie
//
//  Created by Mohammad Nuruddin Effendi on 6/8/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"

@interface City : MTLModel <MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSString *identifier;
@property (copy, nonatomic, readonly) NSString *country;
@property (copy, nonatomic, readonly) NSString *name;

+ (void)retrieveCitiesWithCompletionHandler:(CitiesCompletionHandler)completion;

@end
