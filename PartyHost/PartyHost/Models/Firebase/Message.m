//
//  Message.m
//  Jiggie
//
//  Created by Mohammad Nuruddin Effendi on 6/14/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "Message.h"
#import "Firebase.h"

@implementation Message

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"fbId" : @"fb_id",
             @"text" : @"message",
             @"createdAt" : @"created_at"};
}

+ (FIRDatabaseReference *)reference {
    return [[FIRDatabase database] referenceWithPath:@"message"];
}

+ (FIRDatabaseReference *)referenceWithFbId:(NSString *)fbId {
    return [[Message reference] child:fbId];
}

@end
