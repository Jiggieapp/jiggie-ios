//
//  SetupLocationView.m
//  PartyHost
//
//  Created by Tony Suriyathep on 8/6/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "SetupLocationView.h"

@implementation SetupLocationView

-(void)awakeFromNib
{
    //Default on
    [self.locationSwitch setOn:YES animated:NO];
}

- (IBAction)locationSwitchChanged:(id)sender {
    //SharedData *sharedData = [SharedData sharedInstance];
    //UISwitch *locationSwitch = (UISwitch*)sender;
}

-(BOOL)commitChanges {
    SharedData *sharedData = [SharedData sharedInstance];
    sharedData.location_on = self.locationSwitch.isOn;
    
    if(self.locationSwitch.isOn==NO) return YES; //Just ignore
    
    if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus]==kCLAuthorizationStatusRestricted )
    {
        if (&UIApplicationOpenSettingsURLString != NULL)
        { //iOS 8
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services" message:@"Please go to your settings and enable location services for Party Host." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
            alert.tag = 1;
            [alert show];
            return NO;
        }
        else
        {  //Old OS
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services" message:@"Please go to your settings and enable location services for Party Host." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
            [alert show];
            return NO;
        }
    }
    else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined)
    {
        if ([sharedData.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) { // iOS8+
            // Sending a message to avoid compile time error
            [[UIApplication sharedApplication] sendAction:@selector(requestWhenInUseAuthorization)
                                                       to:sharedData.locationManager
                                                     from:self
                                                 forEvent:nil];
        }
        return YES;
    }
    else
    {
        NSLog(@"SetupLocationView: Already allowed location");
    }
    
    return YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:url];
}

@end
