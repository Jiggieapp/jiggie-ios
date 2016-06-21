//
//  Room.h
//  Jiggie
//
//  Created by Mohammad Nuruddin Effendi on 6/14/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"

typedef enum {
    RoomTypePrivate,
    RoomTypeGroup
} RoomType;

typedef void (^RoomsCompletionHandler)(NSArray *rooms,
                                       NSError *error);
typedef void (^ClearChatCompletionHandler)(NSError *error);

@class FIRDatabaseReference;
@interface Room : MTLModel <MTLJSONSerializing>

@property(assign, nonatomic, readonly) RoomType type;
@property(strong, nonatomic, readonly) NSDictionary *info;

+ (FIRDatabaseReference *)reference;
+ (FIRDatabaseReference *)membersReference;
+ (FIRDatabaseReference *)referenceWithRoomId:(NSString *)roomId;

+ (void)retrieveRoomsWithFbId:(NSString *)fbId
         andCompletionHandler:(RoomsCompletionHandler)completion;
+ (NSArray *)retrieveRoomsInfoWithRooms:(NSArray *)rooms;

+ (void)clearChatFromRoomId:(NSString *)roomId
                   withFbId:(NSString *)fbId
       andCompletionHandler:(ClearChatCompletionHandler)completion;

+ (void)blockPrivateChatWithRoomId:(NSString *)roomId
              andCompletionHandler:(ClearChatCompletionHandler)completion;

+ (void)blockRoomWithRoomId:(NSString *)roomId
                   withFbId:(NSString *)fbId
       andCompletionHandler:(ClearChatCompletionHandler)completion;

@end
