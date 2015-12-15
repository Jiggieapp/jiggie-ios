//
//  AppDelegate.m
//  PartyHost
//
//  Created by Sunny Clark on 12/26/14.
//  Copyright (c) 2014 Sunny Clark. All rights reserved.
//

#import "AppDelegate.h"
#import "AnalyticManager.h"

///REMOVE THIS WHEN LIVE
//#import "GSTouchesShowingWindow.h"
///REMOVE THIS WHEN LIVE


@interface AppDelegate ()
@end

#define contains(str1, str2) ([str1 rangeOfString: str2 ].location != NSNotFound)

static NSString *const kTrackingId = @"UA-58550409-2";
static NSString *const kAllowTracking = @"allowTracking";

@implementation AppDelegate


///REMOVE THIS WHEN LIVE
/*
- (GSTouchesShowingWindow *)window {
    static GSTouchesShowingWindow *window = nil;
    if (!window) {
        window = [[GSTouchesShowingWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    return window;
}
 */
///REMOVE THIS WHEN LIVE


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.sharedData = [SharedData sharedInstance];
    self.inAskingAPNMode = NO;
    self.isShowNotification = NO;
    
    [self checkIfHasAPN];
    
    //[[AppsFlyerTracker sharedTracker].customerUserID =@"YOUR_CUSTOM_DEVICE_ID"];
    
    NSDictionary *appDefaults = @{kAllowTracking: @(YES)};
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    [GAI sharedInstance].optOut =![[NSUserDefaults standardUserDefaults] boolForKey:kAllowTracking];
    [GAI sharedInstance].dispatchInterval = 1;
    
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    //self.tracker = [[GAI sharedInstance] trackerWithName:@"PartyHostApp" trackingId:kTrackingId];
    
    [RFRateMe showRateAlertAfterTimesOpened:3];
    //[Appsee start:@"ba0b4c483e6c4a3ebf9266d0db03e794"];
    
    
    
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    
    //Start Analytics
    [[AnalyticManager sharedManager] startAnalytics];
    
    
    
    
    
    //[Crashlytics startWithAPIKey:@"1714fcc893d2312cb2b248ed57743517e718c399"];
    [Fabric with:@[[Crashlytics class]]];
    
    //TSConfig *config = [TSConfig configWithDefaults];
    //[TSTapstream createWithAccountName:@"partyhost" developerSecret:@"a5FxhL0zS9Wwqrq1dBQruw" config:config];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if(![defaults objectForKey:@"FIRST_RUN"])
    {
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel track:@"Install" properties:nil];
        
        //[self.sharedData trackMixPanel:@"ios-party-host-install"];
        [defaults setValue:@"YES" forKey:@"FIRST_RUN"];
        [defaults synchronize];
    }
    
    
    //config.odin1 = @"82a53f1222f8781a5063a773231d4a7ee41bdd6f";
    
    //TSTapstream *tracker = [TSTapstream instance];
    /*
    [tracker getConversionData:^(NSData *jsonInfo) {
        if(jsonInfo == nil)
        {
            // No conversion data available
        }
        else
        {
            NSError *error = nil;
            NSArray *json = [NSJSONSerialization JSONObjectWithData:jsonInfo options:kNilOptions error:&error];
            if(json && !error)
            {
                // Read some data from this json object, and modify your application's behavior accordingly
                // ...
                NSLog(@"TAPSTREAM_INFO_START");
                NSLog(@"%@",json);
                NSLog(@"TAPSTREAM_INFO_END");
                
                [self.sharedData.tapDict setObject:json forKey:@"info"];
            }
        }
    }];
    */
    NSDictionary *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (localNotif)
    {
        self.sharedData.fromMailId = [localNotif objectForKey:@"fromFBId"];
        self.sharedData.hasMessageToLoad = YES;
    }
    //[self.sharedData trackMixPanel:@"APP_LOADED"];
    //Mixpanel *mixpanel = [Mixpanel sharedInstance];
    //[mixpanel track:@"APP_LOADED" properties:@{@"Prop": @"Value",}];
    NSLog(@"APP_LAUNCH");
    
    NSURL *launchUrl = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    if(launchUrl)
    {
        NSURL *url = launchUrl;
        if(contains(url.absoluteString,@"jiggie://"))
        {
            NSDictionary *dict = [self.sharedData parseQueryString:[url query]];
            if(dict[@"af_sub2"])
            {
                self.sharedData.hasInitEventSelection = YES;
//                self.sharedData.cInitHosting_id = dict[@"af_sub2"];
//                self.sharedData.cHostingIdFromInvite = dict[@"af_sub2"];
                
                self.sharedData.cEventId_Feed = dict[@"af_sub2"];
                self.sharedData.cEventId_Modal = dict[@"af_sub2"];
            }
        }
    }
    

    //For debug mode clear out all ONE-TIME popups
    if(PHDebugOn==YES) {
        NSLog(@">>> PhDebugOn==YES: Clearing all ONE-TIME helpers.");
        
        [defaults setValue:NULL forKey:@"SHOWED_EVENTS_OVERLAY"];
        [defaults setValue:NULL forKey:@"SHOWED_EVENTS_SUMMARY_HOST_OVERLAY"];
        [defaults setValue:NULL forKey:@"SHOWED_EVENTS_SUMMARY_GUEST_OVERLAY"];
        [defaults setValue:NULL forKey:@"SHOWED_EVENTS_HOST_LIST_OVERLAY"];
        [defaults setValue:NULL forKey:@"SHOWED_EVENTS_GUEST_LIST_OVERLAY"];
        
        [defaults setValue:NULL forKey:@"SHOWED_WALKTHROUGH"];
        [defaults setValue:NULL forKey:@"SHOWED_INVITE_GUEST"];
        [defaults setValue:NULL forKey:@"SHOWED_ACCEPTED_CHAT"];
    }
    
    //Listen to register
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(registerForNotifications)
     name:@"ASK_APN_PERMISSION"
     object:nil];
    
    
    [self performSelector:@selector(checkApnAgain) withObject:nil afterDelay:4.0];
    
    //[self performSelector:@selector(testApp) withObject:nil afterDelay:5.0];
    
    return YES;
}

