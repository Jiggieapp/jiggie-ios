//
//  Friend.h
//  Jiggie
//
//  Created by Setiady Wiguna on 5/10/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "Mantle.h"

typedef enum : NSUInteger {
    FriendStateConnected,
    FriendStateNotConnected
} FriendState;

typedef void (^FacebookFriendCompletionHandler)(NSArray *friendIDs,
                                                NSError *error);

typedef void (^SocialFriendCompletionHandler)(NSArray *friends,
                                              NSInteger statusCode,
                                              NSError *error);
typedef void (^ConnectFriendCompletionHandler)(BOOL success,
                                               NSString *message,
                                               NSInteger statusCode,
                                               NSError *error);

@interface Friend : MTLModel <MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSString *fbID;
@property (copy, nonatomic, readonly) NSString *imgURL;
@property (copy, nonatomic, readonly) NSString *firstName;
@property (copy, nonatomic, readonly) NSString *lastName;
@property (copy, nonatomic, readonly) NSString *about;
@property (assign, nonatomic, readonly) FriendState connectState;

+ (NSString *)pathToArchive;
+ (void)archiveObject:(NSArray *)object;
+ (NSArray *)unarchiveObject;
+ (void)removeArchivedObject;

+ (void)retrieveFacebookFriendsWithCompletionHandler:(FacebookFriendCompletionHandler)completion;
+ (void)generateSocialFriend:(NSArray *)friendIDs WithCompletionHandler:(SocialFriendCompletionHandler)completion;
+ (void)connectFriend:(NSArray *)friendIDs WithCompletionHandler:(ConnectFriendCompletionHandler)completion;

@end
