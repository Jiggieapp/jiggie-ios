//
//  Room.m
//  Jiggie
//
//  Created by Mohammad Nuruddin Effendi on 6/14/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "Room.h"

@implementation Room

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"name" : @"name",
             @"type" : @"type"};
}

+ (NSValueTransformer *)typeJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{@(1): @(RoomTypePrivate),
                                                                           @(2): @(RoomTypeGroup)}];
}

@end
