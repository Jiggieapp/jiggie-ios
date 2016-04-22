//
//  TicketListCell.h
//  Jiggie
//
//  Created by Setiady Wiguna on 2/26/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketListCell : UITableViewCell

@property (nonatomic, strong) UIImageView *ticketCard;
@property (nonatomic, strong) UILabel *ticketTitle;
@property (nonatomic, strong) UILabel *ticketPrice;
@property (nonatomic, assign) CGFloat cellWidth;

- (void)setData:(NSDictionary *)data;

@end
