//
//  BookTableComplete.m
//  PartyHost
//
//  Created by Tony Suriyathep on 7/15/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "BookTable.h"
#import "AnalyticManager.h"
#import "BookTableComplete.h"

@implementation BookTableComplete

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    
    self.sharedData = [SharedData sharedInstance];
    
    UIView *tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 60)];
    tabBar.backgroundColor = [UIColor phPurpleColor];
    [self addSubview:tabBar];
    
    //Help button
    self.btnHelp = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnHelp.frame = CGRectMake(self.sharedData.screenWidth - 80 - 8, 15, 80, 50);
    self.btnHelp.titleLabel.font = [UIFont phBold:14];
    self.btnHelp.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.btnHelp setTitle:@"HELP" forState:UIControlStateNormal];
    [self.btnHelp setTitleColor:[UIColor phDarkGrayColor] forState:UIControlStateNormal];
    [self.btnHelp addTarget:self action:@selector(btnHelpClicked) forControlEvents:UIControlEventTouchUpInside];
    //[tabBar addSubview:self.btnHelp];
    
    UIView *centerText = [[UIView alloc] initWithFrame:CGRectMake(0, 50 + ((self.sharedData.screenHeight-44-(112*2)-50)/2)-((64+8+32+16+16)/2), self.sharedData.screenWidth, 64+8+32+16+16)];
    centerText.backgroundColor = [UIColor clearColor];
    [self addSubview:centerText];
    
    self.check1 = [[SelectionCheckmark alloc] initWithFrame:CGRectMake((self.sharedData.screenWidth-64)/2, 0, 64, 64)];
    self.check1.userInteractionEnabled = NO;
    self.check1.layer.borderWidth = 2;
    [centerText addSubview:self.check1];
    
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, 64+16, self.sharedData.screenWidth, 32)];
    self.title.text = @"Your table is booked";
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.adjustsFontSizeToFitWidth = YES;
    self.title.textColor = [UIColor phDarkGrayColor];
    self.title.font = [UIFont phBlond:20];
    [centerText addSubview:self.title];
    
    self.subtitle = [[UILabel alloc] initWithFrame:CGRectMake(16, self.title.frame.origin.y + self.title.frame.size.height + 4, self.sharedData.screenWidth - 32,70)];
    self.subtitle.text = @"...";
    self.subtitle.adjustsFontSizeToFitWidth = YES;
    self.subtitle.textAlignment = NSTextAlignmentCenter;
    self.subtitle.adjustsFontSizeToFitWidth = YES;
    self.subtitle.textColor = [UIColor phDarkGrayColor];
    self.subtitle.font = [UIFont phBlond:14];
    //[centerText addSubview:self.subtitle];
    
    
    self.subTitleBox = [[UITextView alloc] initWithFrame:CGRectMake(16, self.title.frame.origin.y + self.title.frame.size.height + 4, self.sharedData.screenWidth - 32, 150)];
    
    self.subTitleBox.text = @"...";
    self.subTitleBox.textAlignment = NSTextAlignmentCenter;
    self.subTitleBox.textColor = [UIColor phDarkGrayColor];
    self.subTitleBox.font = [UIFont phBlond:14];
    self.subTitleBox.backgroundColor = [UIColor clearColor];
    [centerText addSubview:self.subTitleBox];
    
    
    
    //Create NO button
    self.btnNo = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.btnNo.frame = CGRectMake(0, self.sharedData.screenHeight - PHButtonHeight, self.sharedData.screenWidth, PHButtonHeight);
    self.btnNo.titleLabel.font = [UIFont phBold:16];
    [self.btnNo setTitleEdgeInsets:UIEdgeInsetsMake(3,0,0,0)];
    [self.btnNo setTitle:@"DONE" forState:UIControlStateNormal];
    [self.btnNo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnNo setBackgroundColor:[UIColor phBlueColor]];
    [self.btnNo addTarget:self action:@selector(btnNoClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnNo];
    
    //Create big  button
    self.btnCreate = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.btnCreate.frame = CGRectMake(self.btnNo.frame.origin.x, self.btnNo.frame.origin.y - self.btnNo.frame.size.height - 8 , self.btnNo.frame.size.width, self.btnNo.frame.size.height);
    self.btnCreate.titleLabel.font = [UIFont phBold:16];
    [self.btnCreate setTitleEdgeInsets:UIEdgeInsetsMake(3,0,0,0)];
    [self.btnCreate setTitle:@"CREATE A HOSTING" forState:UIControlStateNormal];
    [self.btnCreate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnCreate setBackgroundColor:[UIColor phGreenColor]];
    [self.btnCreate addTarget:self action:@selector(btnCreateClicked:) forControlEvents:UIControlEventTouchUpInside];
    //[self addSubview:self.btnCreate];
    
    return self;
}

-(void)initClass
{
    //NSString *eventName = self.sharedData.eventDict[@"title"];
    NSString *venueName = self.sharedData.eventDict[@"venue_name"];
    NSString *eventStartDate = [Constants toTitleDate:self.sharedData.eventDict[@"start_datetime_str"]];
    
    [self.check1 buttonSelect:NO animated:NO];
    
    self.subtitle.text = [NSString stringWithFormat:@"on %@, at %@",eventStartDate,venueName];
    
    
    if([self.sharedData.phone length] == 0)
    {
        if([self.sharedData.cFillType isEqualToString:@"reservation"])
        {
            self.subtitle.text = [NSString stringWithFormat:@"%@\n Please verify your phone number in case if we need to contact you regarding your reservation",self.subtitle.text];
        }else{
            self.subtitle.text = [NSString stringWithFormat:@"%@\n Please verify your phone number in case if we need to contact you regarding your purchase",self.subtitle.text];
        }
        
        
        [self.btnNo setTitle:@"VERIFY PHONE NUMBER" forState:UIControlStateNormal];
    }else{
        [self.btnNo setTitle:@"DONE" forState:UIControlStateNormal];
    }
    
    self.subTitleBox.text = self.subtitle.text;
    
    NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] init];
    [tmpDict addEntriesFromDictionary:self.sharedData.mixPanelCEventDict];
    [tmpDict addEntriesFromDictionary:self.sharedData.bookTable.selectedTicket];
    [[AnalyticManager sharedManager] trackMixPanelWithDict:@"Purchase Complete View" withDict:tmpDict];
    
}

-(void)btnHelpClicked
{
    [self.sharedData.bookTable helpSMS];
}

-(void)btnCreateClicked:(UIButton *)button
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"GO_BOOKTABLE_OFFERING"
     object:self];
}

-(void)btnNoClicked:(UIButton *)button
{
    if([self.sharedData.phone length]== 0)
    {
        self.sharedData.btnPhoneVerifyCancel.hidden = YES;
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"SHOW_PHONE_VERIFY"
         object:self];
        [self performSelector:@selector(postHidePage) withObject:nil afterDelay:1.5];
    }else{
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"EXIT_BOOKTABLE"
         object:self];
    }
}


-(void)postHidePage
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"EXIT_BOOKTABLE"
     object:self];
}
@end
