//
//  UIFont+PH.h
//  PartyHost
//
//  Created by Tony Suriyathep on 7/6/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (PH)

+ (UIFont *)phBold:(CGFloat)size;
+ (UIFont *)phThin:(CGFloat)size;
+ (UIFont *)phBlond:(CGFloat)size;

+ (UIFont *)latoThin:(CGFloat)size;
+ (UIFont *)latoBold:(CGFloat)size;
+ (UIFont *)latoBlond:(CGFloat)size;

/*
//Replace system fonts
//http://stackoverflow.com/questions/8707082/set-a-default-font-for-whole-ios-app
+ (UIFont *)boldSystemFontOfSize:(CGFloat)fontSize;
+ (UIFont *)systemFontOfSize:(CGFloat)fontSize;
*/

@end
