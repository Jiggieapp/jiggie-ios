//
//  AppDelegate.m
//  PartyHost
//
//  Created by Sunny Clark on 12/26/14.
//  Copyright (c) 2014 Sunny Clark. All rights reserved.
//

#import "AppDelegate.h"
#import "AnalyticManager.h"
#import "AFNetworkActivityLogger.h"
#import "UserManager.h"
#import "VTConfig.h"
#import "LocationManager.h"
#import "JGTooltipHelper.h"
#import "City.h"
#import "Firebase.h"


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
        window = [[GSTouchesShwingWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    return window;
}
 */
///REMOVE THIS WHEN LIVE


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"nav_back_new"]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"nav_back_new"]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                  [UIColor whiteColor],NSForegroundColorAttributeName,
                                                                                                  [UIFont phBlond:14],
                                                                                                  NSFontAttributeName,
                                                                                                  nil]
                                                                                        forState:UIControlStateNormal];
    // Use Firebase library to configure APIs
    [FIRApp configure];
    [[FIRDatabase database] setPersistenceEnabled:YES];
    
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
    
    // AFNetworking Debug Setting:
//    [[AFNetworkActivityLogger sharedLogger] startLogging];
//    [[AFNetworkActivityLogger sharedLogger] setLevel:AFLoggerLevelDebug];
    
    //[Crashlytics startWithAPIKey:@"1714fcc893d2312cb2b248ed57743517e718c399"];
    [Fabric with:@[[Crashlytics class]]];
    
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
    
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//    NSDictionary *userInfo = @{@"type":@"social", @"event_id":@"56cd3a2cf96cf103001ecd81", @"fromFBId":@"10153311635578981", @"fromName":@"Setiady"};
    if (userInfo && userInfo != nil) {
        if([[userInfo objectForKey:@"type"]  isEqualToString:@"general"])
        {
            // app was just brought from background to foreground
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"SHOW_EVENTS"
             object:self];
            
        } else if([[userInfo objectForKey:@"type"]  isEqualToString:@"event"])
        {
            self.sharedData.cEventId_Feed = [userInfo objectForKey:@"event_id"];
            self.sharedData.cEventId_Modal = [userInfo objectForKey:@"event_id"];
            self.sharedData.hasInitEventSelection = YES;
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"SHOW_EVENT_DETAIL"
             object:self];
            
        } else if([[userInfo objectForKey:@"type"]  isEqualToString:@"match"])
        {
            // app was just brought from background to foreground
            self.sharedData.fromMailId = [userInfo objectForKey:@"fromFBId"];
            self.sharedData.fromMailName = [userInfo objectForKey:@"fromName"];
            self.sharedData.hasMessageToLoad = YES;
            
        } else if([[userInfo objectForKey:@"type"]  isEqualToString:@"message"])
        {
            // app was just brought from background to foreground
            self.sharedData.fromMailId = [userInfo objectForKey:@"fromFBId"];
            self.sharedData.fromMailName = [userInfo objectForKey:@"fromName"];
            self.sharedData.hasMessageToLoad = YES;

        } else if([[userInfo objectForKey:@"type"]  isEqualToString:@"social"])
        {
            self.sharedData.hasFeedToLoad = YES;
            
        } else if([[userInfo objectForKey:@"type"]  isEqualToString:@"chat"])
        {
            self.sharedData.fromMailId = @"";
            self.sharedData.fromMailName = @"";
            self.sharedData.hasMessageToLoad = YES;
        }
    }
    
    //For debug mode clear out all ONE-TIME popups
    if(PHDebugOn==YES) {
        NSLog(@">>> PhDebugOn==YES: Clearing all ONE-TIME helpers.");
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
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
    
    // for testing
    [VTConfig setCLIENT_KEY:VeritransClientKey];
    [VTConfig setVT_IsProduction:isVeritransInProducion];
    
    //[self performSelector:@selector(testApp) withObject:nil afterDelay:5.0];
    
    // set up tooltip
    [JGTooltipHelper setUpTooltip];

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
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs removeObjectForKey:@"temp_da_list"];
    [prefs synchronize];
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
    
    // Load all Tags
    [[UserManager sharedManager] loadAllTags];
    
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
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"SHOWED_WALKTHROUGH"]) {
        [[LocationManager manager] startUpdatingLocation];
        [[LocationManager manager] didUpdateLocationsWithCompletion:^(CLLocationDegrees latitude, CLLocationDegrees longitude) {
            AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
            NSString *url = [NSString stringWithFormat:@"%@/save_longlat", PHBaseNewURL];
            NSDictionary *parameters = @{@"fb_id" : self.sharedData.fb_id,
                                         @"longitude" : [NSString stringWithFormat:@"%f", longitude],
                                         @"latitude" : [NSString stringWithFormat:@"%f", latitude]};
            
            [manager POST:url parameters:parameters success:nil failure:nil];
        }];
    }
    
    [FBSDKAppEvents activateApp];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [City retrieveCitiesWithCompletionHandler:^(NSArray *cities, NSInteger statusCode, NSError *error) {
            if (cities && cities.count > 0) {
                [City archiveCities:cities];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SELECTED_CITY"
                                                                    object:nil];
            }
        }];
    });
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs removeObjectForKey:@"temp_da_list"];
    [prefs synchronize];
}

