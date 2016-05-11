//
//  Contect.h
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 5/11/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class APContact;

@interface Contact : NSObject

@property (strong, nonatomic) NSNumber *recordID;
@property (copy, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSArray *phones;
@property (strong, nonatomic, readonly) NSArray *emails;

- (instancetype)initWithContact:(APContact *)contact;

+ (NSString *)pathToArchiveRecordID;
+ (void)archiveRecordIDs:(NSArray *)recordIDs;
+ (NSArray *)unarchiveRecordIDs;
+ (void)removeArchivedRecordIDs;

@end
