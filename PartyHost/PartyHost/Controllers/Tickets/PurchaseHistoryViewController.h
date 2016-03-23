//
//  PurchaseHistoryViewController.h
//  Jiggie
//
//  Created by Setiady Wiguna on 3/18/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "BaseViewController.h"

@interface PurchaseHistoryViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EmptyView *emptyView;

@property (nonatomic, strong) NSArray *orderList;

@end
