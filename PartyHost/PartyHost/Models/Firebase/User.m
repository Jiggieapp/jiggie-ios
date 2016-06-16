//
//  Member.m
//  Jiggie
//
//  Created by Mohammad Nuruddin Effendi on 6/14/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "User.h"
#import "Firebase.h"

@implementation User

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"fbId" : @"fb_id",
             @"name" : @"name",
             @"avatarURL" : @"avatar"};
}

+ (FIRDatabaseReference *)reference {
    return [[FIRDatabase database] referenceWithPath:@"users"];
}

+ (void)retrieveUserInfoWithFbId:(NSString *)fbId andCompletionHandler:(UserCompletionHandler)completion {
    FIRDatabaseReference *reference = [[User reference] child:fbId];
    
    [reference observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSError *error;
        User *user = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:snapshot.value error:&error];
        
        if (completion) {
            completion(user, error);
        }
    }];
}

@end
