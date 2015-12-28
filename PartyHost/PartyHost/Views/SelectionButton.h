//
//  PHSelectionButton.h
//  PartyHost
//
//  Created by Tony Suriyathep on 7/2/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectionButton : UIView

@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UIImageView *checkmark;
@property (assign, nonatomic) BOOL isSelected;

@property (strong, nonatomic) UIColor *offBackgroundColor;
@property (strong, nonatomic) UIColor *offBorderColor;
@property (strong, nonatomic) UIColor *offTextColor;
@property (strong, nonatomic) UIColor *onBackgroundColor;
@property (strong, nonatomic) UIColor *onBorderColor;
@property (strong, nonatomic) UIColor *onTextColor;

-(void)buttonSelect:(BOOL)selected checkmark:(BOOL)checkmark animated:(BOOL)animated;

@end
