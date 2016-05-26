//
//  MemberInfoEvent.h
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 5/26/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "MTLModel.h"

@interface MemberInfoEvent : MTLModel

@property(copy, nonatomic, readonly) NSString *eventId;
@property(copy, nonatomic, readonly) NSString *title;
@property(strong, nonatomic, readonly) NSArray *photos;

@end
