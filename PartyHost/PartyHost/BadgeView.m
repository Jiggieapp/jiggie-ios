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
        self.textField = [[UITextField alloc] init];
        self.textField.frame = CGRectMake(0,0,frame.size.width,frame.size.height);
        self.textField.backgroundColor = [UIColor redColor];
        self.textField.font = [UIFont phBold:size * 0.60];
        self.textField.textColor = [UIColor whiteColor];
        self.textField.text = @"";
        self.textField.textAlignment = NSTextAlignmentCenter;
        self.textField.layer.cornerRadius = size/2;
        
        [self addSubview:self.textField];
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
            self.textField.text = [NSString stringWithFormat:@"%i",newValue];
        }
        else { //Too many
            self.textField.text = @"!";
        }
    }
    self.textField.hidden = self.hidden;
    
    self.value = newValue;
}

@end
