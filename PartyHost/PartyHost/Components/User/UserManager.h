//
//  UserManager.h
//  Jiggie
//
//  Created by Setiady Wiguna on 12/28/15.
//  Copyright © 2015 Sunny Clark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserManager : NSObject

+ (UserManager *)sharedManager;

+ (void)saveUserSetting:(NSDictionary *)dict;
+ (BOOL)updateLocalSetting;

- (void)clearAllUserData;

@end