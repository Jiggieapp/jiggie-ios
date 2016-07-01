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

+ (void)retrieveRoomsWithFbId:(NSString *)fbId andCompletionHandler:(RoomsCompletionHandler)completion {
    FIRDatabaseReference *reference = [Room membersReference];
    FIRDatabaseQuery *query = [[reference queryOrderedByChild:fbId] queryEqualToValue:[NSNumber numberWithBool:YES]];
    
    [query observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshotMember) {
        if (![snapshotMember.value isEqual:[NSNull null]]) {
            NSArray *keys = [snapshotMember.value allKeys];
            NSMutableArray *rooms = [NSMutableArray arrayWithCapacity:keys.count];
            
            [[NSUserDefaults standardUserDefaults] setObject:keys forKey:@"FIREBASE_ROOM_KEYS"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            for (NSString *key in keys) {
                FIRDatabaseReference *reference = [[Room reference] child:key];
                [reference observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    
                    NSError *error;
                    
                    if (![snapshot.value isEqual:[NSNull null]]) {
                        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:snapshot.value];
                        [[dictionary objectForKey:@"info"] setObject:snapshot.key forKey:@"identifier"];
                        [[dictionary objectForKey:@"info"] setObject:[snapshotMember.value objectForKey:key] forKey:@"members"];
                        
                        NSArray *currentKeys = [[NSUserDefaults standardUserDefaults]
                                                objectForKey:@"FIREBASE_ROOM_KEYS"];
                        
                        for (Room *room in rooms) {
                            if ([room.info[@"identifier"] isEqualToString:dictionary[@"info"][@"identifier"]]) {
                                [rooms removeObject:room];
                                break;
                            }
                        }
                        
                        if ([currentKeys containsObject:snapshot.key]) {
                            Room *room = [MTLJSONAdapter modelOfClass:[Room class] fromJSONDictionary:dictionary error:&error];
                            
                            [rooms addObject:room];
                        }
                        
                        if (rooms.count >= keys.count) {
                            if (completion) {
                                completion(rooms, error);
                            }
                        }
                    }
                }];
            }
        } else {
            if (completion) {
                completion(nil, nil);
            }
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
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO];
    NSArray *sortedRoomsInfo = [roomsInfo sortedArrayUsingDescriptors:@[descriptor]];
    
    return sortedRoomsInfo;
}

+ (void)clearChatFromFriendFbId:(NSString *)friendFbId withFbId:(NSString *)fbId andCompletionHandler:(ClearChatCompletionHandler)completion {
    SharedData *sharedData = [SharedData sharedInstance];
    AFHTTPRequestOperationManager *manager = [sharedData getOperationManager];
    
    NSString *url = [NSString stringWithFormat:@"%@/firebase/delete_chat", PHBaseNewURL];
    NSDictionary *params = @{@"fb_id" : fbId,
                             @"member_fb_id" : friendFbId};
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            completion(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(error);
        }
    }];
}

+ (void)blockRoomWithRoomId:(NSString *)roomId withFbId:(NSString *)fbId andCompletionHandler:(ClearChatCompletionHandler)completion {
    SharedData *sharedData = [SharedData sharedInstance];
    AFHTTPRequestOperationManager *manager = [sharedData getOperationManager];
    
    NSString *friendFbId = [roomId rangeOfString:@"_"].location != NSNotFound ? [RoomPrivateInfo getFriendFbIdFromIdentifier:roomId fbId:sharedData.fb_id] : @"";
    NSString *url = [NSString stringWithFormat:@"%@/firebase/block_chat", PHBaseNewURL];
    NSDictionary *params = @{@"fb_id" : fbId,
                             @"member_fb_id" : friendFbId,
                             @"room_id" : roomId,
                             @"type" : [roomId rangeOfString:@"_"].location != NSNotFound ? @"1" : @"2"};
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            NSMutableArray *currentRoomKeys = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"FIREBASE_ROOM_KEYS"]];
            [currentRoomKeys removeObject:roomId];
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:currentRoomKeys]
                                                      forKey:@"FIREBASE_ROOM_KEYS"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            completion(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(error);
        }
    }];
}

@end
