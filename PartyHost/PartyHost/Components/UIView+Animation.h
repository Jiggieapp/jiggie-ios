//
//  UIView+Animation.h
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 5/10/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Animation)

- (void)presentView:(UIView *)view withOverlay:(BOOL)overlay
           animated:(BOOL)animated
         completion:(void (^)(void))completion;

- (void)dismissViewAnimated:(BOOL)animated completion:(void (^)(void))completion;

@end
