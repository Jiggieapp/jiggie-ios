//
//  Contect.m
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 5/11/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "Contact.h"
#import "APContact.h"

@interface Contact ()

@property (strong, nonatomic) NSNumber *recordID;
@property (strong, nonatomic) UIImage *thumbnail;
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *phones;
@property (strong, nonatomic) NSArray *emails;
@property (assign, nonatomic) BOOL isActive;

@end

@implementation Contact

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"recordID" : @"record_id",
             @"name" : @"name",
             @"emails" : @"email",
             @"phones" : @"phone",
             @"isActive" : @"is_active",
             @"credit" : @"credit"};
}

+ (NSValueTransformer *)recordIDJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return value;
    } reverseBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return [NSNumber numberWithInteger:[value integerValue]];
    }];
}

+ (NSValueTransformer *)isActiveJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{@(0) : @(NO),
                                                                           @(1) : @(YES)}];
}

- (instancetype)initWithContact:(APContact *)contact {
    if (self = [super init]) {
        self.recordID = contact.recordID;
        
        NSString *firstName = @"";
        NSString *lastName = @"";
        
        if (contact.name.firstName) {
            firstName = contact.name.firstName;
        }
        
        if (contact.name.lastName) {
            lastName = contact.name.lastName;
        }
        
        self.name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        
        NSArray *phonesNumber = [contact.phones valueForKeyPath:@"@distinctUnionOfObjects.number"];
        NSArray *emailsAddress = [contact.emails valueForKeyPath:@"@distinctUnionOfObjects.address"];
        
        self.phones = phonesNumber;
        self.emails = emailsAddress;
        self.thumbnail = contact.thumbnail;
        self.isActive = NO;
    }
    
    return self;
}

- (void)setThumbnailWithImage:(UIImage *)image {
    self.thumbnail = image;
}

#pragma mark - Archive
+ (NSString *)pathToArchiveRecordID {
    return [[[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                     inDomains:NSUserDomainMask] lastObject]
             URLByAppendingPathComponent:@"recordIDs.model"] path];
}

+ (void)archiveRecordIDs:(NSArray *)recordIDs {
    [NSKeyedArchiver archiveRootObject:recordIDs
                                toFile:[Contact pathToArchiveRecordID]];
}

+ (NSArray *)unarchiveRecordIDs {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[Contact pathToArchiveRecordID]];
}

+ (void)removeArchivedRecordIDs {
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:[Contact pathToArchiveRecordID] error:&error];
}

@end
