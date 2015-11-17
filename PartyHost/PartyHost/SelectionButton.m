//
//  PHSelectionButton.m
//  PartyHost
//
//  Created by Tony Suriyathep on 7/2/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "SelectionButton.h"

@implementation SelectionButton

-(void)baseInit {
    self.backgroundColor = [UIColor clearColor];
    self.offBackgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
    self.offBorderColor = [UIColor clearColor];
    self.offTextColor = [UIColor phPurpleColor];
    self.onBackgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
    self.onBorderColor = [UIColor phPurpleColor];
    self.onTextColor = [UIColor whiteColor];
    
    //Button
    self.button = [[UIButton alloc] init];
    self.button.backgroundColor = self.offBackgroundColor;
    self.button.layer.masksToBounds = YES;
    self.button.layer.borderColor = self.offBorderColor.CGColor;
    self.button.layer.borderWidth = 1.5;
    [self.button setTitleColor:self.offTextColor forState:UIControlStateNormal];
    self.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.button setTitleEdgeInsets:UIEdgeInsetsMake(10,6,4,6)];
    self.button.titleLabel.font = [UIFont phBold:14];
    [self.button setTitle:@"BUTTON" forState:UIControlStateNormal];
    [self addSubview:self.button];
    
    //Checkmark
    self.checkmark = [[UIImageView alloc] init];
    self.checkmark.contentMode = UIViewContentModeScaleAspectFit;
    self.checkmark.image = [UIImage imageNamed:@"ButtonCheck"];
    self.checkmark.alpha = 0;
    [self addSubview:self.checkmark];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
        
        [self layoutIfNeeded];
        [self buttonSelect:NO animated:NO];
    }
    return self;
}

-(void)buttonSelect:(BOOL)selected animated:(BOOL)animated {
    self.isSelected = selected;
    
    if(selected) {
        if(!animated) {
            [self.button.layer removeAllAnimations];
            [self.button setTitleEdgeInsets:UIEdgeInsetsMake(6,6,4,20)];
            [self.button layoutIfNeeded];
            [self.button setTitleColor:self.onTextColor forState:UIControlStateNormal];
            self.button.layer.borderColor = self.onBorderColor.CGColor;
            self.button.backgroundColor = self.onBackgroundColor;
            [self.checkmark.layer removeAllAnimations];
            self.checkmark.alpha = 1.0;
            self.checkmark.transform = CGAffineTransformMakeScale(1.0,1.0);
            [self.checkmark layoutIfNeeded];
        }
        else {
            self.checkmark.transform = CGAffineTransformMakeScale(1.0,1.0);
            [self layoutIfNeeded];
            self.checkmark.alpha = 0;
            self.checkmark.transform = CGAffineTransformMakeScale(1.5,1.5);
            [UIView animateWithDuration:0.35f delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
                self.button.titleEdgeInsets = UIEdgeInsetsMake(6,6,4,20);
                [self.button setTitleColor:self.onTextColor forState:UIControlStateNormal];
                self.button.layer.borderColor = self.onBorderColor.CGColor;
                self.button.backgroundColor = self.onBackgroundColor;
                [self.button layoutIfNeeded];
                self.checkmark.alpha = 1.0;
                self.checkmark.transform = CGAffineTransformMakeScale(1.0,1.0);
                [self.checkmark layoutIfNeeded];
            } completion:^(BOOL finished) {
            }];
        }
    }
    else {
        if(!animated) {
            [self.button.layer removeAllAnimations];
            [self.button setTitleEdgeInsets:UIEdgeInsetsMake(6,6,4,6)];
            [self.button setTitleColor:self.offTextColor forState:UIControlStateNormal];
            self.button.layer.borderColor = self.offBorderColor.CGColor;
            self.button.backgroundColor = self.offBackgroundColor;
            [self.checkmark.layer removeAllAnimations];
            self.checkmark.alpha = 0.0;
            self.checkmark.transform = CGAffineTransformMakeScale(1.0,1.0);
            [self layoutIfNeeded];
        }
        else {
            self.checkmark.transform = CGAffineTransformMakeScale(1.0,1.0);
            [self layoutIfNeeded];
            [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
                self.button.titleEdgeInsets = UIEdgeInsetsMake(6,6,4,6);
                [self.button setTitleColor:self.offTextColor forState:UIControlStateNormal];
                self.button.layer.borderColor = self.offBorderColor.CGColor;
                self.button.backgroundColor = self.offBackgroundColor;
                self.checkmark.alpha = 0.0;
                self.checkmark.transform = CGAffineTransformMakeScale(0.5,0.5);
                [self layoutIfNeeded];
            } completion:^(BOOL finished) {
            }];
        }
    }
}

//NEEDED!!
-(void)layoutSubviews {
    [super layoutSubviews];
    [self layoutButton];
    [self layoutCheckmark];
}

-(void)layoutButton {
    self.button.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
    self.button.layer.cornerRadius = (self.frame.size.height/2)-1;
}

//Layout checkmark, it will be based on the string
-(void)layoutCheckmark {
    NSString *title = self.button.titleLabel.text;
    NSDictionary *fontDict = @{NSFontAttributeName:self.button.titleLabel.font};
    CGSize stringSize = [title sizeWithAttributes:fontDict];
    CGFloat checkmarkHeight = stringSize.height * 0.85;
    self.checkmark.frame = CGRectMake(self.frame.size.width/2 + stringSize.width/2 - 2,self.frame.size.height/2 - checkmarkHeight/2,checkmarkHeight,checkmarkHeight);
}

@end
