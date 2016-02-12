//
//  TicketSummaryViewController.h
//  Jiggie
//
//  Created by Setiady Wiguna on 2/11/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "BaseViewController.h"

@interface TicketSummaryViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *productList;
@property (nonatomic, strong) NSDictionary *productSummary;

@end
