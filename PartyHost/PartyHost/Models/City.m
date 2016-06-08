//
//  City.m
//  Jiggie
//
//  Created by Mohammad Nuruddin Effendi on 6/8/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "City.h"

@implementation City

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"identifier" : @"_id",
             @"country" : @"country",
             @"name" : @"city"};
}

+ (void)retrieveCitiesWithCompletionHandler:(CitiesCompletionHandler)completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *urlToLoad = [NSString stringWithFormat:@"%@/user/citylist", PHBaseNewURL];
    [manager GET:urlToLoad parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        NSArray *cities = [MTLJSONAdapter modelsOfClass:[City class]
                                           fromJSONArray:responseObject[@"data"][@"citylist"]
                                                  error:&error];
        
        if (completion) {
            if (cities) {
                completion(cities,
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
