//
//  PurchaseHistoryCell.m
//  Jiggie
//
//  Created by Setiady Wiguna on 3/19/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "PurchaseHistoryCell.h"

@implementation PurchaseHistoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        CGFloat ticketTitleWidth = self.contentView.bounds.size.width/2;
        
        self.eventTitle = [[UILabel alloc] initWithFrame:CGRectMake(14, 8, ticketTitleWidth, 20)];
        [self.eventTitle setFont:[UIFont phBlond:15]];
        [self.eventTitle setTextColor:[UIColor blackColor]];
        [self.eventTitle setBackgroundColor:[UIColor clearColor]];
        [[self contentView] addSubview:self.eventTitle];
        
        UIImageView *locationView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 36, 15, 18)];
        [locationView setImage:[UIImage imageNamed:@"icon_location.png"]];
        [locationView setBackgroundColor:[UIColor clearColor]];
        [[self contentView] addSubview:locationView];
        
        self.eventVenue = [[UILabel alloc] initWithFrame:CGRectMake(38, 34, ticketTitleWidth, 20)];
        [self.eventVenue setFont:[UIFont phBlond:12]];
        [self.eventVenue setTextColor:[UIColor lightGrayColor]];
        [self.eventVenue setBackgroundColor:[UIColor clearColor]];
        [[self contentView] addSubview:self.eventVenue];
        
        UIImageView *timeView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 60, 18, 18)];
        [timeView setImage:[UIImage imageNamed:@"icon_time.png"]];
        [timeView setBackgroundColor:[UIColor clearColor]];
        [[self contentView] addSubview:timeView];
        
        self.eventDate = [[UILabel alloc] initWithFrame:CGRectMake(38, 58, 120, 20)];
        [self.eventDate setFont:[UIFont phBlond:12]];
        [self.eventDate setTextColor:[UIColor lightGrayColor]];
        [self.eventDate setBackgroundColor:[UIColor clearColor]];
        [[self contentView] addSubview:self.eventDate];
        
        self.orderState = [[UILabel alloc] initWithFrame:CGRectMake(14, 86, 80, 20)];
        [self.orderState setFont:[UIFont phBlond:12]];
        [self.orderState setTextColor:[UIColor whiteColor]];
        [self.orderState setBackgroundColor:[UIColor phBlueColor]];
        [self.orderState setTextAlignment:NSTextAlignmentCenter];
        self.orderState.layer.cornerRadius = 10;
        self.orderState.layer.masksToBounds = YES;
        [[self contentView] addSubview:self.orderState];
    }
    return self;
}

- (void)setData:(NSDictionary *)data {
    
    [self.eventTitle setFrame:CGRectMake(self.eventTitle.frame.origin.x, self.eventTitle.frame.origin.y, self.cellWidth - 60, 20)];
    [self.eventVenue setFrame:CGRectMake(self.eventVenue.frame.origin.x, self.eventVenue.frame.origin.y, self.cellWidth - 100, 20)];
    [self.eventDate setFrame:CGRectMake(self.eventDate.frame.origin.x, self.eventDate.frame.origin.y, self.cellWidth - 100, 20)];
    
    if (data && data != nil) {
        
        NSDictionary *event = [data objectForKey:@"event"];
        if (event && event != nil) {
            NSString *title = [[event objectForKey:@"title"] uppercaseString];
            if (title && title != nil) {
                [self.eventTitle setText:title];
            }
            
            NSString *venue_name = [event objectForKey:@"venue_name"];
            if (venue_name && venue_name != nil) {
                [self.eventVenue setText:venue_name];
            }
            
            NSString *start_datetime = [event objectForKey:@"start_datetime"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:PHDateFormatServer];
            [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
            [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
            NSDate *startDatetime = [formatter dateFromString:start_datetime];
            
            [formatter setDateFormat:PHDateFormatAppShort];
            [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
            [formatter setTimeZone:[NSTimeZone localTimeZone]];
            NSString *shortDateTime = [formatter stringFromDate:startDatetime];
            
            [self.eventDate setText:shortDateTime];
        }
        
        NSDictionary *order = [data objectForKey:@"order"];
        if (order && order != nil) {
            NSString *payment_status = [order objectForKey:@"payment_status"];
            if ([payment_status isEqualToString:@"paid"]) {
                [self.orderState setBackgroundColor:[UIColor phBlueColor]];
                [self.orderState setText:@"Paid"];
            } else if ([payment_status isEqualToString:@"reserved"]) {
                [self.orderState setBackgroundColor:[UIColor colorFromHexCode:@"FFB51E"]];
                [self.orderState setText:@"Reserved"];
            } else if ([payment_status isEqualToString:@"awaiting_payment"]) {
                [self.orderState setBackgroundColor:[UIColor colorFromHexCode:@"FFB51E"]];
                [self.orderState setText:@"Unpaid"];
            } else if ([payment_status isEqualToString:@"expire"]) {
                [self.orderState setBackgroundColor:[UIColor colorFromHexCode:@"F64440"]];
                [self.orderState setText:@"Expired"];
            } else if ([payment_status isEqualToString:@"void"]) {
                [self.orderState setBackgroundColor:[UIColor colorFromHexCode:@"F64440"]];
                [self.orderState setText:@"Void"];
            } else if ([payment_status isEqualToString:@"refund"]) {
                [self.orderState setBackgroundColor:[UIColor colorFromHexCode:@"F64440"]];
                [self.orderState setText:@"Refund"];
            }
        }
    }
}

@end
