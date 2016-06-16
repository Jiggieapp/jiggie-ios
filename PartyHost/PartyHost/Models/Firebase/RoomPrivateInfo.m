//
//  RoomIndividualInfo.m
//  Jiggie
//
//  Created by Mohammad Nuruddin Effendi on 6/16/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "RoomPrivateInfo.h"

@implementation RoomPrivateInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"event" : @"event",
             @"identifier" : @"identifier",
             @"lastMessage" : @"last_message",
             @"updatedAt" : @"updated_at"};
}

+ (NSString *)getFriendFbIdFromIdentifier:(NSString *)identifier fbId:(NSString *)currentFbId {
    NSArray *identifiers = [identifier componentsSeparatedByString:@"_"];
    
    for (NSString *identifier in identifiers) {
        if (![identifier isEqualToString:currentFbId]) {
            return identifier;
        }
    }
    
    return identifiers[0];
}

+ (NSString *)getPrivateMessageIdWithsenderId:(NSString *)senderId andReceiverId:(NSString *)receiverId {
    NSString *privateMessageId = @"";
    
    if ([senderId compare:receiverId
                  options:NSCaseInsensitiveSearch] == NSOrderedAscending) {
        privateMessageId = [NSString stringWithFormat:@"%@_%@", senderId, receiverId];
    } else {
        privateMessageId = [NSString stringWithFormat:@"%@_%@", receiverId, senderId];
    }
    
    return privateMessageId;
}

@end
