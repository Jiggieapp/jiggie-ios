//
//  JGTooltipHelper.h
//  Jiggie
//
//  Created by Setiady Wiguna on 5/5/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGTooltipHelper : NSObject

+ (BOOL)isLoadEventTooltipValid;
+ (BOOL)isSocialTabTooltipValidAfter:(NSString *)tooltipKey;
+ (BOOL)isLikeEventTooltipValid;
+ (BOOL)isGroupChatEventTooltipValid;
+ (BOOL)isShareEventTooltipValid;
+ (BOOL)isAcceptSuggestionTooltipValid;
+ (BOOL)isAcceptRequestTooltipValid;
+ (BOOL)isAllTooltipValid;

+ (void)setUpTooltip;
+ (BOOL)hasTooltipAlreadyPassADay:(NSString *)tooltipKey;
+ (void)setLastDateShowed:(NSString *)tooltipKey;
+ (void)setShowed:(NSString *)tooltipKey;
+ (void)resetAllTooltip;

@end
