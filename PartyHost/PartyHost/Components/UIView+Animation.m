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

- (void)presentView:(UIView *)view animated:(BOOL)animated completion:(void (^)(void))completion {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIView *overlayView = [[UIView alloc] initWithFrame:window.bounds];
    overlayView.backgroundColor = [UIColor colorWithWhite:.0f alpha:0.8f];
    
    [window.rootViewController.view addSubview:overlayView];
    
    if (animated) {
        view.center = CGPointMake(window.center.x, CGRectGetHeight(window.bounds));
        [overlayView addSubview:view];
        
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
        [overlayView addSubview:view];
        
        view.center = overlayView.center;
        
        if (completion) {
            completion();
        }
    }
}

- (void)dismissViewAnimated:(BOOL)animated completion:(void (^)(void))completion {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIView *overlayView = window.rootViewController.view.subviews.lastObject;
    UIView *snapshotView = [self snapshotViewAfterScreenUpdates:YES];
    
    CGRect frame = snapshotView.frame;
    frame.origin.x = CGRectGetMinX(self.frame);
    frame.origin.y = CGRectGetMinY(self.frame);
    snapshotView.frame = frame;
    
    [self removeFromSuperview];
    [overlayView addSubview:snapshotView];
    
    if (animated) {
        snapshotView.center = CGPointMake(window.center.x, CGRectGetHeight(window.bounds));
        [overlayView addSubview:snapshotView];
        
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
                             [overlayView removeFromSuperview];
                             
                             if (completion) {
                                 completion();
                             }
                         }];
    } else {
        [snapshotView removeFromSuperview];
        [overlayView removeFromSuperview];
        
        if (completion) {
            completion();
        }
    }
}

@end
