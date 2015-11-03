//
//  BadgeView.h
//  PartyHost
//
//  Created by Tony Suriyathep on 6/10/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BadgeView : UIView

@property(nonatomic,assign) int value;
@property(nonatomic,strong) NSString *text;
@property(nonatomic,strong) UITextField *textField;
@property(nonatomic,assign) BOOL canShow;


//Values 0 = Dot, 1-99 = Number, >=100 = Shows Exclamation
-(void)updateValue:(int)newValue;

@end
