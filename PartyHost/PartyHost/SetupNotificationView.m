//
//  SetupNotificationView.m
//  PartyHost
//
//  Created by Tony Suriyathep on 7/10/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "AppDelegate.h"
#import "SetupNotificationView.h"

@implementation SetupNotificationView

-(void)awakeFromNib
{
    SharedData *sharedData = [SharedData sharedInstance];
    
    //Settings notifications these should be on by default, nothing to do with notification permission
    sharedData.notification_feed = YES;
    sharedData.notification_messages = YES;
    
    //Defaults to on
    [self.notificationSwitch setOn:YES];
}

- (IBAction)notificationSwitchChanged:(id)sender {
    //SharedData *sharedData = [SharedData sharedInstance];
    //UISwitch *notificationSwitch = (UISwitch*)sender;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:url];
}

-(BOOL)commitChanges {
    if([self.notificationSwitch isOn])
    {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"ASK_APN_PERMISSION"
         object:self];
    }
    
    return YES;
}

@end