-(void)testApp
{
    [self showChatNotification:@"sunny" withMessage:@"message" withImage:[self.sharedData profileImg:@"10152901432247953"]];
}

-(void)checkIfHasAPN
{
    
    if([self notificationServicesEnabled])
    {
        self.sharedData.APN_PERMISSION_STATE = @"ENABLED";
        /*
         NSLog(@"notificationServicesEnabled");
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enabled" message:@"You have enabled push notifications" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
         [alert show];
         */
    }else{
        self.sharedData.APN_PERMISSION_STATE = @"DISABLED";
        /*
         NSLog(@"notificationServicesDisabled");
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Disabled" message:@"You have disabled push notifications" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
         [alert show];
         */
    }
    
    
    [self performSelector:@selector(checkApnAgain) withObject:nil afterDelay:8.0];
}

-(void)checkApnAgain
{
    if(self.sharedData.isLoggedIn)
    {
        return;
    }
    
 
        self.sharedData.apnToken = @"empty";
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"APN_LOADED"
         object:self];
}

-(BOOL)notificationServicesEnabled
{
    BOOL isEnabled = NO;
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(currentUserNotificationSettings)])
    {
        UIUserNotificationSettings *notificationSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        
        if(!notificationSettings || (notificationSettings.types == UIUserNotificationTypeNone))
        {
            isEnabled = NO;
        }else
        {
            isEnabled = YES;
        }
    }else
    {
        UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        //if (types && (types == UIRemoteNotificationTypeAlert || types == UIRemoteNotificationTypeBadge || types ==UIRemoteNotificationTypeSound))
        if(types != UIUserNotificationTypeNone)
        {
            isEnabled = YES;
        } else{
            isEnabled = NO;
        }
    }
    
    return isEnabled;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if(self.inAskingAPNMode)
    {
        if([self notificationServicesEnabled])
        {
            self.sharedData.APN_PERMISSION_STATE = @"ENABLED";
        }else{
            self.sharedData.APN_PERMISSION_STATE = @"DISABLED";
        }
        
        [self.sharedData.setupPage apnAskingDoneHandler];
        
        /*
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"APN_ASKING_DONE"
         object:self];
        */
    }
    
    self.inAskingAPNMode = NO;
    //UPDATE_CONVERSATION_LIST
    
    
    
    //[AppsFlyerTracker sharedTracker].isHTTPS = YES;
    [[AppsFlyerTracker sharedTracker] trackAppLaunch];
    
    
    [AppsFlyerTracker sharedTracker].delegate = self;
    
    /*
    NSString *idfaString = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [AppsFlyerTracker sharedTracker].appsFlyerDevKey = @"Rkuw6TCpCtAMpUicmEUz27";
    [AppsFlyerTracker sharedTracker].appleAppID = @"906484188";
    [AppsFlyerTracker sharedTracker].customerUserID = idfaString;
    [AppsFlyerTracker sharedTracker].delegate = self;
    //[AppsFlyerTracker sharedTracker].isHTTPS = YES;
    [[AppsFlyerTracker sharedTracker] trackAppLaunch];
    NSLog(@"idfaString :: %@",idfaString);
    */
    
    
    //[self.sharedData trackMixPanel:@"ios-party-host-open"];
    
    if(self.sharedData.isLoggedIn)
    {
        if(self.sharedData.isInConversation)
        {
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"RELOAD_CURRENT_CONVERSATION"
             object:self];
        }
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"UPDATE_CONVERSATION_LIST"
         object:self];
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"MORE_TAPPED"
         object:self];
    }
    
     [FBSDKAppEvents activateApp];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    
    NSLog(@"URL :: %@",url.absoluteString);
    if(contains(url.absoluteString,@"jiggie://"))
    {
        if(self.sharedData.isLoggedIn)
        {
            NSDictionary *dict = [self.sharedData parseQueryString:[url query]];
            if(dict[@"af_sub2"])
            {
//                self.sharedData.cInitHosting_id = dict[@"af_sub2"];
//                
//                self.sharedData.cHostingIdFromInvite = dict[@"af_sub2"];
//                self.sharedData.hasInitEventSelection = NO;
//
//                [[NSNotificationCenter defaultCenter]
//                 postNotificationName:@"SHOW_HOST_VENUE_DETAIL_FROM_SHARE"
//                 object:self];
                
                self.sharedData.cEventId_Feed = dict[@"af_sub2"];
                self.sharedData.cEventId_Modal = dict[@"af_sub2"];
                
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"SHOW_EVENT_MODAL"
                 object:self];
                
                /*
                 [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"GO_TO_INIT_HOSTING"
                 object:self];
                 */
            }
        }
        return YES;
    }

    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
    
    //return YES;
    // attempt to extract a token from the url
    //return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}


