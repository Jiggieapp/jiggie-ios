//
//  PopupView.m
//  PartyHost
//
//  Created by Tony Suriyathep on 7/7/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "PopupView.h"

@implementation PopupView

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
    }
    return self;
}

-(void)popup:(NSString*)nib animated:(BOOL)animated
{
    if(self.hidden==NO) [self popout:NO];
    
    self.popupView = [[[NSBundle mainBundle] loadNibNamed:nib owner:self options:nil] objectAtIndex:0];
    [self resetFrame];
    
    if(!animated)
    {
        [self addSubview:self.popupView];
        return;
    }
    
    //Init
    self.popupView.alpha = 0;
    [self addSubview:self.popupView];
    self.hidden = NO;
    
    //Fade background between pages
    self.popupView.transform = CGAffineTransformMakeScale(1.25,1.25);
    [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveEaseOut |  UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.popupView.transform = CGAffineTransformMakeScale(1.0,1.0);
        self.popupView.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

-(void)resetFrame
{
    int w = self.sharedData.screenWidth * 0.85;
    int h = self.sharedData.screenHeight * 0.65;
    self.popupView.frame = CGRectMake(self.sharedData.screenWidth/2 - w/2,self.sharedData.screenHeight/2 - h/2,w,h);
}

-(void)popout:(BOOL)animated
{
    if(self.popupView==nil) return;
    
    if(!animated)
    {
        [self.popupView removeFromSuperview];
        self.popupView = nil;
        self.hidden = YES;
        return;
    }
    
    [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveEaseIn |  UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.popupView.transform = CGAffineTransformMakeScale(1.25,1.25);
        self.popupView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.popupView removeFromSuperview];
        self.popupView = nil;
        self.hidden = YES;
    }];
}

@end



