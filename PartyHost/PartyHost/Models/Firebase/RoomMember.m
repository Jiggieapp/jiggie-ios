//
//  RoomMember.m
//  Jiggie
//
//  Created by Mohammad Nuruddin Effendi on 6/14/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "RoomMember.h"
#import "Firebase.h"

@implementation RoomMember

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"fbId" : @"fb_id"};
}

+ (FIRDatabaseReference *)reference {
    return [[FIRDatabase database] referenceWithPath:@"roommember"];
}

+ (FIRDatabaseReference *)referenceWithRoomId:(NSString *)roomId {
    return [[RoomMember reference] child:roomId];
}

@end
