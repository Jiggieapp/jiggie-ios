//
//  Event.h
//  Jiggie
//
//  Created by Setiady Wiguna on 12/17/15.
//  Copyright © 2015 Sunny Clark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSString *eventID;
@property (nonatomic, retain) NSString *photo;
@property (nonatomic, retain) NSString *startDatetimeStr;
@property (nonatomic, retain) NSString *tags;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *venue;

@end

