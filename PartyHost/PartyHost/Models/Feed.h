//
//  Feed.h
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 4/26/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "Mantle.h"

typedef enum : NSUInteger {
    FeedTypeViewed,
    FeedTypeApproved
}FeedType;

typedef enum : NSUInteger {
    FeedSourceEvent,
    FeedSourceNearby
}FeedSource;

@interface Feed : MTLModel <MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSString *eventId;
@property (copy, nonatomic, readonly) NSString *eventName;
@property (copy, nonatomic, readonly) NSString *fbId;
@property (copy, nonatomic, readonly) NSString *fromFbId;
@property (copy, nonatomic, readonly) NSString *fromFirstName;
@property (copy, nonatomic, readonly) NSString *fromImageURL;
@property (assign, nonatomic, readonly) FeedType type;
@property (strong, nonatomic, readonly) NSNumber *hasBooking;
@property (strong, nonatomic, readonly) NSNumber *hasTicket;
@property (assign, nonatomic, readonly) FeedSource source;

+ (NSString *)feedTypeAsString:(FeedType)type;

+ (NSString *)pathToArchive;
+ (void)archiveObject:(NSArray *)object;
+ (NSArray *)unarchiveObject;
+ (void)removeArchivedObject;

+ (void)retrieveFeedsWithCompletionHandler:(PartyFeedCompletionHandler)completion;
+ (void)approveFeed:(BOOL)approved withFbId:(NSString *)fbId andSource:(FeedSource)source andCompletionHandler:(MatchFeedCompletionHandler)completion;
+ (void)enableSocialFeed:(BOOL)enabled withCompletionHandler:(MatchFeedCompletionHandler)completion;

@end
