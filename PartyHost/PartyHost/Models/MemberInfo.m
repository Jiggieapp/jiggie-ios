//
//  MemberInfo.m
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 5/25/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "MemberInfo.h"
#import "Mantle.h"
#import "MemberInfoEvent.h"

@interface MemberInfo () <MTLJSONSerializing>

@property (copy, nonatomic) NSString *about;

@end

@implementation MemberInfo

+ (NSValueTransformer *)bookingsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[MemberInfoEvent class]];
}

+ (NSValueTransformer *)ticketsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[MemberInfoEvent class]];
}

+ (NSValueTransformer *)likesEventJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[MemberInfoEvent class]];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"fbId" : @"fb_id",
             @"about" : @"about",
             @"age" :@"age",
             @"firstName" : @"first_name",
             @"lastName" : @"last_name",
             @"photos" : @"photos",
             @"bookings" : @"list_bookings",
             @"tickets" : @"list_tickets",
             @"likesEvent" : @"likes_event"};
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

+ (void)retrieveMemberInfoWithFbId:(NSString *)fbId andCompletionHandler:(MemberInfoCompletionHandler)completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *urlToLoad = [NSString stringWithFormat:@"%@/memberinfo/%@", PHBaseNewURL, fbId];
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

- (void)setAboutInfo:(NSString *)about {
    self.about = about;
}

@end
