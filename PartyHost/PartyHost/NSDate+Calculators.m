//
//  NSDate+Calculators.m
//  Party Host
//
//  Created by Aaron Junod on 3/10/14.
//  Copyright (c) 2014 PartyHost. All rights reserved.
//

#import "NSDate+Calculators.h"
//#import <SAMCategories.h>
//#import <SORelativeDateTransformer.h>

@implementation NSDate (Calculators)

+ (instancetype) thisFriday {
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit fromDate:[NSDate date]];
    
    components.calendar = calendar;
    [components setHour:22];
    [components setMinute:0];
    [components setSecond:0];
    
	NSUInteger weekdayToday = [components weekday];
	NSInteger daysToMonday = (13 - weekdayToday) % 7;
    


	NSDate *nextMonday = [[components date] dateByAddingTimeInterval:60*60*24*daysToMonday];
    return nextMonday;
}

- (NSString *) phFormatted {
    NSString *relativeDate;
    if ([self daysFrom:[NSDate date]] < 7 && [self daysFrom:[NSDate date]] > 0) {
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"EEEE";
        relativeDate = [formatter stringFromDate:self];
    } else if ([self daysFrom:[NSDate date]] < 14 && [self daysFrom:[NSDate date]] > 0){
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"'Next 'EEEE";
        relativeDate = [formatter stringFromDate:self];
    } else {
        //relativeDate = [[SORelativeDateTransformer registeredTransformer] transformedValue:self];
    }
    
    if ([self daysFrom:[NSDate date]] > 1) {
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"hh:mm";
        relativeDate = [NSString stringWithFormat:@"%@ at %@", relativeDate, [formatter stringFromDate:self]];
    }
    return relativeDate;
}

- (NSString *) phFormattedNoTime {
    NSString *relativeDate;
    NSInteger daysFrom = [self daysFrom:[NSDate date]];
    if ((daysFrom < 7 && daysFrom > 0) || daysFrom < 1) {
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"EEEE";
        relativeDate = [formatter stringFromDate:self];
    } else if (daysFrom < 14 && daysFrom > 0){
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"'Next 'EEEE";
        relativeDate = [formatter stringFromDate:self];
    } else {
        //relativeDate = [[SORelativeDateTransformer registeredTransformer] transformedValue:self];
    }
    
    return relativeDate;
}

-(int)daysFrom:(NSDate *)date
{
    NSDate *fromDate;
    NSDate *toDate;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:date];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:[NSDate date]];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return (int)[difference day];
}

- (NSString *) isoDateValue {
    if (self == nil) return nil;
    NSDateFormatter *formatter = [self jsonFormatter];
    return [formatter stringFromDate:self];
}

- (NSString *) isoDateTimeValue {
    if (self == nil) return nil;
    NSDateFormatter *formatter = [self jsonTimeFormatter];
    return [formatter stringFromDate:self];
}

+ (instancetype) dateFromIsoDate:(NSString *)dateString {
//    return [NSDate sam_dateFromISO8601String:dateString];
    NSDateFormatter *formatter = [self jsonFormatter];
    return [formatter dateFromString:dateString];
}

+ (instancetype) dateTimeFromIsoDate:(NSString *)dateString {
    NSDateFormatter *formatter = [self jsonTimeFormatter];
    return [formatter dateFromString:dateString];
}

- (NSDateFormatter *) jsonTimeFormatter {
    return [NSDate jsonTimeFormatter];
}

- (NSDateFormatter *) jsonFormatter {
    return [NSDate jsonFormatter];
}

+ (NSDateFormatter *) jsonFormatter {
//    return [self jsonTimeFormatter];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"US/Eastern"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return dateFormatter;
}

+ (NSDateFormatter *) jsonTimeFormatter {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat: @"yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"];
    return dateFormatter;
}

@end
