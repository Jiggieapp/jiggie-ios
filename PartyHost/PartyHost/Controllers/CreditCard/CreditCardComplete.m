//
//  CreditCardComplete.m
//  PartyHost
//
//  Created by Tony Suriyathep on 7/30/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "CreditCardComplete.h"

@implementation CreditCardComplete


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor phDarkBodyColor];
    
    self.sharedData = [SharedData sharedInstance];
    
    UIView *tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 60)];
    tabBar.backgroundColor = [UIColor clearColor];
    [self addSubview:tabBar];
    
    int h = 64+8+32+16+16 + (64*2) + 16 + 24;
    UIView *centerText = [[UIView alloc] initWithFrame:CGRectMake(0, 50 - 16 + ((self.sharedData.screenHeight-PHButtonHeight-50)/2)-(h/2), self.sharedData.screenWidth, h)];
    centerText.backgroundColor = [UIColor clearColor];
    [self addSubview:centerText];
    
    self.check1 = [[SelectionCheckmark alloc] initWithFrame:CGRectMake((self.sharedData.screenWidth-64)/2, 0, 64, 64)];
    self.check1.userInteractionEnabled = NO;
    self.check1.layer.borderWidth = 2;
    self.check1.innerColor = [UIColor phCyanColor];
    [centerText addSubview:self.check1];
    
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, 64+16, self.sharedData.screenWidth, 32)];
    self.title.text = @"Your credit card is added!";
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.adjustsFontSizeToFitWidth = YES;
    self.title.textColor = [UIColor whiteColor];
    self.title.font = [UIFont phBlond:20];
    [centerText addSubview:self.title];
    
    UIView *bar1 = [[UIView alloc] initWithFrame:CGRectMake(-2, self.title.frame.origin.y + self.title.frame.size.height + 24, self.sharedData.screenWidth+4, 64)];
    bar1.backgroundColor = [UIColor colorFromHexCode:@"141414"];
    bar1.layer.borderColor = [UIColor colorFromHexCode:@"202020"].CGColor;
    bar1.layer.borderWidth = 1.0;
    [centerText addSubview:bar1];
    
    self.ccNumber = [[UILabel alloc] initWithFrame:bar1.bounds];
    self.ccNumber.text = @"";
    self.ccNumber.textAlignment = NSTextAlignmentCenter;
    self.ccNumber.textColor = [UIColor whiteColor];
    self.ccNumber.font = [UIFont phBlond:19];
    [bar1 addSubview:self.ccNumber];
    
    self.subtitle = [[UILabel alloc] initWithFrame:CGRectMake(0, bar1.frame.origin.y + bar1.frame.size.height + 16, self.sharedData.screenWidth, 16)];
    self.subtitle.text = @"You're credit is added ... all good!";
    self.subtitle.textAlignment = NSTextAlignmentCenter;
    self.subtitle.adjustsFontSizeToFitWidth = YES;
    self.subtitle.textColor = [UIColor colorWithWhite:1 alpha:0.50];
    self.subtitle.font = [UIFont phBlond:14];
    [centerText addSubview:self.subtitle];
    
    //Create big HOST HERE button
    self.btnContinue = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.btnContinue.frame = CGRectMake(0, self.sharedData.screenHeight - PHButtonHeight, self.sharedData.screenWidth, PHButtonHeight);
    self.btnContinue.titleLabel.font = [UIFont phBold:16];
    [self.btnContinue setTitleEdgeInsets:UIEdgeInsetsMake(3,0,0,0)];
    [self.btnContinue setTitle:@"CONTINUE" forState:UIControlStateNormal];
    [self.btnContinue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnContinue setBackgroundColor:[UIColor phCyanColor]];
    [self.btnContinue addTarget:self action:@selector(btnContinueClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnContinue];
    
    return self;
}

-(void)initClass
{
    self.sharedData.has_phone = YES;
    self.ccNumber.text = [NSString stringWithFormat:@"•••• %@",self.sharedData.ccLast4];
    [self.check1 buttonSelect:NO animated:NO];
}

-(void)btnContinueClicked
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"EXIT_CREDIT_CARD"
     object:self];
}

@end
