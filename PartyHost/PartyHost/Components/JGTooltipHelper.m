//
//  JGTooltipHelper.m
//  Jiggie
//
//  Created by Setiady Wiguna on 5/5/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "JGTooltipHelper.h"

@implementation JGTooltipHelper

+ (BOOL)isLoadEventTooltipValid {
    if (![self isAllTooltipValid]) {
        return NO;
    }
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if (![prefs boolForKey:@"Tooltip_LoadEvent_isShowed"] &&
        [self hasTooltipAlreadyPassADay:@"Tooltip_LoadEvent_LastDateShowed"]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isSocialTabTooltipValidAfter:(NSString *)tooltipKey {
    if (![self isAllTooltipValid]) {
        return NO;
    }

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([prefs boolForKey:tooltipKey] &&
        ![prefs boolForKey:@"Tooltip_SocialTab_isShowed"] &&
        [self hasTooltipAlreadyPassADay:@"Tooltip_SocialTab_LastDateShowed"]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isLikeEventTooltipValid {
    if (![self isAllTooltipValid]) {
        return NO;
    }
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if (![prefs boolForKey:@"Tooltip_LikeEvent_isShowed"] &&
        [self hasTooltipAlreadyPassADay:@"Tooltip_LikeEvent_LastDateShowed"]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isShareEventTooltipValid {
    if (![self isAllTooltipValid]) {
        return NO;
    }

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([prefs boolForKey:@"Tooltip_SocialTab_isShowed"] &&
        [prefs boolForKey:@"Tooltip_LikeEvent_isShowed"] &&
        ![prefs boolForKey:@"Tooltip_ShareEvent_isShowed"] &&
        [self hasTooltipAlreadyPassADay:@"Tooltip_ShareEvent_LastDateShowed"]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isAcceptSuggestionTooltipValid {
    if (![self isAllTooltipValid]) {
        return NO;
    }

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if (![prefs boolForKey:@"Tooltip_AcceptSuggestion_isShowed"] &&
        [self hasTooltipAlreadyPassADay:@"Tooltip_AcceptSuggestion_LastDateShowed"]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isAcceptRequestTooltipValid {
    if (![self isAllTooltipValid]) {
        return NO;
    }

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if (![prefs boolForKey:@"Tooltip_AcceptRequest_isShowed"] &&
        [self hasTooltipAlreadyPassADay:@"Tooltip_AcceptRequest_LastDateShowed"]) {
        return YES;
    }
    return NO;
}

+ (BOOL)hasTooltipAlreadyPassADay:(NSString *)tooltipKey {
    if (![self isAllTooltipValid]) {
        return NO;
    }

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDate *tooltipDate = (NSDate *)[prefs objectForKey:tooltipKey];
    
    if (!tooltipDate || tooltipDate == nil) {
        return YES;
    }
    
    if (ABS([[NSDate date] timeIntervalSinceDate:tooltipDate]) > 20) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isAllTooltipValid {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([prefs objectForKey:@"Tooltip_Valid"]) {
        if ([[prefs objectForKey:@"Tooltip_Valid"] isEqualToString:@"YES"]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Setter/Getter
+ (void)setUpTooltip {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if(![prefs objectForKey:@"Tooltip_Valid"]) {
        NSString *tooltipValid = @"YES";
        if ([prefs objectForKey:@"SHOWED_WALKTHROUGH"]) {
            if ([[prefs objectForKey:@"SHOWED_WALKTHROUGH"] isEqualToString:@"YES"]) {
                tooltipValid = @"NO";
            }
        }
        [prefs setObject:tooltipValid forKey:@"Tooltip_Valid"];
        [prefs synchronize];
    }
}

+ (void)setLastDateShowed:(NSString *)tooltipKey {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:[NSDate date] forKey:tooltipKey];
    [prefs synchronize];
}

+ (void)setShowed:(NSString *)tooltipKey {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:YES forKey:tooltipKey];
    [prefs synchronize];
}

+ (void)resetAllTooltip {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs removeObjectForKey:@"Tooltip_LoadEvent_LastDateShowed"];
    [prefs removeObjectForKey:@"Tooltip_SocialTab_LastDateShowed"];
    [prefs removeObjectForKey:@"Tooltip_LikeEvent_LastDateShowed"];
    [prefs removeObjectForKey:@"Tooltip_ShareEvent_LastDateShowed"];
    [prefs removeObjectForKey:@"Tooltip_AcceptSuggestion_LastDateShowed"];
    [prefs removeObjectForKey:@"Tooltip_AcceptRequest_LastDateShowed"];
    [prefs removeObjectForKey:@"Tooltip_Valid"];
    
    [prefs setBool:NO forKey:@"Tooltip_LoadEvent_isShowed"];
    [prefs setBool:NO forKey:@"Tooltip_SocialTab_isShowed"];
    [prefs setBool:NO forKey:@"Tooltip_LikeEvent_isShowed"];
    [prefs setBool:NO forKey:@"Tooltip_ShareEvent_isShowed"];
    [prefs setBool:NO forKey:@"Tooltip_AcceptSuggestion_isShowed"];
    [prefs setBool:NO forKey:@"Tooltip_AcceptRequest_isShowed"];
    
    [prefs synchronize];
}

@end
