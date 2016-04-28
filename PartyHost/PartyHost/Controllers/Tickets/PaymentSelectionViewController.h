//
//  PaymentSelectionViewController.h
//  Jiggie
//
//  Created by Setiady Wiguna on 3/10/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "BaseViewController.h"

@interface PaymentSelectionViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EmptyView *emptyView;

@property (nonatomic, strong) NSDictionary *productList;
@property (nonatomic, strong) NSMutableArray *paymentMethods;
@property (nonatomic, strong) SharedData *sharedData;
@property (nonatomic, strong) NSMutableArray *creditCardNew;
@property (nonatomic, strong) NSMutableArray *creditCardServer;
@property (nonatomic, assign) BOOL isCreditCardAllowed;

@end
