//
//  SelectionCheckmark.h
//  PartyHost
//
//  Created by Tony Suriyathep on 7/16/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectionCheckmark : UIButton

@property (strong, nonatomic) UIImageView *checkmark;
@property (assign, nonatomic) BOOL isSelected;
@property (strong, nonatomic) UIColor *innerColor;
@property (strong, nonatomic) UIColor *inactiveColor;

-(void)buttonSelect:(BOOL)selected animated:(BOOL)animated;

@end
