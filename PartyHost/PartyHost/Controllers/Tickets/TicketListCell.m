//
//  TicketListCell.m
//  Jiggie
//
//  Created by Setiady Wiguna on 2/26/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "TicketListCell.h"

@implementation TicketListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *accessory = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 13)];
        [accessory setImage:[UIImage imageNamed:@"icon_purple_arrow"]];
        [self setAccessoryView:accessory];
        
        CGFloat ticketTitleWidth = self.contentView.bounds.size.width/2;
        
        self.ticketTitle = [[UILabel alloc] initWithFrame:CGRectMake(14, 8, ticketTitleWidth + 10, 20)];
        [self.ticketTitle setFont:[UIFont phBlond:15]];
        [self.ticketTitle setTextColor:[UIColor blackColor]];
        [self.ticketTitle setBackgroundColor:[UIColor clearColor]];
        [self.ticketTitle setAdjustsFontSizeToFitWidth:YES];
        [[self contentView] addSubview:self.ticketTitle];
        
        self.ticketDescription = [[UILabel alloc] initWithFrame:CGRectMake(14, 30, ticketTitleWidth + 10, 20)];
        [self.ticketDescription setFont:[UIFont phBlond:12]];
        [self.ticketDescription setTextColor:[UIColor lightGrayColor]];
        [self.ticketDescription setBackgroundColor:[UIColor clearColor]];
        [self.ticketDescription setAdjustsFontSizeToFitWidth:YES];
        [[self contentView] addSubview:self.ticketDescription];
        
        self.ticketPrice = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - 160, 8, 120, 20)];
        [self.ticketPrice setFont:[UIFont phBlond:16]];
        [self.ticketPrice setTextColor:[UIColor blackColor]];
        [self.ticketPrice setBackgroundColor:[UIColor clearColor]];
        [self.ticketPrice setTextAlignment:NSTextAlignmentRight];
        [[self contentView] addSubview:self.ticketPrice];
        
        self.ticketPerson = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - 150, 30, 110, 20)];
        [self.ticketPerson setFont:[UIFont phBlond:12]];
        [self.ticketPerson setTextColor:[UIColor lightGrayColor]];
        [self.ticketPerson setBackgroundColor:[UIColor clearColor]];
        [self.ticketPerson setTextAlignment:NSTextAlignmentRight];
        [[self contentView] addSubview:self.ticketPerson];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSDictionary *)data hasDescription:(BOOL)hasDescription {
    
    CGFloat ticketTitleWidth = self.cellWidth/2;
    [self.ticketTitle setFrame:CGRectMake(14, 8, ticketTitleWidth, 20)];
    [self.ticketDescription setFrame:CGRectMake(14, 30, ticketTitleWidth, 20)];
    [self.ticketPrice setFrame:CGRectMake(self.cellWidth - 160, 8, 120, 20)];
    [self.ticketPerson setFrame:CGRectMake(self.cellWidth - 160, 30, 120, 20)];
    
    if (hasDescription) {
        [self.ticketTitle setFrame:CGRectMake(14, 6, 160, 20)];
        [self.ticketDescription setHidden:NO];
    } else {
        [self.ticketTitle setFrame:CGRectMake(14, 16, 160, 20)];
        [self.ticketDescription setHidden:YES];
    }
    
    if (data && data != nil) {
        NSString *name = [data objectForKey:@"name"];
        if (name && name != nil) {
            [self.ticketTitle setText:name];
            [self.ticketTitle setTextColor:[UIColor blackColor]];
        }
        
        NSString *status = [data objectForKey:@"status"];
        if (status && status != nil) {
            if ([status isEqualToString:@"sold out"]) {
                [self.ticketTitle setText:[NSString stringWithFormat:@"%@ (SOLD OUT)", name]];
                [self.ticketTitle setTextColor:[UIColor redColor]];
            }
        }
        
        NSNumber *quantity = [data objectForKey:@"quantity"];
        if (quantity && quantity != nil) {
            if (quantity.integerValue == 0) {
                [self.ticketTitle setText:[NSString stringWithFormat:@"%@ (SOLD OUT)", name]];
                [self.ticketTitle setTextColor:[UIColor redColor]];
            }
        }
        
        NSString *summary = [data objectForKey:@"summary"];
        if (summary && summary != nil) {
            [self.ticketDescription setText:summary];
        }
        
        NSString *price = [data objectForKey:@"price"];
        if (price && price != nil) {
            SharedData *sharedData = [SharedData sharedInstance];
            NSString *formattedPrice = [sharedData formatCurrencyString:price];
            [self.ticketPrice setText:[NSString stringWithFormat:@"Rp%@", formattedPrice]];
        }
        
        if (hasDescription) {
            NSString *max_purchase = [data objectForKey:@"max_purchase"];
            if (max_purchase && max_purchase != nil) {
                [self.ticketPerson setText:[NSString stringWithFormat:@"Max Purchased %@", max_purchase]];
            }
        } else {
            NSString *max_guests = [data objectForKey:@"max_guests"];
            if (max_guests && max_guests != nil) {
                [self.ticketPerson setText:[NSString stringWithFormat:@"Max Guest %@", max_guests]];
            }
        }
    }
}

@end
