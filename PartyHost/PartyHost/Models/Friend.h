//
//  Friend.h
//  Jiggie
//
//  Created by Setiady Wiguna on 5/10/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "MTLModel.h"

typedef void (^FacebookFriendCompletionHandler)(NSArray *friendIDs,
                                                NSError *error);

@interface Friend : MTLModel

+ (void)retrieveFacebookFriendsWithCompletionHandler:(FacebookFriendCompletionHandler)completion;

@end
