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

+ (void)sendMessageWithRoomId:(NSString *)roomId
                     senderId:(NSString *)fbId
                         text:(NSString *)text {
    FIRDatabaseReference *reference = [[Message referenceWithRoomId:roomId] childByAutoId];
    NSDictionary *parameters = @{@"created_at" : [FIRServerValue timestamp],
                                 @"fb_id" : fbId,
                                 @"message" : text};
    
    [reference setValue:parameters withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (!error) {
            FIRDatabaseReference *reference = [[[Room reference] child:roomId] child:@"info"];
            NSDictionary *parameters = @{@"last_message" : text,
                                         @"updated_at" : [FIRServerValue timestamp]};
            
            [reference updateChildValues:parameters];
        }
    }];
}

@end
