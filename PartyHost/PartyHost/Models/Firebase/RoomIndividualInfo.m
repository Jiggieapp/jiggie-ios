//
//  RoomIndividualInfo.m
//  Jiggie
//
//  Created by Mohammad Nuruddin Effendi on 6/16/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "RoomIndividualInfo.h"

@implementation RoomIndividualInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"event" : @"event",
             @"identifier" : @"identifier",
             @"lastMessage" : @"last_message",
             @"updatedAt" : @"updatedAt"};
}

@end
