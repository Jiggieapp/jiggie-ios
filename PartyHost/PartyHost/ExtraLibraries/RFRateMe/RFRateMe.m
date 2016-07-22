//
//  RFRateMe.m
//  RFRateMeDemo
//
//  Created by Ricardo Funk on 1/2/14.
//  Copyright (c) 2014 Ricardo Funk. All rights reserved.
//

#import "RFRateMe.h"
#import "UIAlertView+NSCookbook.h"
#import "HCSStarRatingView.h"
#import <sys/utsname.h>

#define kNumberOfDaysUntilShowAgain 3
#define kAppStoreAddress @"https://itunes.apple.com/us/app/jiggie-social-event-discovery/id1047291489"
#define kAppName @"Jiggie"
#define kAlertViewWidth 270

@interface RFRateMe() <UITextViewDelegate>

@property(strong, nonatomic) UIAlertView *rateAlertView;

@end

@implementation RFRateMe

+ (RFRateMe *)sharedInstance {
    static RFRateMe *_sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (void)showRateAlert {
    //If rate was completed, we just return if True
    BOOL rateCompleted = [[NSUserDefaults standardUserDefaults] boolForKey:@"RFRateCompleted"];
    if (rateCompleted) return;
    
    //Check if the user asked not to be prompted again for 3 days (remind me later)
    BOOL remindMeLater = [[NSUserDefaults standardUserDefaults] boolForKey:@"RFRemindMeLater"];
    
    if (remindMeLater) {
        
        NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
        [DateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [DateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSString *start = [[NSUserDefaults standardUserDefaults] objectForKey:@"RFStartDate"];
        NSString *end = [DateFormatter stringFromDate:[NSDate date]];
        
        NSDateFormatter *f = [[NSDateFormatter alloc] init];
        [f setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [f setDateFormat:@"yyyy-MM-dd"];
        NSDate *startDate = [f dateFromString:start];
        NSDate *endDate = [f dateFromString:end];
        
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                            fromDate:startDate
                                                              toDate:endDate
                                                             options:0];
        
        if ((long)[components day] <= kNumberOfDaysUntilShowAgain) return;
        
    }
    
    [self.rateAlertView dismissWithClickedButtonIndex:0 animated:NO];
    
    //Show rate alert
    self.rateAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(kAppName, @"")
                                                    message:[NSString stringWithFormat:@"How would you rate your %@ experience", kAppName]
                                                   delegate:nil
                                          cancelButtonTitle:@"Later"
                                          otherButtonTitles:nil, nil];
    
    HCSStarRatingView *rateView = [[HCSStarRatingView alloc] init];
    [rateView setBackgroundColor:[UIColor clearColor]];
    [rateView setMinimumValue:0];
    [rateView setMaximumValue:5];
    [rateView setValue:0];
    
    [self showRateAlertView:rateView];
}

- (void)showRateAlertAfterTimesOpened:(int)times {
    //Thanks @kylnew for feedback and idea!
    
    BOOL rateCompleted = [[NSUserDefaults standardUserDefaults] boolForKey:@"RFRateCompleted"];
    if (rateCompleted) return;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger timesOpened = [defaults integerForKey:@"timesOpened"];
    [defaults setInteger:timesOpened+1 forKey:@"timesOpened"];
    [defaults synchronize];
    NSLog(@"App has been opened %ld times", (long)[defaults integerForKey:@"timesOpened"]);
    if([defaults integerForKey:@"timesOpened"] >= times){
        [[RFRateMe sharedInstance] showRateAlert];
    }


}


- (void)showRateAlertAfterDays:(int)times {
    
    BOOL rateCompleted = [[NSUserDefaults standardUserDefaults] boolForKey:@"RFRateCompleted"];
    if (rateCompleted) return;
    
    BOOL showAfterXdays = [[NSUserDefaults standardUserDefaults] boolForKey:@"RFShowAfterXDays"];
    
    if (!showAfterXdays) {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *now = [NSDate date];
        [[NSUserDefaults standardUserDefaults] setObject:[dateFormatter stringFromDate:now] forKey:@"RFGeneralStartDate"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"RFShowAfterXDays"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [DateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *start = [[NSUserDefaults standardUserDefaults] objectForKey:@"RFGeneralStartDate"];
    NSString *end = [DateFormatter stringFromDate:[NSDate date]];
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [f setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [f dateFromString:start];
    NSDate *endDate = [f dateFromString:end];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    
    if ((long)[components day] <= times) return;
    
    
}

- (void)showRateAlertView:(HCSStarRatingView *)sender {
    CGFloat kRatingViewWidth = 170;
    
    HCSStarRatingView *rateView = [[HCSStarRatingView alloc]
                                   initWithFrame:CGRectMake((kAlertViewWidth / 2) - (kRatingViewWidth / 2),
                                                            0,
                                                            kRatingViewWidth,
                                                            30)];
    [rateView setBackgroundColor:[UIColor clearColor]];
    [rateView setMinimumValue:0];
    [rateView setMaximumValue:5];
    [rateView setValue:sender.value];
    [rateView setSpacing:8];
    [rateView setContinuous:NO];
    [rateView setTintColor:[UIColor phPurpleColor]];
    [rateView addTarget:self action:@selector(showRateAlertView:) forControlEvents:UIControlEventValueChanged];
    
    if (sender.value >= 4) {
        if (self.rateAlertView.tag != 103) {
            [rateView setUserInteractionEnabled:NO];
            [self.rateAlertView dismissWithClickedButtonIndex:0 animated:NO];
            self.rateAlertView = [[UIAlertView alloc] initWithTitle:@"Rate our App"
                                                            message:[NSString stringWithFormat:@"How would you rate your %@ experience", kAppName]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Later"
                                                  otherButtonTitles:@"Review", nil];
            
            UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kAlertViewWidth, 50)];
            [accessoryView addSubview:rateView];
            
            [self.rateAlertView setTag:103];
            [self.rateAlertView setValue:accessoryView forKey:@"accessoryView"];
            [self.rateAlertView showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
                switch (buttonIndex) {
                    case 0: {
                        // Later
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        [defaults setInteger:0 forKey:@"timesOpened"];
                        [defaults synchronize];
                        
                        break;
                    }
                    case 1: {
                        // Review
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"RFRateCompleted"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppStoreAddress]];
                        
                        break;
                    }
                }
            }];
        }
    } else if (sender.value >= 1) {
        if (self.rateAlertView.tag != 102) {
            [rateView setUserInteractionEnabled:NO];
            [self.rateAlertView dismissWithClickedButtonIndex:0 animated:NO];
            
            self.rateAlertView = [[UIAlertView alloc] initWithTitle:@"Rate our App"
                                                            message:[NSString stringWithFormat:@"How would you rate your %@ experience", kAppName]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Later"
                                                  otherButtonTitles:@"Send Feedback", nil];
            
            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 40, 250, 70)];
            textView.backgroundColor = [UIColor phLightSilverColor];
            textView.text = @"Enter your feedback...";
            textView.delegate = self;
            textView.textColor = [UIColor darkGrayColor];
            textView.font = [UIFont phBlond:15];
            textView.layer.cornerRadius = 5;
            textView.layer.borderColor = [UIColor phLightGrayColor].CGColor;
            textView.layer.borderWidth = 1;
            
            UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kAlertViewWidth, 140)];
            [accessoryView addSubview:rateView];
            [accessoryView addSubview:textView];
            
            [self.rateAlertView setTag:102];
            [self.rateAlertView setValue:accessoryView forKey:@"accessoryView"];
            [self.rateAlertView showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
                switch (buttonIndex) {
                    case 0: {
                        // Later
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        [defaults setInteger:0 forKey:@"timesOpened"];
                        [defaults synchronize];
                        
                        break;
                    }
                    case 1: {
                        // Send Feedback
                        struct utsname systemInfo;
                        uname(&systemInfo);
                        
                        SharedData *sharedData = [SharedData sharedInstance];
                        AFHTTPRequestOperationManager *manager = [sharedData getOperationManager];
                        NSString *url = [NSString stringWithFormat:@"%@/review_rate", PHBaseNewURL];
                        NSDictionary *parameters = @{@"fb_id" : sharedData.fb_id,
                                                     @"rate" : [[NSNumber numberWithFloat:sender.value] stringValue],
                                                     @"feed_back" : textView.text,
                                                     @"device_type" : @"1",
                                                     @"version" : [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
                                                     @"model" : [NSString stringWithCString:systemInfo.machine
                                                                                   encoding:NSUTF8StringEncoding]};
                        
                        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            if (operation.response.statusCode == 200) {
                                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"RFRateCompleted"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                
                                [self showFeedbackSentAlertView];
                                
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [self.rateAlertView dismissWithClickedButtonIndex:0 animated:YES];
                                });
                            }
                        } failure:nil];
                        
                        break;
                    }
                }
            }];
        }
    } else {
        [self.rateAlertView dismissWithClickedButtonIndex:0 animated:NO];
        
        self.rateAlertView = [[UIAlertView alloc] initWithTitle:@"Rate our App"
                                                        message:[NSString stringWithFormat:@"How would you rate your %@ experience", kAppName]
                                                       delegate:nil
                                              cancelButtonTitle:@"Later"
                                              otherButtonTitles:nil, nil];
        
        UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kAlertViewWidth, 50)];
        [accessoryView addSubview:rateView];
        
        [self.rateAlertView setValue:accessoryView forKey:@"accessoryView"];
        [self.rateAlertView showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
            switch (buttonIndex) {
                case 0: {
                    // Later
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setInteger:0 forKey:@"timesOpened"];
                    [defaults synchronize];
                    
                    break;
                }
            }
        }];
    }
}

- (void)showFeedbackSentAlertView {
    self.rateAlertView = [[UIAlertView alloc] initWithTitle:@"Feedback Sent"
                                                    message:@"Thank you. Your feedback is greatly appreciated."
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    
    CGFloat kImageViewWidth = 80;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_oval_checked"]];
    imageView.frame = CGRectMake((kAlertViewWidth / 2) - (kImageViewWidth / 2), 0, kImageViewWidth, kImageViewWidth);
    
    UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kAlertViewWidth, kImageViewWidth+15)];
    [accessoryView addSubview:imageView];
    
    [self.rateAlertView setValue:accessoryView forKey:@"accessoryView"];
    [self.rateAlertView show];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"Enter your feedback..."]) {
        textView.text = @"";
    }
}


@end
