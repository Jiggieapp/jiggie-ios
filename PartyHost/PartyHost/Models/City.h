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
@property (copy, nonatomic, readonly) NSString *initial;
@property (copy, nonatomic, readonly) NSNumber *timeZone;

+ (void)retrieveCitiesWithCompletionHandler:(CitiesCompletionHandler)completion;

+ (NSString *)pathToArchiveCities;
+ (void)archiveCities:(NSArray *)cities;
+ (NSArray *)unarchiveCities;
+ (void)removeArchivedCities;

@end
