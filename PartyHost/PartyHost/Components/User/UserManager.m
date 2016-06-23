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

+ (NSDictionary *)loadUserTicketInfo {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary *UserInfo = [prefs objectForKey:@"user.ticketInfo"];
    
    SharedData *sharedData = [SharedData sharedInstance];
    if (UserInfo == nil) {
        NSString *name = [NSString stringWithFormat:@"%@ %@", sharedData.userDict[@"first_name"], sharedData.userDict[@"last_name"]];
        UserInfo = @{@"name":name,
                     @"email":sharedData.userDict[@"email"],
                     @"dial_code":@"",
                     @"phone":@"",
                     @"identity_id":@""};
        
    } else if ([UserInfo[@"name"] isEqualToString:@""] &&
               [UserInfo[@"email"] isEqualToString:@""]) {
        NSString *name = [NSString stringWithFormat:@"%@ %@", sharedData.userDict[@"first_name"], sharedData.userDict[@"last_name"]];
        UserInfo = @{@"name":name,
                     @"email":sharedData.userDict[@"email"],
                     @"dial_code":@"",
                     @"phone":@"",
                     @"identity_id":@""};
    }
    return UserInfo;
}

+ (void)saveUserTicketInfo:(NSDictionary *)dict {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:dict forKey:@"user.ticketInfo"];
    [prefs synchronize];
}

+ (void)clearUserTicketInfo {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs removeObjectForKey:@"user.ticketInfo"];
    [prefs synchronize];
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
    [prefs removeObjectForKey:@"INVITE_CREDIT"];
    [prefs removeObjectForKey:@"user.setting"];
    [prefs removeObjectForKey:@"IS_ALREADY_MIGRATED_TO_FIREBASE"];
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

#pragma mark - Tags
- (void)loadAllTags {
    SharedData *sharedData = [SharedData sharedInstance];
    AFHTTPRequestOperationManager *manager = [sharedData getOperationManager];
    NSString *url = [Constants userTagListURL];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSInteger responseStatusCode = operation.response.statusCode;
         if (responseStatusCode != 200) {
             return;
         }
         
         NSString *responseString = operation.responseString;
         NSError *error;
         
         NSDictionary *json = (NSDictionary *)[NSJSONSerialization
                                               JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]
                                               options:kNilOptions
                                               error:&error];
         dispatch_async(dispatch_get_main_queue(), ^{
             @try {
                 
                 NSDictionary *data = [json objectForKey:@"data"];
                 NSArray *tagslist = [data objectForKey:@"tagslist"];

                 if (tagslist && tagslist != nil && tagslist.count > 0) {
                     NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                     [prefs setObject:tagslist forKey:@"all_tags"];
                     [prefs synchronize];
                 }
             }
             @catch (NSException *exception) {
                 
             }
             @finally {
                 
             }
         });

     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR :: %@",error);
     }];
}

+ (NSArray *)allTags {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSArray *userSetting = [prefs objectForKey:@"all_tags"];
    return userSetting;
}

+ (UIColor *)colorForTag:(NSString *)tagName {
    NSArray *allTags = [self allTags];
    for (NSDictionary *tag in allTags) {
        NSString *name = [tag objectForKey:@"name"];
        if ([name isEqualToString:tagName]) {
            NSString *hexColor = [tag objectForKey:@"color"];
            return [UIColor colorFromHexCode:hexColor];
        }
    }
    return [UIColor phBlueColor];
}

@end
