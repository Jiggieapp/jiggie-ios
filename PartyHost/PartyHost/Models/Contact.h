//
//  Contect.h
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 5/11/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"

@class APContact;

@interface Contact : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic, readonly) NSNumber *recordID;
@property (strong, nonatomic, readonly) UIImage *thumbnail;
@property (copy, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSArray *phones;
@property (strong, nonatomic, readonly) NSArray *emails;
@property (assign, nonatomic, readonly) BOOL isActive;
@property (strong, nonatomic, readonly) NSNumber *credit;

- (instancetype)initWithContact:(APContact *)contact;
- (void)setThumbnailWithImage:(UIImage *)image;

+ (NSString *)pathToArchiveRecordID;
+ (void)archiveRecordIDs:(NSArray *)recordIDs;
+ (NSArray *)unarchiveRecordIDs;
+ (void)removeArchivedRecordIDs;

@end
