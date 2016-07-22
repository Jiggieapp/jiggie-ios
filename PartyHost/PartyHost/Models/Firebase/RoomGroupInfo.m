//
//  RoomInfo.m
//  Jiggie
//
//  Created by Mohammad Nuruddin Effendi on 6/16/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "RoomGroupInfo.h"
#import "Firebase.h"
#import "Room.h"

@implementation RoomGroupInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"event" : @"event",
             @"avatarURL" : @"avatar",
             @"identifier" : @"identifier",
             @"lastMessage" : @"last_message",
             @"updatedAt" : @"updated_at",
             @"unreads" : @"unread",
             @"members" : @"members"};
}

+ (void)retrieveRoomInfoWithId:(NSString *)roomId andCompletionHandler:(RoomInfoCompletionHandler)completion {
    FIRDatabaseReference *reference = [[Room reference] child:roomId];
    
    [reference observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (![snapshot.value isEqual:[NSNull null]]) {
            NSError *error;
            RoomGroupInfo *roomInfo = [MTLJSONAdapter modelOfClass:[RoomGroupInfo class]
                                                fromJSONDictionary:[snapshot.value objectForKey:@"info"]
                                                             error:&error];
            
            if (completion) {
                completion(roomInfo, error);
            }
        } else {
            if (completion) {
                completion(nil, nil);
            }
        }
        
    }];
}

@end
