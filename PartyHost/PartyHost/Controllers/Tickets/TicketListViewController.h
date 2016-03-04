//
//  TicketListViewController.h
//  Jiggie
//
//  Created by Setiady Wiguna on 2/3/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "BaseViewController.h"
#import "Event.h"

@interface TicketListViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EmptyView *emptyView;

@property (nonatomic, strong) Event *cEvent;
@property (nonatomic, strong) SharedData *sharedData;
@property (nonatomic, strong) NSArray *purchases;
@property (nonatomic, strong) NSArray *reservations;

@end
