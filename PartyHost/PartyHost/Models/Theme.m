//
//  Theme.m
//  Jiggie
//
//  Created by Setiady Wiguna on 6/15/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "Theme.h"

@implementation Theme

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"themeID" : @"_id",
             @"name" : @"name",
             @"desc" : @"desc",
             @"image" : @"image",
             @"day" : @"day",
             @"status" : @"status"};
}

#pragma mark - Archive
+ (NSString *)pathToArchive {
    return [[[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                     inDomains:NSUserDomainMask] lastObject]
             URLByAppendingPathComponent:@"theme.model"] path];
}

+ (void)archiveObject:(NSArray *)object {
    [NSKeyedArchiver archiveRootObject:object
                                toFile:[Theme pathToArchive]];
}

+ (NSArray *)unarchiveObject {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[Theme pathToArchive]];
}

+ (void)removeArchivedObject {
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:[Theme pathToArchive] error:&error];
}

@end
