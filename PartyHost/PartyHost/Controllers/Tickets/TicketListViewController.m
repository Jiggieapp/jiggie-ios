//
//  TicketListViewController.m
//  Jiggie
//
//  Created by Setiady Wiguna on 2/3/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "TicketListViewController.h"
#import "TicketSummaryViewController.h"
#import "SharedData.h"
#import "UIColor+PH.h"
#import "UIFont+PH.h"

@interface TicketListViewController ()

@end

@implementation TicketListViewController

- (id)init {
    if ((self = [super init])) {
        self.sharedData = [SharedData sharedInstance];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"nav_cancel"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    
    [[self navigationItem] setLeftBarButtonItem:closeBarButtonItem];
    
    [self setTitle:@"Choose Experience"];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    [titleView setBackgroundColor:[UIColor clearColor]];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.visibleSize.width, self.visibleSize.height - 44)];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
    
    UIButton *continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [continueButton addTarget:self action:@selector(continueButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [continueButton setFrame:CGRectMake(0, self.visibleSize.height - 44, self.visibleSize.width, 44)];
    [continueButton setBackgroundColor:[UIColor phBlueColor]];
    [continueButton.titleLabel setFont:[UIFont phBold:15]];
    [continueButton setTitle:@"CONTINUE" forState:UIControlStateNormal];
    [continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:continueButton];
    
    self.emptyView = [[EmptyView alloc] initWithFrame:CGRectMake(0, 0, self.visibleSize.width, self.visibleSize.height)];
    [self.emptyView setData:@"No data found" subtitle:@"Sorry we're having some server issues, please check back in a few minutes." imageNamed:@""];
    [self.emptyView setMode:@"load"];
    [self.emptyView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.emptyView];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (void)closeButtonDidTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)continueButtonDidTap:(id)sender {
    [self postSummary];
    
//    TicketSummaryViewController *ticketSummaryViewController = [[TicketSummaryViewController alloc] init];
//    [self.navigationController pushViewController:ticketSummaryViewController animated:YES];
}

#pragma mark - Data 
- (void)loadData {
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    //events/list/
//    NSString *url = [NSString stringWithFormat:@"%@/product/list/%@",PHBaseNewURL,self.cEvent.eventID];
    NSString *url = [NSString stringWithFormat:@"%@/product/list/56b1a0bf89bfed03005c50f0",PHBaseNewURL];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSInteger responseStatusCode = operation.response.statusCode;
        if (responseStatusCode != 200) {
            [self.emptyView setMode:@"empty"];
            return;
        }
        
        NSString *responseString = operation.responseString;
        NSError *error;
        
        NSDictionary *json = (NSDictionary *)[NSJSONSerialization
                                              JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]
                                              options:kNilOptions
                                              error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (json && json != nil) {
                @try {
                    NSDictionary *data = [json objectForKey:@"data"];
                    if (data && data != nil) {
                        NSDictionary *product_lists = [data objectForKey:@"product_lists"];
                        if (product_lists && product_lists != nil) {
                            NSArray *purchase = [product_lists objectForKey:@"purchase"];
                            if (purchase && purchase != nil) {
                                self.purchases = purchase;
                            }
                            
                            NSArray *reservation = [product_lists objectForKey:@"reservation"];
                            if (reservation && reservation != nil) {
                                self.reservations = reservation;
                            }
                        }
                    }
                    [self.tableView reloadData];
                    [self.emptyView setMode:@"hide"];
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
            }
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self.emptyView setMode:@"empty"];
    }];
}

- (void)postSummary {
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    NSString *url = [NSString stringWithFormat:@"%@/product/summary",PHBaseNewURL];
    
    NSMutableArray *summaryList = [NSMutableArray array];
    for (NSDictionary *product in self.purchases) {
        NSDictionary *summary = @{@"ticket_id":[product objectForKey:@"ticket_id"],
                                  @"name":[product objectForKey:@"name"],
                                  @"ticket_type":[product objectForKey:@"ticket_type"],
                                  @"quantity":[product objectForKey:@"quantity"],
                                  @"total_price":[product objectForKey:@"total_price"],
                                  @"num_buy":@2};
        [summaryList addObject:summary];
    }
    
    NSDictionary *params = @{@"fb_id":self.sharedData.fb_id,
                             @"event_id":self.cEvent.eventID,
                             @"product_list":summaryList};
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSInteger responseStatusCode = operation.response.statusCode;
        if (responseStatusCode != 200) {
            return;
        }
        
        NSString *responseString = operation.responseString;
        NSError *error;
        
        NSDictionary *json = (NSDictionary *)[NSJSONSerialization
                                              JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]
                                              options:kNilOptions
                                              error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (json && json != nil) {
                @try {
                   
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
            }
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Purchase";
    }
    return @"Reservation";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.purchases.count;
    }
    return self.reservations.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *simpleTableIdentifier = @"Purchase-TicketCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        }
        
        NSDictionary *purchase = [self.purchases objectAtIndex:indexPath.row];
        if (purchase && purchase != nil) {
            NSString *name = [purchase objectForKey:@"name"];
            if (name && name != nil) {
                [cell.textLabel setText:name];
            }
            
            NSString *total_price = [purchase objectForKey:@"total_price"];
            if (total_price && total_price != nil) {
                [cell.detailTextLabel setText:total_price];
            }
        }
        
        return cell;
    }
    
    static NSString *simpleTableIdentifier = @"Reservation-TicketCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    NSDictionary *reservation = [self.reservations objectAtIndex:indexPath.row];
    if (reservation && reservation != nil) {
        NSString *name = [reservation objectForKey:@"name"];
        if (name && name != nil) {
            [cell.textLabel setText:name];
        }
        
        NSString *total_price = [reservation objectForKey:@"total_price"];
        if (total_price && total_price != nil) {
            [cell.detailTextLabel setText:total_price];
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];

}

@end
