//
//  Feed.m
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 4/26/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "Feed.h"
#import "SharedData.h"

@interface Feed ()

@end

@implementation Feed

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"eventId" : @"event_id",
             @"eventName" : @"event_name",
             @"fbId" : @"fb_id",
             @"fromFbId" : @"from_fb_id",
             @"fromFirstName" : @"from_first_name",
             @"fromImageURL" : @"image",
             @"type" : @"type",
             @"hasBooking" : @"badge_booking",
             @"hasTicket" : @"badge_ticket"};
}

+ (NSValueTransformer *)typeJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{@"viewed": @(FeedTypeViewed),
                                                                           @"approved": @(FeedTypeApproved)}];
}

+ (NSString *)feedTypeAsString:(FeedType)type {
    switch (type) {
        case FeedTypeViewed:
            return @"viewed";
            
        case FeedTypeApproved:
            return @"approved";
    }
}

#pragma mark - Archive
+ (NSString *)pathToArchive {
    return [[[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                     inDomains:NSUserDomainMask] lastObject]
             URLByAppendingPathComponent:@"feeds.model"] path];
}

+ (void)archiveObject:(NSArray *)object {
    [NSKeyedArchiver archiveRootObject:object
                                toFile:[Feed pathToArchive]];
}

+ (NSArray *)unarchiveObject {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[Feed pathToArchive]];
}

+ (void)removeArchivedObject {
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:[Feed pathToArchive] error:&error];
}

#pragma mark - API Calls
+ (void)retrieveFeedsWithCompletionHandler:(PartyFeedCompletionHandler)completion {
    SharedData *sharedData = [SharedData sharedInstance];
    AFHTTPRequestOperationManager *manager = [sharedData getOperationManager];
    NSString *url = [NSString stringWithFormat:@"%@/partyfeed/list/%@/%@",
                     PHBaseNewURL,
                     sharedData.fb_id,
                     sharedData.gender_interest];
    [manager GET:url parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        NSArray *feeds = [MTLJSONAdapter modelsOfClass:[Feed class]
                                         fromJSONArray:responseObject[@"data"][@"social_feeds"]
                                                 error:&error];
        if (completion) {
            if (feeds) {
                completion(feeds,
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

+ (void)approveFeed:(BOOL)approved withFbId:(NSString *)fbId andCompletionHandler:(MatchFeedCompletionHandler)completion {
    SharedData *sharedData = [SharedData sharedInstance];
    AFHTTPRequestOperationManager *manager = [sharedData getOperationManager];
    NSString *approveStatus = approved ? @"approved" : @"denied";
    
    NSString *url = [NSString stringWithFormat:@"%@/partyfeed_socialmatch/match/%@/%@/%@", PHBaseNewURL, sharedData.fb_id, fbId, approveStatus];
    
    [manager GET:url parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            completion(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(error);
        }
    }];
}

+ (void)enableSocialFeed:(BOOL)enabled withCompletionHandler:(MatchFeedCompletionHandler)completion {
    SharedData *sharedData = [SharedData sharedInstance];
    NSString *matchMe = enabled ? @"yes" : @"no";
    AFHTTPRequestOperationManager *manager = [sharedData getOperationManager];
    NSString *url = [NSString stringWithFormat:@"%@/partyfeed/settings/%@/%@", PHBaseNewURL, sharedData.fb_id, matchMe];
    
    [manager GET:url parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            completion(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(error);
        }
    }];
}

@end
