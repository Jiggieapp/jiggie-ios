//
//  UIView+Animation.m
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 5/10/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "UIView+Animation.h"
#import "AppDelegate.h"

@implementation UIView (Animation)

- (void)presentView:(UIView *)view withOverlay:(BOOL)overlay animated:(BOOL)animated completion:(void (^)(void))completion {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIView *overlayView = [[UIView alloc] initWithFrame:window.bounds];
    overlayView.tag = 101;
    overlayView.backgroundColor = [UIColor colorWithWhite:.0f alpha:0.8f];
    
    if (overlay) {
        [window addSubview:overlayView];
    } else {
        [window addSubview:view];
    }
    
    if (animated) {
        view.center = CGPointMake(window.center.x, CGRectGetHeight(window.bounds) + 10);
        
        if (overlay) {
            [overlayView addSubview:view];
        }
        
        [UIView animateWithDuration:.7f
                              delay:.0f
             usingSpringWithDamping:.7f
              initialSpringVelocity:.3f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             view.center = overlayView.center;
                         }
                         completion:^(BOOL finished) {
                             if (completion) {
                                 completion();
                             }
                         }];
    } else {
        if (overlay) {
            [overlayView addSubview:view];
        }
        
        view.center = overlayView.center;
        
        if (completion) {
            completion();
        }
    }
}

- (void)dismissViewAnimated:(BOOL)animated completion:(void (^)(void))completion {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIView *overlayView = window.subviews.lastObject;
    UIView *snapshotView = [self snapshotViewAfterScreenUpdates:YES];
    
    CGRect frame = snapshotView.frame;
    frame.origin.x = CGRectGetMinX(self.frame);
    frame.origin.y = CGRectGetMinY(self.frame);
    snapshotView.frame = frame;
    
    [self removeFromSuperview];
    
    if (overlayView.tag == 101) {
        [overlayView addSubview:snapshotView];
    } else {
        if (window.rootViewController.presentedViewController) {
            [window addSubview:snapshotView];
        }
    }
    
    if (animated) {
        snapshotView.center = CGPointMake(window.center.x, CGRectGetHeight(window.bounds));
        
        if (overlayView.tag == 101) {
            [overlayView addSubview:snapshotView];
        }
        
        [UIView animateWithDuration:.7f
                              delay:.0f
             usingSpringWithDamping:1.0f
              initialSpringVelocity:.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             CGRect frame = snapshotView.frame;
                             frame.origin.y = CGRectGetHeight(window.bounds) + 10;
                             snapshotView.frame = frame;
                         }
                         completion:^(BOOL finished) {
                             [snapshotView removeFromSuperview];
                             
                             if (overlayView.tag == 101) {
                                 [overlayView removeFromSuperview];
                             }
                             
                             if (completion) {
                                 completion();
                             }
                         }];
    } else {
        [snapshotView removeFromSuperview];
        
        if (overlayView.tag == 101) {
            [overlayView removeFromSuperview];
        }
        
        if (completion) {
            completion();
        }
    }
}

@end
