//
//  BaseModel.m
//  Jiggie
//
//  Created by Setiady Wiguna on 12/18/15.
//  Copyright © 2015 Sunny Clark. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

+ (NSArray *)fetchAllManagedObject:(NSManagedObjectContext *)moc inEntity:(NSString *)entityName {
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:entityName inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSError *error;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    
    return array;
}

+ (NSArray *)fetchManagedObject:(NSManagedObjectContext *)moc inEntity:(NSString *)entityName andPredicate:(NSPredicate *)predicate {
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:entityName inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    
    return array;
}

@end
