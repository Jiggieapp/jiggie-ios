//
//  Friend.m
//  Jiggie
//
//  Created by Setiady Wiguna on 5/10/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "Friend.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "SharedData.h"

@implementation Friend



#pragma mark - API 
+ (void)retrieveFacebookFriendsWithCompletionHandler:(FacebookFriendCompletionHandler)completion {
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"me/friends"
                                  parameters:nil
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        if (error == nil) {
            // Handle the result
            NSArray *friendList = (NSArray *)[result objectForKey:@"data"];
            NSArray *friendIDs = [friendList valueForKey:@"id"];
            
            if (completion) {
                completion(friendIDs,
                           nil);
            }
        } else {
            if (completion) {
                completion(nil,
                           error);
            }
        }
    }];
}

@end
