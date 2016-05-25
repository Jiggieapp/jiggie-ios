//
//  JGInviteHelper.m
//  Jiggie
//
//  Created by Setiady Wiguna on 5/23/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "JGInviteHelper.h"

@implementation JGInviteHelper

+ (BOOL)isValidShowInvite {
    
    // Show Invite Friends screen if user already visited Events Detail twice.
    NSInteger visitedEventsDetailCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"VISITED_EVENTS_DETAIL"];
    if (visitedEventsDetailCount < 5) {
        visitedEventsDetailCount++;
        
        [[NSUserDefaults standardUserDefaults] setInteger:visitedEventsDetailCount
                                                   forKey:@"VISITED_EVENTS_DETAIL"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (visitedEventsDetailCount == 4) {
            NSDate *scheduledDate = [[NSDate date] dateByAddingTimeInterval:60 * 60 * 24];
            [[NSUserDefaults standardUserDefaults] setObject:scheduledDate forKey:@"VISITED_EVENT_DETAIL_SCHEDULED"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            return YES;
        }
    } else {
        NSDate *scheduledDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"VISITED_EVENT_DETAIL_SCHEDULED"];
        if (scheduledDate) {
            if ([[NSDate date] compare:scheduledDate] == NSOrderedDescending) {
                if (visitedEventsDetailCount == 5) {
                    NSDate *scheduledDate = [[NSDate date] dateByAddingTimeInterval:7 * 60 * 60 * 24];
                    [[NSUserDefaults standardUserDefaults] setObject:scheduledDate forKey:@"VISITED_EVENT_DETAIL_SCHEDULED"];
                    
                     visitedEventsDetailCount++;
                    [[NSUserDefaults standardUserDefaults] setInteger:visitedEventsDetailCount
                                                               forKey:@"VISITED_EVENTS_DETAIL"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                } else {
                    NSDate *scheduledDate = [[NSDate date] dateByAddingTimeInterval:30 * 60 * 60 * 24];
                    [[NSUserDefaults standardUserDefaults] setObject:scheduledDate forKey:@"VISITED_EVENT_DETAIL_SCHEDULED"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                
                return YES;
            }
        }
    }
    return NO;
}

@end
