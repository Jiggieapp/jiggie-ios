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

+ (FIRDatabaseReference *)retrieveMessagesWithRoomId:(NSString *)roomId andCompletionHandler:(MessagesCompletionHandler)completion {
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
    
    return reference;
}

+ (void)hasReadMessagesInRoom:(NSString *)roomId {
    FIRDatabaseReference *reference = [[[[Room reference] child:roomId] child:@"info"] child:@"unread"];
    SharedData *sharedData = [SharedData sharedInstance];
    NSDictionary *parameters = @{sharedData.fb_id : [NSNumber numberWithInt:0]};
    
    [reference updateChildValues:parameters];
}

+ (void)sendMessageToRoomId:(NSString *)roomId withSenderId:(NSString *)senderId receiverId:(NSString *)receiverId text:(NSString *)text completionHandler:(SendMessageCompletionHandler)completion {
    SharedData *sharedData = [SharedData sharedInstance];
    AFHTTPRequestOperationManager *manager = [sharedData getOperationManager];
    
    NSString *url = [NSString stringWithFormat:@"%@/firebase/post_message", PHBaseNewURL];
    NSDictionary *params = @{@"fb_id" : senderId,
                             @"member_fb_id" : receiverId,
                             @"message" : text,
                             @"room_id" : roomId,
                             @"type" : [roomId rangeOfString:@"_"].location != NSNotFound ? @"2" : @"1"};
    
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

@end
