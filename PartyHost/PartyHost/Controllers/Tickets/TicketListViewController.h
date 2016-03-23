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
@property (nonatomic, strong) UILabel *tableHeaderTitle;
@property (nonatomic, strong) UILabel *tableHeaderDescription;
@property (nonatomic, strong) EmptyView *emptyView;

@property (nonatomic, strong) Event *cEvent;
@property (nonatomic, strong) NSString *eventID;
@property (nonatomic, strong) SharedData *sharedData;
@property (nonatomic, strong) NSDictionary *productList;
@property (nonatomic, strong) NSArray *purchases;
@property (nonatomic, strong) NSArray *reservations;

@end