-(void)syncAPN
{
    //app/v3/apntoken/10152901432247953/123455466
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    NSString *urlToLoad = [NSString stringWithFormat:@"%@/user/hostings/details/%@",PHBaseURL,self.sharedData.cHostingIdFromInvite];
    
    urlToLoad = [NSString stringWithFormat:@"%@/apntoken/%@/%@",PHBaseURL,self.sharedData.fb_id,self.sharedData.apnToken];
    
    NSLog(@"APN_TOKEN_SYNC URL :: %@",urlToLoad);
    
    [manager GET:urlToLoad parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         NSLog(@"APN_SYNC :: %@",responseObject);
         
         
         NSLog(@"HOSTING_DETAILS_FROM_SHARE RESPONSE :: %@",responseObject);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"APN_FAIL_SYNC");
     }];
}



- (void)registerForNotifications
{
    
    self.inAskingAPNMode = NO;
    
#ifdef __IPHONE_8_0
    if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
                                                                                             |UIRemoteNotificationTypeSound
                                                                                             |UIRemoteNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    } else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
#else
    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
#endif
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"APN - %@", token);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:@"USER_APN"];
    [defaults synchronize];
    self.apnToken = token;
    self.sharedData.apnToken  = token;
    
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"YES" message:self.sharedData.apnToken delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Okay", nil];
    //[alert show];
    /*
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"APN_LOADED"
     object:self];
    */
    
    if(self.sharedData.isInAskingNotification)
    {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"HIDE_LOADING"
         object:nil];
    }
    
    self.sharedData.isInAskingNotification = NO;
    
    if(self.sharedData.isLoggedIn)
    {
        [self syncAPN];
    }
    
    /*
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"APN_ASKING_DONE"
     object:nil];
    */
}


#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}


