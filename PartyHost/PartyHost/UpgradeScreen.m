//
//  UpgradeScreen.m
//  PartyHost
//
//  Created by Sunny Clark on 4/27/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "UpgradeScreen.h"

@implementation UpgradeScreen

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    
    self.sharedData = [SharedData sharedInstance];
    
    UIView *tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 60)];
    tabBar.backgroundColor = [UIColor phLightTitleColor];
    [self addSubview:tabBar];
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, frame.size.width, 40)];
    title.text = @"Jiggie Upgrade";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont phBold:18];
    [tabBar addSubview:title];
    
    
    
    UITextView *upgradeTxt = [[UITextView alloc] initWithFrame:CGRectMake(20, 140, self.sharedData.screenWidth - 40, 200)];
    upgradeTxt.text = @"There is a new version of \nJiggie!\n Please tap below to upgrade!";
    upgradeTxt.textAlignment = NSTextAlignmentCenter;
    upgradeTxt.font = [UIFont phBlond:18];
    [self addSubview:upgradeTxt];
    
    
    UIButton *btnUpgrade = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnUpgrade.frame = CGRectMake(20, 400, self.sharedData.screenWidth - 40, 50);
    //btnUpgrade.titleEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
    [btnUpgrade setTitle:@"Upgrade" forState:UIControlStateNormal];
    btnUpgrade.titleLabel.font  = [UIFont phBlond:20];
    [btnUpgrade setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnUpgrade addTarget:self action:@selector(btnTapHandler) forControlEvents:UIControlEventTouchUpInside];
    btnUpgrade.layer.masksToBounds = YES;
    btnUpgrade.layer.cornerRadius = 10.0;
    btnUpgrade.backgroundColor = [UIColor phPurpleColor];
    btnUpgrade.titleEdgeInsets = UIEdgeInsetsMake(4, 0, 0, 0);
    //btnUpgrade.hidden = YES;
    //btnUpgrade.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self addSubview:btnUpgrade];
    
    
    
    
    
    return self;
}


-(void)btnTapHandler
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/jiggie-social-event-discovery/id1047291489"]];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
