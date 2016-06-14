//
//  Room.h
//  Jiggie
//
//  Created by Mohammad Nuruddin Effendi on 6/14/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"

typedef enum {
    RoomTypePrivate,
    RoomTypeGroup
} RoomType;

@interface Room : MTLModel <MTLJSONSerializing>

@property(copy, nonatomic, readonly) NSString *name;
@property(assign, nonatomic, readonly) RoomType type;

@end
