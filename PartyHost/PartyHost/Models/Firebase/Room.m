//
//  Room.m
//  Jiggie
//
//  Created by Mohammad Nuruddin Effendi on 6/14/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "Room.h"
#import "Firebase.h"
#import "Mantle.h"
#import "RoomGroupInfo.h"
#import "RoomPrivateInfo.h"

@implementation Room

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"info" : @"info",
             @"type" : @"type"};
}

+ (NSValueTransformer *)typeJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{@(1): @(RoomTypePrivate),
                                                                           @(2): @(RoomTypeGroup)}];
}

+ (FIRDatabaseReference *)reference {
    return [[FIRDatabase database] referenceWithPath:@"rooms"];
}

+ (FIRDatabaseReference *)membersReference {
    return [[FIRDatabase database] referenceWithPath:@"room_members"];
}

+ (FIRDatabaseReference *)referenceWithRoomId:(NSString *)roomId {
    return [[Room reference] child:roomId];
}

+ (void)retrieveRoomsWithFbId:(NSString *)fbId andCompletionHandler:(RoomsCompletionHandler)completion {
    FIRDatabaseReference *reference = [Room membersReference];
    FIRDatabaseQuery *query = [[reference queryOrderedByChild:fbId] queryEqualToValue:[NSNumber numberWithBool:YES]];
    
    [query observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSArray *keys = [snapshot.value allKeys];
        NSMutableArray *rooms = [NSMutableArray arrayWithCapacity:keys.count];
        
        for (NSString *key in keys) {
            FIRDatabaseReference *reference = [[Room reference] child:key];
            [reference observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                NSError *error;
                Room *room = [MTLJSONAdapter modelOfClass:[Room class] fromJSONDictionary:snapshot.value error:&error];
                
                [rooms addObject:room];
                
                if ([keys indexOfObject:key] == keys.count-1) {
                    if (completion) {
                        completion(rooms, error);
                    }
                }
            }];
        }
    }];
}

+ (NSArray *)retrieveRoomsInfoWithRooms:(NSArray *)rooms {
    NSMutableArray *roomsInfo = [NSMutableArray arrayWithCapacity:rooms.count];
    
    for (Room *room in rooms) {
        switch (room.type) {
            case RoomTypeGroup: {
                RoomGroupInfo *roomInfo = [MTLJSONAdapter modelOfClass:[RoomGroupInfo class] fromJSONDictionary:room.info error:nil];
                
                [roomsInfo addObject:roomInfo];
                
                break;
            }
                
            case RoomTypePrivate: {
                RoomPrivateInfo *roomInfo = [MTLJSONAdapter modelOfClass:[RoomPrivateInfo class] fromJSONDictionary:room.info error:nil];
                
                [roomsInfo addObject:roomInfo];
                
                break;
            }
        }
    }
    
    return roomsInfo;
}

@end