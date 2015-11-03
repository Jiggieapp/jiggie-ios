//
//  SelectionCheckmark.m
//  PartyHost
//
//  Created by Tony Suriyathep on 7/16/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "SelectionCheckmark.h"

@implementation SelectionCheckmark

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.innerColor = [UIColor phGreenColor];
        self.backgroundColor = self.innerColor;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = frame.size.height/2;
        self.layer.borderWidth = 1;
        self.inactiveColor = [UIColor lightGrayColor];
        self.layer.borderColor = self.inactiveColor.CGColor;
        
        self.checkmark = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.height/4, frame.size.height/4, frame.size.height - frame.size.height/2, frame.size.height - frame.size.height/2)];
        self.checkmark.contentMode = UIViewContentModeScaleAspectFit;
        self.checkmark.image = [UIImage imageNamed:@"big_checkmark"];
        self.checkmark.alpha = 0;
        [self addSubview:self.checkmark];
        
        [self buttonSelect:NO animated:NO];
    }
    return self;
}

-(void)buttonSelect:(BOOL)selected animated:(BOOL)animated {
    self.isSelected = selected;
    
    if(selected) {
        if(!animated) {
            [self.layer removeAllAnimations];
            self.layer.borderColor = [UIColor clearColor].CGColor;
            self.backgroundColor = self.innerColor;
            self.checkmark.alpha = 1.0;
        }
        else {
            self.layer.borderColor = self.inactiveColor.CGColor;
            self.backgroundColor = [UIColor clearColor];
            self.checkmark.alpha = 0;
            self.checkmark.transform = CGAffineTransformMakeScale(1.5,1.5);
            [UIView animateWithDuration:0.35f delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
                [self.layer removeAllAnimations];
                self.layer.borderColor = [UIColor clearColor].CGColor;
                self.backgroundColor = self.innerColor;
                [self.checkmark.layer removeAllAnimations];
                self.checkmark.alpha = 1.0;
                self.checkmark.transform = CGAffineTransformMakeScale(1.0,1.0);
            } completion:^(BOOL finished) {
            }];
        }
    }
    else {
        if(!animated) {
            [self.layer removeAllAnimations];
            self.layer.borderColor = self.inactiveColor.CGColor;
            self.backgroundColor = [UIColor clearColor];
            [self.checkmark.layer removeAllAnimations];
            [self setImage:[[UIImage alloc] init] forState:UIControlStateSelected];
            self.checkmark.transform = CGAffineTransformMakeScale(1.0,1.0);
            self.checkmark.alpha = 0.0;
        }
        else {
            [self.checkmark.layer removeAllAnimations];
            self.transform = CGAffineTransformMakeScale(1.0,1.0);
            [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
                self.layer.borderColor = self.inactiveColor.CGColor;
                self.backgroundColor = [UIColor clearColor];
                self.checkmark.transform = CGAffineTransformMakeScale(0.5,0.5);
                self.checkmark.alpha = 0.0;
            } completion:^(BOOL finished) {
            }];
        }
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
