//
//  BaseModel.h
//  Jiggie
//
//  Created by Setiady Wiguna on 12/18/15.
//  Copyright © 2015 Sunny Clark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

+ (NSArray *)fetchAllManagedObject:(NSManagedObjectContext *)moc inEntity:(NSString *)entityName;
+ (NSArray *)fetchManagedObject:(NSManagedObjectContext *)moc inEntity:(NSString *)entityName andPredicate:(NSPredicate *)predicate;

@end
