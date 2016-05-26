//
//  MemberInfo.h
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 5/25/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "MTLModel.h"

@class MTLModel;

@interface MemberInfo : MTLModel

@property (copy, nonatomic, readonly) NSString *fbId;
@property (copy, nonatomic, readonly) NSString *about;
@property (copy, nonatomic, readonly) NSString *age;
@property (copy, nonatomic, readonly) NSString *firstName;
@property (copy, nonatomic, readonly) NSString *lastName;
@property (strong, nonatomic, readonly) NSArray *photos;
@property (strong, nonatomic, readonly) NSArray *bookings;
@property (strong, nonatomic, readonly) NSArray *tickets;
@property (strong, nonatomic, readonly) NSArray *likesEvent;

+ (void)retrieveMemberInfoWithCompletionHandler:(MemberInfoCompletionHandler)completion;
+ (void)retrieveMemberInfoWithFbId:(NSString *)fbId andCompletionHandler:(MemberInfoCompletionHandler)completion;

- (void)setAboutInfo:(NSString *)about;

@end


