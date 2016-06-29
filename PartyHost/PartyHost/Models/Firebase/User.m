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
             @"firstName" : @"first_name",
             @"lastName" : @"last_name",
             @"avatarURL" : @"avatar"};
}

+ (FIRDatabaseReference *)reference {
    return [[FIRDatabase database] referenceWithPath:@"users"];
}

+ (void)retrieveUserInfoWithFbId:(NSString *)fbId andCompletionHandler:(UserCompletionHandler)completion {
    FIRDatabaseReference *reference = [[User reference] child:fbId];
    
    [reference observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSError *error;
        
        if (![snapshot.value isEqual:[NSNull null]]) {
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:snapshot.value];
            [dictionary setObject:snapshot.key forKey:@"fb_id"];
            
            User *user = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:dictionary error:&error];
            
            if (completion) {
                completion(user, error);
            }
        } else {
            if (completion) {
                completion(nil, nil);
            }
        }
        
    }];
}

@end