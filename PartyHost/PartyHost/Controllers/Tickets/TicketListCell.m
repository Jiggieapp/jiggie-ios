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
        
        [[self contentView] setBackgroundColor:[UIColor clearColor]];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.ticketCard = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.ticketCard setImage:[[UIImage imageNamed:@"bg_rectangle"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
        [[self contentView] addSubview:self.ticketCard];
        
        self.ticketTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.ticketTitle setFont:[UIFont phBlond:16]];
        [self.ticketTitle setTextColor:[UIColor blackColor]];
        [self.ticketTitle setBackgroundColor:[UIColor clearColor]];
        [self.ticketTitle setAdjustsFontSizeToFitWidth:YES];
        [[self contentView] addSubview:self.ticketTitle];
        
        self.ticketPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.ticketPrice setFont:[UIFont phBlond:16]];
        [self.ticketPrice setTextColor:[UIColor phPurpleColor]];
        [self.ticketPrice setBackgroundColor:[UIColor clearColor]];
        [self.ticketPrice setTextAlignment:NSTextAlignmentRight];
        [[self contentView] addSubview:self.ticketPrice];
        
        /*
        self.ticketDescription = [[UILabel alloc] initWithFrame:CGRectMake(14, 30, ticketTitleWidth + 10, 20)];
        [self.ticketDescription setFont:[UIFont phBlond:12]];
        [self.ticketDescription setTextColor:[UIColor lightGrayColor]];
        [self.ticketDescription setBackgroundColor:[UIColor clearColor]];
        [self.ticketDescription setAdjustsFontSizeToFitWidth:YES];
        [[self contentView] addSubview:self.ticketDescription];
        
        self.ticketPerson = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - 150, 30, 110, 20)];
        [self.ticketPerson setFont:[UIFont phBlond:12]];
        [self.ticketPerson setTextColor:[UIColor lightGrayColor]];
        [self.ticketPerson setBackgroundColor:[UIColor clearColor]];
        [self.ticketPerson setTextAlignment:NSTextAlignmentRight];
        [[self contentView] addSubview:self.ticketPerson];
         */
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSDictionary *)data {
    
    CGFloat ticketTitleWidth = self.cellWidth/2;
    
    [self.ticketCard setFrame:CGRectMake(8, 1, self.cellWidth - 16, 68)];
    [self.ticketTitle setFrame:CGRectMake(24, 24, ticketTitleWidth, 20)];
    [self.ticketPrice setFrame:CGRectMake(self.cellWidth - 100 - 24, 24, 100, 20)];
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

        NSString *price = [data objectForKey:@"price"];
        if (price && price != nil) {
            if ([price integerValue] == 0) {
                [self.ticketPrice setText:@"FREE"];
            } else {
                SharedData *sharedData = [SharedData sharedInstance];
                NSString *formattedPrice = [sharedData formatCurrencyString:price];
                [self.ticketPrice setText:[NSString stringWithFormat:@"Rp%@", formattedPrice]];
            }
        }
        
        /*
         [self.ticketDescription setFrame:CGRectMake(14, 30, ticketTitleWidth, 20)];
         [self.ticketPerson setFrame:CGRectMake(self.cellWidth - 160, 30, 120, 20)];
         
        if (hasDescription) {
            [self.ticketTitle setFrame:CGRectMake(14, 6, 160, 20)];
            [self.ticketDescription setHidden:NO];
        } else {
            [self.ticketTitle setFrame:CGRectMake(14, 16, 160, 20)];
            [self.ticketDescription setHidden:YES];
        }
        
        NSString *summary = [data objectForKey:@"summary"];
        if (summary && summary != nil) {
            [self.ticketDescription setText:summary];
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
         */
    }
}

@end