- (BOOL)application:(UIApplication *)application
continueUserActivity:(NSUserActivity *)userActivity
 restorationHandler:(void (^)(NSArray *restorableObjects))restorationHandler {

    if (userActivity.activityType == NSUserActivityTypeBrowsingWeb) {
        NSURL *url = userActivity.webpageURL;
        if(contains(url.absoluteString,@"jiggie://"))
        {
            if(self.sharedData.isLoggedIn)
            {
                NSDictionary *dict = [self.sharedData parseQueryString:[url query]];
                if(dict[@"af_sub2"])
                {
                    self.sharedData.cEventId_Feed = dict[@"af_sub2"];
                    self.sharedData.cEventId_Modal = dict[@"af_sub2"];
                    
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:@"SHOW_EVENT_DETAIL"
                     object:self];
                }
            }
        }
    }
    return YES;
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
                 postNotificationName:@"SHOW_EVENT_DETAIL"
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
    
    NSString *urlToLoad = [NSString stringWithFormat:@"%@/apntoken/%@/%@",PHBaseNewURL,self.sharedData.fb_id,self.sharedData.apnToken];
    
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
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 &&
        [[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
                                                                                             |UIRemoteNotificationTypeSound
                                                                                             |UIRemoteNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    } else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }

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

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if(!self.sharedData.isLoggedIn)
    {
        return;
    }
    
    NSLog(@"APS PAYLOAD : %@", userInfo);
    
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
        if([[userInfo objectForKey:@"type"]  isEqualToString:@"general"])
        {
            // app was just brought from background to foreground
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"SHOW_EVENTS"
             object:self];
            
        } else if([[userInfo objectForKey:@"type"]  isEqualToString:@"event"])
        {
            self.sharedData.cEventId_Feed = [userInfo objectForKey:@"event_id"];
            self.sharedData.cEventId_Modal = [userInfo objectForKey:@"event_id"];
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"SHOW_EVENT_DETAIL"
             object:self];
         
        } else if([[userInfo objectForKey:@"type"]  isEqualToString:@"match"])
        {
            // app was just brought from background to foreground
            self.sharedData.fromMailId = [userInfo objectForKey:@"fromFBId"];
            self.sharedData.fromMailName = [userInfo objectForKey:@"fromName"];
            [self goToMessages];
            
        } else if([[userInfo objectForKey:@"type"]  isEqualToString:@"message"])
        {
            // app was just brought from background to foreground
            self.sharedData.fromMailId = [userInfo objectForKey:@"fromFBId"];
            self.sharedData.fromMailName = [userInfo objectForKey:@"fromName"];
            [self goToMessages];
            
        } else if([[userInfo objectForKey:@"type"]  isEqualToString:@"social"])
        {
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"SHOW_FEED"
             object:self];
            
        } else if([[userInfo objectForKey:@"type"]  isEqualToString:@"chat"])
        {
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"SHOW_CHAT"
             object:self];
        }
    }
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
- (void)onConversionDataReceived:(NSDictionary*) installData {
    
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
    
    
    // Track Mixpanel Install
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![defaults objectForKey:@"FIRST_RUN"])
    {
        NSString *media_source = self.sharedData.appsFlyerDict[@"media_source"];
        NSString *campaign = self.sharedData.appsFlyerDict[@"campaign"];
        NSString *installType = self.sharedData.appsFlyerDict[@"af_status"];
        
        NSDictionary *dict = @{@"AFmedia_source": media_source,
                               @"AFcampaign": campaign,
                               @"AFinstall_type": installType};
        [[AnalyticManager sharedManager] trackMixPanelWithDict:@"Install" withDict:dict];
        
        [defaults setValue:@"YES" forKey:@"FIRST_RUN"];
        [defaults synchronize];
    }
}

- (void)onConversionDataRequestFailure:(NSError *)error {
    
    NSLog(@"Failed to get data from AppsFlyer's server: %@",[error localizedDescription]);
    
    // Track Mixpanel Install
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![defaults objectForKey:@"FIRST_RUN"])
    {
        [self.sharedData.appsFlyerDict removeAllObjects];
        [self.sharedData.appsFlyerDict setObject:@"organic" forKey:@"media_source"];
        [self.sharedData.appsFlyerDict setObject:@"organic" forKey:@"campaign"];
        [self.sharedData.appsFlyerDict setObject:@"organic" forKey:@"af_status"];
        
        NSString *media_source = @"organic";
        NSString *campaign = @"organic";
        NSString *installType = @"organic";
        
        NSDictionary *dict = @{@"AFmedia_source": media_source,
                               @"AFcampaign": campaign,
                               @"AFinstall_type": installType};
        [[AnalyticManager sharedManager] trackMixPanelWithDict:@"Install" withDict:dict];
        
        [defaults setValue:@"YES" forKey:@"FIRST_RUN"];
        [defaults synchronize];
    }
}

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
    
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
//    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    // use this code on versioned models:
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Jiggie" ofType:@"momd"];
    NSURL *momURL = [NSURL fileURLWithPath:path];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Jiggie.sqlite"]];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible
         * The schema for the persistent store is incompatible with current managed object model
         Check the error message to determine what the actual problem was.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

@end
