//
//  SetupLocationView.m
//  PartyHost
//
//  Created by Tony Suriyathep on 8/6/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "SetupLocationView.h"
#import "LocationManager.h"

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
    
    [[LocationManager manager] startUpdatingLocation];
    [[LocationManager manager] didUpdateLocationsWithCompletion:^(CLLocationDegrees latitude, CLLocationDegrees longitude) {
        AFHTTPRequestOperationManager *manager = [sharedData getOperationManager];
        NSString *url = [NSString stringWithFormat:@"%@/save_longlat", PHBaseNewURL];
        NSDictionary *parameters = @{@"fb_id" : sharedData.fb_id,
                                     @"longitude" : [NSString stringWithFormat:@"%f", longitude],
                                     @"latitude" : [NSString stringWithFormat:@"%f", latitude],
                                     @"is_login" : [NSNumber numberWithBool:NO]};
        
        [manager POST:url parameters:parameters success:nil failure:nil];
    }];
    
    return YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:url];
}

@end
