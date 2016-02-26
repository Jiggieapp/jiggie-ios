//
//  BadgeView.m
//  PartyHost
//
//  Created by Tony Suriyathep on 6/10/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "BadgeView.h"

@implementation BadgeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.userInteractionEnabled = false;
        self.value = -99999;
        self.text = @"";
        self.canShow = YES;
        int size = MIN(frame.size.width,frame.size.height);
        self.contentView = [[UIButton alloc] init];
        self.contentView.frame = CGRectMake(0,0,frame.size.width,frame.size.height);
        self.contentView.backgroundColor = [UIColor redColor];
        self.contentView.titleLabel.font = [UIFont phBold:size * 0.60];
        self.contentView.layer.cornerRadius = size/2;
        self.contentView.enabled = NO;
        self.contentView.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.contentView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView setTitle:@"" forState:UIControlStateNormal];
        [self addSubview:self.contentView];
    }
    return self;
}

//Values 0 = Dot, 1-99 = Number, >=100 = Shows Exclamation
-(void)updateValue:(int)newValue
{
    //Same
    //if(self.value == newValue) return;
    
    //Change it
    if(newValue <= 0) {
        self.hidden = YES;
    }
    else
    {
        if(self.canShow)
        {
            self.hidden = NO;
        }
        if(newValue <= 99) { //Up to 99
            [self.contentView setTitle:[NSString stringWithFormat:@"%i",newValue] forState:UIControlStateNormal];
        }
        else { //Too many
            [self.contentView setTitle:@"99" forState:UIControlStateNormal];
        }
    }
    self.contentView.hidden = self.hidden;
    
    self.value = newValue;
}

@end
