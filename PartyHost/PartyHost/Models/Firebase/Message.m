//
//  Message.m
//  Jiggie
//
//  Created by Mohammad Nuruddin Effendi on 6/14/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "Message.h"
#import "Room.h"
#import "Firebase.h"

@implementation Message

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"fbId" : @"fb_id",
             @"text" : @"message",
             @"createdAt" : @"created_at"};
}

+ (FIRDatabaseReference *)reference {
    return [[FIRDatabase database] referenceWithPath:@"messages"];
}

+ (FIRDatabaseReference *)referenceWithRoomId:(NSString *)roomId {
    return [[Message reference] child:roomId];
}

+ (void)retrieveMessagesWithRoomId:(NSString *)roomId andCompletionHandler:(MessagesCompletionHandler)completion {
    FIRDatabaseReference *reference = [[Message reference] child:roomId];
    
    [reference observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSMutableArray *messages = [NSMutableArray arrayWithCapacity:snapshot.childrenCount];
        NSError *error;
        
        for (FIRDataSnapshot *child in snapshot.children) {
            Message *message = [MTLJSONAdapter modelOfClass:[Message class]
                                         fromJSONDictionary:child.value
                                                      error:&error];
            
            [messages addObject:message];
        }
        
        if (completion) {
            completion(messages, error);
        }
    }];
}

+ (void)sendMessageWithRoomId:(NSString *)roomId
                     senderId:(NSString *)fbId
                      members:(NSDictionary *)members
                         text:(NSString *)text {
    FIRDatabaseReference *reference = [[Message referenceWithRoomId:roomId] childByAutoId];
    NSDictionary *parameters = @{@"created_at" : [FIRServerValue timestamp],
                                 @"fb_id" : fbId,
                                 @"message" : text};
    
    [reference setValue:parameters withCompletionBlock:^(NSError * _Nullable error,
                                                         FIRDatabaseReference * _Nonnull ref) {
        if (!error) {
            FIRDatabaseReference *reference = [[[Room reference] child:roomId] child:@"info"];
            NSMutableDictionary *parameters = [NSMutableDictionary
                                               dictionaryWithDictionary:@{@"last_message" : text,
                                                                          @"updated_at" : [FIRServerValue timestamp]}];
            
            [reference updateChildValues:parameters];
            
            reference = [[Room membersReference] child:roomId];
            
            [reference updateChildValues:members];
        }
    }];
}

@end