-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"])
    {
        
    }
    else if ([identifier isEqualToString:@"answerAction"])
    {
        
    }
}
#endif

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if(!self.sharedData.isLoggedIn)
    {
        return;
    }
    
    
    if ( application.applicationState == UIApplicationStateActive ) {
        // app was already in the foreground
        
        if([[userInfo objectForKey:@"type"]  isEqualToString:@"message"])
        {
            
            self.sharedData.fromMailId = [userInfo objectForKey:@"fromFBId"];
            self.sharedData.fromMailName = [userInfo objectForKey:@"fromName"];
            
            
            
            
            if(self.sharedData.isInConversation && [self.sharedData.conversationId isEqualToString:self.sharedData.fromMailId])
            {
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"UPDATE_CURRENT_CONVERSATION"
                 object:self];
            }else{
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"UPDATE_CONVERSATION_LIST"
                 object:self];
                
                if(!self.isShowNotification)
                {
                    [self showChatNotification:[userInfo objectForKey:@"fromName"] withMessage:[userInfo objectForKey:@"message"] withImage:[self.sharedData profileImg:self.sharedData.fromMailId]];
                }
            }
            
        }
    }
    else {
        
        if([[userInfo objectForKey:@"type"]  isEqualToString:@"message"])
        {
            // app was just brought from background to foreground
            self.sharedData.fromMailId = [userInfo objectForKey:@"fromFBId"];
            self.sharedData.fromMailName = [userInfo objectForKey:@"fromName"];
            [self goToMessages];
            
        }
        
        if([[userInfo objectForKey:@"type"]  isEqualToString:@"notification"])
        {
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"SHOW_PARTYFEED"
             object:self];
        }
        
    }
    
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"YES" message:@"" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Okay", nil];
    //[alert show];
    
    
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    self.apnToken = @"empty";
    self.sharedData.apnToken  = @"empty";
    
    
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"APN_ERROR" message:@"" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Okay", nil];
    //[alert show];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"APN_LOADED"
     object:self];
    
//    [self.sharedData.setupPage apnAskingDoneHandler];
    /*
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"APN_ASKING_DONE"
     object:self];
    */
    
    NSLog(@"APN_ERROR :: %@",[NSString stringWithFormat:@"APN ERR : %@", error.description]);
}



-(void)showChatNotification:(NSString *)userName withMessage:(NSString *)message withImage:(NSString *)imgURL
{
    int Height = 65;
    int picSize = 50;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.65]];
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_black_bk"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, -Height, 320, Height);
    //imgURL = [self.sharedData profileImg:imgURL];
    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL]]];
    UIImageView *imgCon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, picSize, picSize)];
    imgCon.image = img;
    imgCon.contentMode = UIViewContentModeScaleAspectFill;
    imgCon.userInteractionEnabled = YES;
    [btn insertSubview:imgCon atIndex:1];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(Height + 10, 5, self.window.frame.size.width - Height - 10 - Height - 10, 20)];
    title.textColor = [UIColor whiteColor];
    title.text = userName;
    title.font = [UIFont phBold:15];
    title.userInteractionEnabled = YES;
    title.backgroundColor = [UIColor clearColor];
    //[btn addSubview:title];
    
    UILabel *subtitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 15, self.window.frame.size.width - 90, Height - 15)];
    subtitle.textColor = [UIColor whiteColor];
    subtitle.font = [UIFont fontWithName:@"" size:12];
    subtitle.text = message;//[NSString stringWithFormat:@"%@: %@",[userName uppercaseString],message];
    subtitle.userInteractionEnabled = YES;
    subtitle.backgroundColor = [UIColor clearColor];
    [btn addSubview:subtitle];
    
    UIView *redSquare = [[UIView alloc] initWithFrame:CGRectMake(self.window.frame.size.width - 40, 0, 40, Height)];
    redSquare.backgroundColor = [UIColor clearColor];
    [btn addSubview:redSquare];
    
    UILabel *btnX = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 40, picSize)];
    btnX.textColor = [UIColor whiteColor];
    btnX.font = [UIFont phBlond:20];
    btnX.text = @"X";
    btnX.textAlignment = NSTextAlignmentCenter;
    btnX.userInteractionEnabled = YES;
    btnX.backgroundColor = [UIColor clearColor];
    [redSquare addSubview:btnX];
    
    UIView *dimView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, Height)];
    dimView.backgroundColor = [UIColor clearColor];
    //dimView.backgroundColor = [UIColor phDarkBodyColor];
    dimView.userInteractionEnabled = YES;
    [btn addSubview:dimView];
    
    UILongPressGestureRecognizer *tapGest = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tapGest.minimumPressDuration = .01;
    [dimView addGestureRecognizer:tapGest];
    
    self.btnNotify = btn;
    
    self.isShowNotification = YES;
    
    [self.window.rootViewController.view addSubview:btn];
    
    [UIView animateWithDuration:0.25 animations:^()
     {
         btn.frame = CGRectMake(0, 0, self.window.frame.size.width, Height);
     } completion:^(BOOL finished){
         [self performSelector:@selector(animateHideNotify) withObject:nil afterDelay:5.0];
     }];
    
    /*
     UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, -65, 320, 65)];
     tmpView.backgroundColor = [UIColor purpleColor];
     [self.window.rootViewController.view addSubview:tmpView];
     
     [UIView animateWithDuration:0.5 animations:^()
     {
     tmpView.frame = CGRectMake(0, 0, 320, 65);
     }];
     */
    
    
    //[self checkMessages];
}


