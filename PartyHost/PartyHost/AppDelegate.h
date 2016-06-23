//
//  AppDelegate.h
//  PartyHost
//
//  Created by Sunny Clark on 12/26/14.
//  Copyright (c) 2014 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
//#import <FacebookSDK/FacebookSDK.h>
#import "Messages.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
//#import <Appsee/Appsee.h>
#import "Mixpanel.h"
#import "AppsFlyerTracker.h"
//#import "TSTapstream.h"
#import "RFRateMe.h"
#import "SetupView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,AppsFlyerTrackerDelegate> {
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SharedData    *sharedData;

@property (strong, nonatomic) NSString      *apnToken;
@property (strong, nonatomic) id<GAITracker> tracker;
@property (strong, nonatomic) UIButton      *btnNotify;
@property (copy, nonatomic) NSString      *roomId;

@property (assign, nonatomic) BOOL      inAskingAPNMode;
@property (assign, nonatomic) BOOL      isShowNotification;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(BOOL)notificationServicesEnabled;


@end

