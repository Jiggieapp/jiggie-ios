//
//  TicketListCell.m
//  Jiggie
//
//  Created by Setiady Wiguna on 2/26/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "TicketListCell.h"

@implementation TicketListCell

- (void)awakeFromNib {
    // Initialization code
    
    UIImageView *accessory = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 26)];
    [accessory setImage:[UIImage imageNamed:@"icon_purple_arrow"]];
    [self setAccessoryView:accessory];
    
    UILabel *ticketTitle = [[UILabel alloc] initWithFrame:CGRectMake(14, 6, 180, 20)];
    [ticketTitle setFont:[UIFont phBlond:15]];
    [ticketTitle setTextColor:[UIColor blackColor]];
    [ticketTitle setBackgroundColor:[UIColor clearColor]];
    [[self contentView] addSubview:ticketTitle];
    
    UILabel *ticketDescription = [[UILabel alloc] initWithFrame:CGRectMake(14, 30, 180, 20)];
    [ticketDescription setFont:[UIFont phBlond:12]];
    [ticketDescription setTextColor:[UIColor blackColor]];
    [ticketDescription setBackgroundColor:[UIColor clearColor]];
    [[self contentView] addSubview:ticketDescription];
    
    UILabel *ticketPrice = [[UILabel alloc] initWithFrame:CGRectMake(14, 6, 180, 20)];
    [ticketPrice setFont:[UIFont phBlond:18]];
    [ticketPrice setTextColor:[UIColor blackColor]];
    [ticketPrice setBackgroundColor:[UIColor clearColor]];
    [ticketTitle setTextAlignment:NSTextAlignmentRight];
    [[self contentView] addSubview:ticketPrice];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSDictionary *)data hasDescription:(BOOL)hasDescription {
    
}

@end
