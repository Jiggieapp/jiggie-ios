//
//  Theme.h
//  Jiggie
//
//  Created by Setiady Wiguna on 6/15/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "Mantle.h"

@interface Theme : MTLModel <MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSString *themeID;
@property (copy, nonatomic, readonly) NSString *name;
@property (copy, nonatomic, readonly) NSString *desc;
@property (copy, nonatomic, readonly) NSString *image;
@property (copy, nonatomic, readonly) NSString *day;
@property (copy, nonatomic, readonly) NSString *status;

+ (NSString *)pathToArchive;
+ (void)archiveObject:(NSArray *)object;
+ (NSArray *)unarchiveObject;
+ (void)removeArchivedObject;

@end