-(void)animateHideNotify
{
    if(self.btnNotify == nil)
    {
        self.isShowNotification = NO;
        return;
    }
    
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.btnNotify.frame = CGRectMake(0, -65, self.window.frame.size.width, 65);
     } completion:^(BOOL finished)
     {
         [self.btnNotify removeFromSuperview];
         self.btnNotify = nil;
         self.isShowNotification = NO;
     }];
}


-(void)tapHandler:(UILongPressGestureRecognizer *)sender
{
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        sender.view.alpha = 0.5;
        sender.view.backgroundColor = [UIColor blackColor];
    }
    
    if(sender.state == UIGestureRecognizerStateEnded)
    {
        sender.view.backgroundColor = [UIColor clearColor];
        sender.view.alpha = 1;
        
        self.btnNotify.userInteractionEnabled = NO;
        
        CGPoint coords = [sender locationInView:sender.view];
        //NSLog(@"COORDS :: %@",NSStringFromCGPoint(coords));
        
        if(coords.x >= self.window.frame.size.width - 40)
        {
            [self.btnNotify removeFromSuperview];
            self.btnNotify = nil;
            self.isShowNotification = NO;
        }else{
            [self hideNotify];
        }
    }
}

-(void)hideNotify
{
    if(self.btnNotify == nil)
    {
        self.isShowNotification = NO;
        return;
    }
    
    int setTime = 0;
    if(self.sharedData.isInConversation)
    {
        setTime = 1.0;
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"MESSAGES_GO_BACK"
         object:self];
    }
    
    [self performSelector:@selector(goToMessages) withObject:nil afterDelay:setTime];
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.btnNotify.frame = CGRectMake(0, -65, self.window.frame.size.width, 65);
     } completion:^(BOOL finished)
     {
         [self.btnNotify removeFromSuperview];
         self.btnNotify = nil;
     }];
}

-(void)goToMessages
{
    self.sharedData.conversationId = self.sharedData.fromMailId;
    self.sharedData.messagesPage.toId = self.sharedData.fromMailId;
    self.sharedData.messagesPage.toLabel.text = [self.sharedData.fromMailName uppercaseString];
    self.sharedData.toImgURL = [self.sharedData profileImg:self.sharedData.fromMailId];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_MESSAGES"
     object:self];
}


#pragma AppsFlyerTrackerDelegate methods
- (void)onConversionDataReceived:(NSDictionary*) installData
{
    NSLog(@"RECEIVE_INSTALL DATA :: %@",installData);
    
    
    id status = [installData objectForKey:@"af_status"];
    
    if(self.sharedData.didAppsFlyerLoad == YES)
    {
        return;
    }
    
    
    if([status isEqualToString:@"Non-organic"])
    {
        self.sharedData.didAppsFlyerLoad = YES;
        id sourceID = [installData objectForKey:@"media_source"];
        id campaign = [installData objectForKey:@"campaign"];
        NSLog(@"This is a non organic install.");
        NSLog(@"Media source: %@",sourceID);
        NSLog(@"Campaign: %@",campaign);
        NSLog(@"INSTALL DATA :: %@",installData);
        [self.sharedData.appsFlyerDict removeAllObjects];
        [self.sharedData.appsFlyerDict addEntriesFromDictionary:installData];
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if(![defaults objectForKey:@"init_hosting"])
        {
            if(self.sharedData.appsFlyerDict[@"af_sub2"])
            {
                self.sharedData.hasInitEventSelection = YES;
                self.sharedData.cInitHosting_id = self.sharedData.appsFlyerDict[@"af_sub2"];
                self.sharedData.cHostingIdFromInvite = self.sharedData.appsFlyerDict[@"af_sub2"];
            }
            
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"YES" forKey:@"init_hosting"];
            [defaults synchronize];
        }
    } else if([status isEqualToString:@"Organic"]) {
        NSLog(@"This is an organic install.");
        [self.sharedData.appsFlyerDict removeAllObjects];
        [self.sharedData.appsFlyerDict setObject:@"organic" forKey:@"media_source"];
        [self.sharedData.appsFlyerDict setObject:@"organic" forKey:@"campaign"];
        [self.sharedData.appsFlyerDict setObject:@"organic" forKey:@"af_status"];
    }
    
    
    
}




- (void) onConversionDataRequestFailure:(NSError *)error{
    NSLog(@"Failed to get data from AppsFlyer's server: %@",[error localizedDescription]);
}

@end
