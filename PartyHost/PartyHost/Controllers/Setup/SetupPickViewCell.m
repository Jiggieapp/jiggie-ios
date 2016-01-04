//
//  SetupPickViewCell.m
//  PartyHost
//
//  Created by Tony Suriyathep on 7/1/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "SetupPickViewCell.h"

@implementation SetupPickViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor redColor];
        self.button = [[SelectionButton alloc] initWithFrame:self.bounds];
        self.button.userInteractionEnabled = NO;
        [self addSubview:self.button];
    }
    
    return self;
}

//NEEDED!!
-(void)layoutIfNeeded {
    [super layoutIfNeeded];
    
    [self.button setFrame:self.bounds];
    [self.button layoutIfNeeded];
    [self.button setNeedsLayout];
}

@end
