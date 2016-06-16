//
//  RoomInfo.m
//  Jiggie
//
//  Created by Mohammad Nuruddin Effendi on 6/16/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "RoomGroupInfo.h"

@implementation RoomGroupInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"name" : @"name",
             @"avatarURL" : @"avatar",
             @"lastMessage" : @"last_message",
             @"updatedAt" : @"updatedAt"};
}

@end
