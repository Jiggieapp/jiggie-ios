//
//  Message.h
//  Jiggie
//
//  Created by Mohammad Nuruddin Effendi on 6/14/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"

typedef void (^MessagesCompletionHandler)(NSArray *messages,
                                          NSError *error);

@class FIRDatabaseReference;
@interface Message : MTLModel <MTLJSONSerializing>

@property(copy, nonatomic, readonly) NSString *fbId;
@property(copy, nonatomic, readonly) NSString *text;
@property(assign, nonatomic, readonly) NSTimeInterval createdAt;

+ (FIRDatabaseReference *)reference;
+ (FIRDatabaseReference *)referenceWithRoomId:(NSString *)roomId;

+ (void)retrieveMessagesWithRoomId:(NSString *)roomId
              andCompletionHandler:(MessagesCompletionHandler)completion;

+ (void)sendMessageWithRoomId:(NSString *)roomId
                     senderId:(NSString *)fbId
                      text:(NSString *)text;

@end
