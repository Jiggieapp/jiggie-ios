//
//  Room.m
//  Jiggie
//
//  Created by Mohammad Nuruddin Effendi on 6/14/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "Room.h"
#import "Firebase.h"

@implementation Room

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"name" : @"name",
             @"type" : @"type"};
}

+ (NSValueTransformer *)typeJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{@(1): @(RoomTypePrivate),
                                                                           @(2): @(RoomTypeGroup)}];
}

+ (FIRDatabaseReference *)reference {
    return [[FIRDatabase database] referenceWithPath:@"room"];
}

+ (FIRDatabaseReference *)referenceWithRoomId:(NSString *)roomId {
    return [[Room reference] child:roomId];
}

@end
