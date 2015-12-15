//
//  OverlayView.h
//  PartyHost
//
//  Created by Tony Suriyathep on 8/8/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "GenericOverlayView.h"
#import <UIKit/UIKit.h>

@interface OverlayView : UIView

@property (strong, nonatomic) SharedData *sharedData;
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) GenericOverlayView *overlayView;
@property (strong, nonatomic) UIView *dotView;
@property (strong, nonatomic) UITapGestureRecognizer *tap;
@property (assign, nonatomic) CGFloat targetX, targetY;

-(void)popup:(NSString*)title subtitle:(NSString*)subtitle x:(CGFloat)x y:(CGFloat)y;
-(void)popout;
-(void)resetFrame;

@end
