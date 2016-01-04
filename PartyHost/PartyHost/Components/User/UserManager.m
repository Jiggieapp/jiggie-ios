//
//  UserManager.m
//  Jiggie
//
//  Created by Setiady Wiguna on 12/28/15.
//  Copyright © 2015 Sunny Clark. All rights reserved.
//

#import "UserManager.h"
#import "Event.h"
#import "EventDetail.h"
#import "Chat.h"
#import "BaseModel.h"
#import "AppDelegate.h"

@implementation UserManager

static UserManager *_sharedManager = nil;

+ (UserManager *)sharedManager {
    @synchronized([UserManager class])
    {
        if (!_sharedManager) {
            _sharedManager = [[UserManager alloc] init];
        }
        return _sharedManager;
    }
    
    return nil;
}

+ (void)saveUserSetting:(NSDictionary *)dict {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:dict forKey:@"user.setting"];
    [prefs synchronize];
}

+ (BOOL)updateLocalSetting {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary *userSetting = [prefs objectForKey:@"user.setting"];
    
    if (userSetting && userSetting != nil) {
        SharedData *sharedData = [SharedData sharedInstance];
        [sharedData loadSettingsResponse:userSetting];
        
        return YES;
    }
    return NO;
}

- (void)clearAllUserData {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs removeObjectForKey:@"user.setting"];
    [prefs synchronize];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *globalManagedObjectContext = [appDelegate managedObjectContext];
    
    NSArray *fetchChats = [BaseModel fetchManagedObject:globalManagedObjectContext
                                               inEntity:NSStringFromClass([Chat class])
                                           andPredicate:nil];

    for (Chat *fetchChat in fetchChats) {
        [globalManagedObjectContext deleteObject:fetchChat];
    }
    
    NSArray *fetchEvents = [BaseModel fetchManagedObject:globalManagedObjectContext
                                                inEntity:NSStringFromClass([Event class])
                                            andPredicate:nil];
    
    for (Chat *fetchEvent in fetchEvents) {
        [globalManagedObjectContext deleteObject:fetchEvent];
    }
    
    NSArray *fetchEventDetails = [BaseModel fetchManagedObject:globalManagedObjectContext
                                               inEntity:NSStringFromClass([EventDetail class])
                                           andPredicate:nil];
    
    for (Chat *fetchEventDetail in fetchEventDetails) {
        [globalManagedObjectContext deleteObject:fetchEventDetail];
    }
    
    NSError *error;
    if (![globalManagedObjectContext save:&error]) NSLog(@"Error: %@", [error localizedDescription]);
}

@end
