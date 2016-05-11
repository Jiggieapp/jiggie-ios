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

+ (void)enableSocialFeed:(BOOL)enabled withCompletionHandler:(MatchFeedCompletionHandler)completion {
    SharedData *sharedData = [SharedData sharedInstance];
    NSString *matchMe = enabled ? @"yes" : @"no";
    AFHTTPRequestOperationManager *manager = [sharedData getOperationManager];
    NSString *url = [NSString stringWithFormat:@"%@/partyfeed/settings/%@/%@", PHBaseNewURL, sharedData.fb_id, matchMe];
    
    [manager GET:url parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            completion(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(error);
        }
    }];
}

@end
