//
//  Member.m
//  Jiggie
//
//  Created by Mohammad Nuruddin Effendi on 6/14/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "Member.h"
#import "Firebase.h"

@implementation Member

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"fbId" : @"fb_id",
             @"name" : @"name",
             @"avatarURL" : @"propic"};
}

+ (FIRDatabaseReference *)reference {
    return [[FIRDatabase database] referenceWithPath:@"member"];
}

@end
