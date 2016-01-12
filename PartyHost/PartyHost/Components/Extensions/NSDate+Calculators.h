//
//  NSDate+Calculators.h
//  Party Host
//
//  Created by Aaron Junod on 3/10/14.
//  Copyright (c) 2014 PartyHost. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Calculators)

+ (instancetype) thisFriday;
- (NSString *) isoDateValue;
- (NSString *) isoDateTimeValue;
+ (instancetype) dateFromIsoDate:(NSString *)dateString;
+ (instancetype) dateTimeFromIsoDate:(NSString *)dateString;
- (NSString *) phFormatted;
- (NSString *) phFormattedNoTime;

@end
