//
//  OverlayView.m
//  PartyHost
//
//  Created by Tony Suriyathep on 8/8/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "OverlayView.h"

#define DOT_SIZE 64

@implementation OverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.hidden = YES;
    if (self)
    {
        self.sharedData = [SharedData sharedInstance];
        
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.sharedData.screenWidth,self.sharedData.screenHeight)];
        self.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
        [self addSubview:self.backgroundView];
        
        self.dotView = [[UIView alloc] init];
        
        UIView *dot = [[UIView alloc] initWithFrame:CGRectMake(0,0,DOT_SIZE,DOT_SIZE)];
        dot.backgroundColor = [UIColor colorWithWhite:1 alpha:0.85];
        dot.layer.masksToBounds = YES;
        dot.layer.cornerRadius = DOT_SIZE/2;
        [self.dotView addSubview:dot];

        [self addSubview:self.dotView];
        
        self.overlayView = [[[NSBundle mainBundle] loadNibNamed:@"GenericOverlay" owner:self options:nil] objectAtIndex:0];
        
        self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popoutAnimated)];
        self.tap.cancelsTouchesInView = YES;
    }
    return self;
}

-(void)popoutAnimated
{
    [self popout];
}

-(void)popup:(NSString*)title subtitle:(NSString*)subtitle x:(CGFloat)x y:(CGFloat)y
{
    if(self.hidden==NO) [self popout];
    
    //Default middle of screen
    if(x==0) x = self.sharedData.screenWidth/2;
    if(y==0) y = self.sharedData.screenHeight/2;
    self.targetX = x;
    self.targetY = y;
    
    [self removeGestureRecognizer:self.tap];
    
    self.overlayView.title.text = title;
    self.overlayView.subtitle.text = subtitle;
    [self resetFrame];
    
    //Init
    self.dotView.alpha = 0;
    self.overlayView.alpha = 0;
    [self addSubview:self.overlayView];
    self.hidden = NO;
    
    //Fade background between pages
    [UIView animateWithDuration:0.50f delay:0 options:UIViewAnimationOptionCurveEaseOut |  UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.dotView.alpha = 1;
        self.overlayView.alpha = 1;
        self.overlayView.frame = CGRectMake(0,0,self.sharedData.screenWidth,self.sharedData.screenHeight);
    } completion:^(BOOL finished) {
        [self performSelector:@selector(moveDot) withObject:self afterDelay:0.50];
    }];
}

-(void)moveDot
{
    //Move to specific spot
    [UIView animateWithDuration:0.50f delay:0 options:UIViewAnimationOptionCurveEaseOut |  UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        self.dotView.frame = CGRectMake(self.targetX - DOT_SIZE/2,self.targetY - DOT_SIZE/2,DOT_SIZE,DOT_SIZE);
        
    } completion:^(BOOL finished) {
        
        //Pulsate dot
        CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        pulseAnimation.duration = .5;
        pulseAnimation.toValue = [NSNumber numberWithFloat:1.1];
        pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pulseAnimation.autoreverses = YES;
        pulseAnimation.repeatCount = MAXFLOAT;
        [self.dotView.layer addAnimation:pulseAnimation forKey:@"a"];
        
        //Listen for any touch to close
        [self addGestureRecognizer:self.tap];
    }];
}

-(void)resetFrame
{
    int w = self.sharedData.screenWidth;
    int h = self.sharedData.screenHeight;
    self.overlayView.frame = CGRectMake(0,100,w,h);
    self.dotView.frame = CGRectMake((w/2)-(DOT_SIZE/2),h+100,DOT_SIZE,DOT_SIZE);
}

-(void)popout
{
    if(self.overlayView==nil) return;
    
    [self removeGestureRecognizer:self.tap];
    
    [UIView animateWithDuration:0.35f delay:0 options:UIViewAnimationOptionCurveEaseIn |  UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.dotView.alpha = 0;
        self.overlayView.alpha = 0;
        self.overlayView.frame = CGRectMake(0,100,self.sharedData.screenWidth,self.sharedData.screenHeight);
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self.dotView.layer removeAllAnimations];
    }];
}

@end
