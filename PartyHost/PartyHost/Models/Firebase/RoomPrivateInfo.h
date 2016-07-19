//
//  RoomIndividualInfo.h
//  Jiggie
//
//  Created by Mohammad Nuruddin Effendi on 6/16/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"

@interface RoomPrivateInfo : MTLModel <MTLJSONSerializing>

@property(copy, nonatomic, readonly) NSString *event;
@property(copy, nonatomic, readonly) NSString *identifier;
@property(copy, nonatomic, readonly) NSString *lastMessage;
@property(assign, nonatomic, readonly) NSTimeInterval updatedAt;
@property(strong, nonatomic, readonly) NSDictionary *unreads;
@property(strong, nonatomic, readonly) NSDictionary *members;

+ (NSString *)getFriendFbIdFromIdentifier:(NSString *)identifier
                                     fbId:(NSString *)currentFbId;

+ (NSString *)getPrivateMessageIdWithsenderId:(NSString *)senderId
                                andReceiverId:(NSString *)receiverId;

@end
