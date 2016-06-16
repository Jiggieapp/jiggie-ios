//
//  RoomInfo.h
//  Jiggie
//
//  Created by Mohammad Nuruddin Effendi on 6/16/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"

@class FIRDatabaseReference;
@interface RoomGroupInfo : MTLModel <MTLJSONSerializing>

@property(copy, nonatomic, readonly) NSString *name;
@property(copy, nonatomic, readonly) NSString *avatarURL;
@property(copy, nonatomic, readonly) NSString *lastMessage;
@property(assign, nonatomic, readonly) NSTimeInterval updatedAt;

@end
