//
//  MemberInfoEvent.m
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 5/26/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "MemberInfoEvent.h"
#import "Mantle.h"

@interface MemberInfoEvent () <MTLJSONSerializing>

@end

@implementation MemberInfoEvent

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"eventId" : @"event_id",
             @"title" : @"title",
             @"photos" : @"photos"};
}

@end
