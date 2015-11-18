//
//  UIFont+PH.m
//  PartyHost
//
//  Created by Tony Suriyathep on 7/6/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "UIFont+PH.h"
#import <CoreText/CoreText.h>
#import "NSString+Icons.h"

@implementation UIFont (PH)

+ (UIFont *)phThin:(CGFloat)size {
    //return [UIFont fontWithName:@"FaktPro-Thin" size:size];
    return [UIFont fontWithName:@"Calibre-Light" size:size];
//    return [UIFont fontWithName:@"Lato-Light" size:size];
}

+ (UIFont *)phBold:(CGFloat)size {
    //return [UIFont fontWithName:@"Calibre-Regular" size:size];
    //return [UIFont fontWithName:@"FaktPro-Blond" size:size];
    //return [UIFont fontWithName:@"FaktPro-SemiBold" size:size];
    //return [UIFont fontWithName:@"Calibre-Regular" size:size];
    return [UIFont fontWithName:@"Calibre-Semibold" size:size];
//    return [UIFont fontWithName:@"Lato-Bold" size:size];
}

+ (UIFont *)phBlond:(CGFloat)size {
    //return [UIFont fontWithName:@"Calibre Bold" size:size];
    //return [UIFont fontWithName:@"FaktPro-Blond" size:size];
    return [UIFont fontWithName:@"Calibre-Regular" size:size];
//    return [UIFont fontWithName:@"Lato-Regular" size:size];
}

+ (UIFont *)latoThin:(CGFloat)size {
    return [UIFont fontWithName:@"Lato-Light" size:size];
}

+ (UIFont *)latoBold:(CGFloat)size {
    return [UIFont fontWithName:@"Lato-Bold" size:size];
}

+ (UIFont *)latoBlond:(CGFloat)size {
    return [UIFont fontWithName:@"Lato-Regular" size:size];
}

/*
+ (UIFont *)boldSystemFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"FaktPro-SemiBold" size:fontSize];
}

+ (UIFont *)systemFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"FaktPro-Blond" size:fontSize];
}
*/

@end
