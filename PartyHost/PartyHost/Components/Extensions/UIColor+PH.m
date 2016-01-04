//
//  UIColor+FlatUI.m
//  FlatUI
//
//  Created by Jack Flintermann on 5/3/13.
//  Copyright (c) 2013 Jack Flintermann. All rights reserved.
//

#import "UIColor+PH.h"

@implementation UIColor (PH)

+ (UIColor *) phGoldColor {
    static UIColor *phGold = nil;
    static dispatch_once_t dispatchToken;
    dispatch_once(&dispatchToken, ^{phGold = [UIColor colorFromHexCode:@"c79d2d"];});
    return phGold;
}

+ (UIColor *) phCyanColor {
    static UIColor *phCyan = nil;
    static dispatch_once_t dispatchToken;
    dispatch_once(&dispatchToken, ^{phCyan = [UIColor colorFromHexCode:@"50e3c2"];});
    return phCyan;
}

+ (UIColor *) phGreenColor {
    static UIColor *phGreen = nil;
    static dispatch_once_t dispatchToken;
    dispatch_once(&dispatchToken, ^{phGreen = [UIColor colorFromHexCode:@"7ED321"];});
    return phGreen;
}


+ (UIColor *) phLightGrayColor {
    static UIColor *phGreen = nil;
    static dispatch_once_t dispatchToken;
    dispatch_once(&dispatchToken, ^{phGreen = [UIColor colorFromHexCode:@"DBDBDB"];});
    return phGreen;
}


+ (UIColor *) phLightSilverColor {
    static UIColor *phGreen = nil;
    static dispatch_once_t dispatchToken;
    dispatch_once(&dispatchToken, ^{phGreen = [UIColor colorFromHexCode:@"F0F0F0"];});
    return phGreen;
}

+ (UIColor *) phGrayColor {
    static UIColor *phGreen = nil;
    static dispatch_once_t dispatchToken;
    dispatch_once(&dispatchToken, ^{phGreen = [UIColor colorFromHexCode:@"C2C2C2"];});
    return phGreen;
}

+ (UIColor *) phDarkGrayColor {
    static UIColor *phGreen = nil;
    static dispatch_once_t dispatchToken;
    dispatch_once(&dispatchToken, ^{phGreen = [UIColor colorFromHexCode:@"939393"];});
    return phGreen;
}

+ (UIColor *) phPurpleColor {
    static UIColor *phPurple = nil;
    static dispatch_once_t dispatchToken;
    dispatch_once(&dispatchToken, ^{phPurple = [UIColor colorFromHexCode:@"A32ECF"];});
    return phPurple;
}

+ (UIColor *) phBlueColor {
    static UIColor *phBlue = nil;
    static dispatch_once_t dispatchToken;
    dispatch_once(&dispatchToken, ^{phBlue = [UIColor colorFromHexCode:@"10BBFF"];});
    return phBlue;
}

+ (UIColor *) phNavyColor {
    static UIColor *phBlue = nil;
    static dispatch_once_t dispatchToken;
    dispatch_once(&dispatchToken, ^{phBlue = [UIColor colorFromHexCode:@"7C4DFF"];});
    return phBlue;
}

+ (UIColor *) phLightTitleColor {
    static UIColor *phDarkTitle = nil;
    static dispatch_once_t dispatchToken;
    dispatch_once(&dispatchToken, ^{phDarkTitle = [UIColor colorFromHexCode:@"404040"];});
    return phDarkTitle;
}

+ (UIColor *) phDarkTitleColor {
    static UIColor *phDarkTitle = nil;
    static dispatch_once_t dispatchToken;
    dispatch_once(&dispatchToken, ^{phDarkTitle = [UIColor colorFromHexCode:@"939393"];});
    //dispatch_once(&dispatchToken, ^{phDarkTitle = [UIColor colorFromHexCode:@"A32ECF"];});
    return phDarkTitle;
}

+ (UIColor *) phDarkBodyColor {
    static UIColor *phDarkBody = nil;
    static dispatch_once_t dispatchToken;
    dispatch_once(&dispatchToken, ^{phDarkBody = [UIColor colorFromHexCode:@"141414"];});
    return phDarkBody;
}

+ (UIColor *) phDarkBodyInactiveColor {
    static UIColor *phDarkBodyInactive = nil;
    static dispatch_once_t dispatchToken;
    dispatch_once(&dispatchToken, ^{phDarkBodyInactive = [UIColor colorFromHexCode:@"242424"];});
    return phDarkBodyInactive;
}

@end
