//
//  SetupNotificationView.h
//  PartyHost
//
//  Created by Tony Suriyathep on 7/10/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface SetupNotificationView : UIView <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *notificationSwitch;

-(BOOL)commitChanges;

@end
