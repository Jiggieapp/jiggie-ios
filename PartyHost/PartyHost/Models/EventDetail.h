//
//  EventDetail.h
//  Jiggie
//
//  Created by Setiady Wiguna on 12/21/15.
//  Copyright © 2015 Sunny Clark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EventDetail : NSManagedObject

@property (nullable, nonatomic, retain) NSString *eventID;
@property (nullable, nonatomic, retain) NSDate *startDatetime;
@property (nullable, nonatomic, retain) NSString *startDatetimeStr;
@property (nullable, nonatomic, retain) NSDate *endDatetime;
@property (nullable, nonatomic, retain) NSString *endDatetimeStr;
@property (nullable, nonatomic, retain) NSDate *modified;
@property (nullable, nonatomic, retain) NSString *eventDescription;
@property (nullable, nonatomic, retain) NSString *fullfillmentType;
@property (nullable, nonatomic, retain) NSString *fullfillmentValue;
@property (nullable, nonatomic, retain) id guestViewed;
@property (nullable, nonatomic, retain) id photos;
@property (nullable, nonatomic, retain) id tags;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) id venue;
@property (nullable, nonatomic, retain) NSString *venueID;
@property (nullable, nonatomic, retain) NSString *venueName;
@property (nullable, nonatomic, retain) NSNumber *likes;
@property (nullable, nonatomic, retain) NSNumber *isLiked;
@property (nullable, nonatomic, retain) NSNumber *lowestPrice;

@end

