//
//  DialCodeListViewController.h
//  Jiggie
//
//  Created by Setiady Wiguna on 4/20/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "BaseViewController.h"

@interface DialCodeListViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) EmptyView *emptyView;

@property (nonatomic, strong) NSArray *dialCodes;

@end
