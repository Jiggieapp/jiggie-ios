//
//  BookTableHostingComplete.m
//  PartyHost
//
//  Created by Tony Suriyathep on 7/27/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "Events.h"
#import "BookTable.h"
#import "BookTableHostingComplete.h"
#import "AnalyticManager.h"

@implementation BookTableHostingComplete


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor phDarkBodyColor];
    
    self.sharedData = [SharedData sharedInstance];
    
    UIView *tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 60)];
    tabBar.backgroundColor = [UIColor clearColor];
    [self addSubview:tabBar];
    
    //Help button
    self.btnHelp = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnHelp.frame = CGRectMake(self.sharedData.screenWidth - 80 - 8, 15, 80, 50);
    self.btnHelp.titleLabel.font = [UIFont phBold:14];
    self.btnHelp.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.btnHelp setTitle:@"HELP" forState:UIControlStateNormal];
    [self.btnHelp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnHelp addTarget:self action:@selector(btnHelpClicked) forControlEvents:UIControlEventTouchUpInside];
    [tabBar addSubview:self.btnHelp];
    
    UIView *centerText = [[UIView alloc] initWithFrame:CGRectMake(0, 50 + ((self.sharedData.screenHeight-44-(112*2)-50)/2)-((64+8+32+16+16)/2), self.sharedData.screenWidth, 64+8+32+16+16)];
    centerText.backgroundColor = [UIColor clearColor];
    [self addSubview:centerText];
    
    self.check1 = [[SelectionCheckmark alloc] initWithFrame:CGRectMake((self.sharedData.screenWidth-64)/2, 0, 64, 64)];
    self.check1.innerColor = [UIColor phCyanColor];
    self.check1.userInteractionEnabled = NO;
    self.check1.layer.borderWidth = 2;
    [centerText addSubview:self.check1];
    
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, 64+16, self.sharedData.screenWidth, 32)];
    self.title.text = @"Your hosting is posted";
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.adjustsFontSizeToFitWidth = YES;
    self.title.textColor = [UIColor whiteColor];
    self.title.font = [UIFont phBlond:20];
    [centerText addSubview:self.title];
    
    self.subtitle = [[UILabel alloc] initWithFrame:CGRectMake(16, self.title.frame.origin.y + self.title.frame.size.height + 4, self.sharedData.screenWidth - 32, 16)];
    self.subtitle.text = @"...";
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
    [self.btnContinue setTitle:@"THANKS PARTYHOST! :)" forState:UIControlStateNormal];
    [self.btnContinue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnContinue setBackgroundColor:[UIColor phCyanColor]];
    [self.btnContinue addTarget:self action:@selector(btnContinueClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnContinue];
    
    return self;
}

-(void)initClass
{
    //NSString *eventName = self.sharedData.eventDict[@"title"];
    NSString *venueName = self.sharedData.eventDict[@"venue_name"];
    NSString *eventStartDate = [Constants toTitleDate:self.sharedData.eventDict[@"start_datetime_str"]];
    
    [self.check1 buttonSelect:NO animated:NO];
    
    self.subtitle.text = [NSString stringWithFormat:@"on %@, at %@",eventStartDate,venueName];
    
    //Refresh events summary page, this takes care of the HOST HERE button
    if([self.sharedData.eventsPage.eventsSummary.event_id isEqualToString:self.sharedData.eventDict[@"_id"]])
    {
        [self.sharedData.eventsPage.eventsSummary loadData:self.sharedData.eventDict[@"_id"]];
    }
    
    //Refresh guest listing page, this takes care of the HOST HERE button
    if([self.sharedData.eventsPage.eventsGuestList.event_id isEqualToString:self.sharedData.eventDict[@"_id"]])
    {
        [self.sharedData.eventsPage.eventsGuestList loadData:self.sharedData.eventDict[@"_id"]];
    }
    
    NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] init];
    [tmpDict addEntriesFromDictionary:self.sharedData.mixPanelCEventDict];
    //[tmpDict addEntriesFromDictionary:self.sharedData.bookTable.selectedTicket];
    
    [[AnalyticManager sharedManager] trackMixPanelWithDict:@"Add Hosting Complete View" withDict:tmpDict];
}

-(void)btnHelpClicked
{
    [self.sharedData.bookTable helpSMS];
}

-(void)btnContinueClicked:(UIButton *)button
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"EXIT_BOOKTABLE"
     object:self];
}

@end
