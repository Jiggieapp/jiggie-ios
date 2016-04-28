//
//  PurchaseHistoryCell.h
//  Jiggie
//
//  Created by Setiady Wiguna on 3/19/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurchaseHistoryCell : UITableViewCell

@property (nonatomic, strong) UILabel *eventTitle;
@property (nonatomic, strong) UILabel *eventVenue;
@property (nonatomic, strong) UILabel *eventDate;
@property (nonatomic, strong) UILabel *orderState;
@property (nonatomic, assign) CGFloat cellWidth;

- (void)setData:(NSDictionary *)data;

@end
