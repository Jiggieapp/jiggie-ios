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

@interface Friend ()

@property (assign, nonatomic) FriendState connectState;

@end

@implementation Friend

- (void)setFriendConnectState:(FriendState *)connectState {
    self.connectState = connectState;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"fbID" : @"fb_id",
             @"imgURL" : @"img_url",
             @"firstName" : @"first_name",
             @"lastName" : @"last_name",
             @"about" : @"about",
             @"connectState" : @"is_connect"};
}

+ (NSValueTransformer *)connectStateJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{@(1): @(FriendStateConnected),
                                                                           @(0): @(FriendStateNotConnected)}];
}

#pragma mark - Archive
+ (NSString *)pathToArchive {
    return [[[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                     inDomains:NSUserDomainMask] lastObject]
             URLByAppendingPathComponent:@"friend.model"] path];
}

+ (void)archiveObject:(NSArray *)object {
    [NSKeyedArchiver archiveRootObject:object
                                toFile:[Friend pathToArchive]];
}

+ (NSArray *)unarchiveObject {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[Friend pathToArchive]];
}

+ (void)removeArchivedObject {
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:[Friend pathToArchive] error:&error];
}

#pragma mark - API 
+ (void)retrieveFacebookFriendsWithCompletionHandler:(FacebookFriendCompletionHandler)completion {
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"me/friends?limit=5000"
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

+ (void)generateSocialFriend:(NSArray *)friendIDs WithCompletionHandler:(SocialFriendCompletionHandler)completion {
    SharedData *sharedData = [SharedData sharedInstance];
    AFHTTPRequestOperationManager *manager = [sharedData getOperationManager];
    NSString *url = [NSString stringWithFormat:@"%@/credit/list_social_friends/", PHBaseNewURL];
    
    NSDictionary *params = @{@"fb_id":sharedData.fb_id,
                             @"friends_fb_id":friendIDs};
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        NSArray *friends = [MTLJSONAdapter modelsOfClass:[Friend class]
                                           fromJSONArray:responseObject[@"data"][@"list_social_friends"]
                                                   error:&error];
        
        if (completion) {
            completion(friends,
                       operation.response.statusCode,
                       nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil,
                       operation.response.statusCode,
                       error);
        }
    }];
}

+ (void)connectFriend:(NSArray *)friendIDs WithCompletionHandler:(ConnectFriendCompletionHandler)completion {
    SharedData *sharedData = [SharedData sharedInstance];
    AFHTTPRequestOperationManager *manager = [sharedData getOperationManager];
    NSString *url = [NSString stringWithFormat:@"%@/credit/social_friends/", PHBaseNewURL];
    
    NSDictionary *params = @{@"fb_id":sharedData.fb_id,
                             @"friends_fb_id":friendIDs};
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try {
            BOOL success = [responseObject[@"response"] boolValue];
            
            NSString *msg = responseObject[@"msg"];
            if (completion) {
                completion(success, msg, operation.response.statusCode, nil);
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(NO, nil, operation.response.statusCode, error);
        }
    }];
}

@end
