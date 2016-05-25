//
//  MemberInfo.m
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 5/25/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "MemberInfo.h"
#import "Mantle.h"

@interface MemberInfo () <MTLJSONSerializing>

@end

@implementation MemberInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"about" : @"about",
             @"age" :@"age",
             @"firstName" : @"first_name",
             @"lastName" : @"last_name",
             @"photos" : @"photos"};
}

+ (void)retrieveMemberInfoWithCompletionHandler:(MemberInfoCompletionHandler)completion {
    SharedData *sharedData = [SharedData sharedInstance];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *urlToLoad = [NSString stringWithFormat:@"%@/memberinfo/%@", PHBaseNewURL, sharedData.fb_id];
    [manager GET:urlToLoad parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        MemberInfo *memberInfo = [MTLJSONAdapter modelOfClass:[MemberInfo class]
                                           fromJSONDictionary:responseObject[@"data"][@"memberinfo"]
                                                        error:&error];
        
        if (completion) {
            if (memberInfo) {
                completion(memberInfo,
                           operation.response.statusCode,
                           nil);
            } else {
                completion(nil,
                           operation.response.statusCode,
                           error);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil,
                       operation.response.statusCode,
                       error);
        }
    }];
}

@end
