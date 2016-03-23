//
//  PurchaseHistoryViewController.m
//  Jiggie
//
//  Created by Setiady Wiguna on 3/18/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "PurchaseHistoryViewController.h"
#import "PurchaseHistoryCell.h"
#import "TicketSuccessViewController.h"
#import "VirtualAccountViewController.h"


@interface PurchaseHistoryViewController ()

@end

@implementation PurchaseHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [titleView setBackgroundColor:[UIColor clearColor]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:@"PURCHASE HISTORY"];
    [titleLabel setFont:[UIFont phBlond:15]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleView addSubview:titleLabel];
    
    [self.navigationItem setTitleView:titleView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.visibleSize.width, self.visibleSize.height)];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.tableView];
    
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

- (void)backButtonDidTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Data
- (void)loadData {
    SharedData *sharedData = [SharedData sharedInstance];
    AFHTTPRequestOperationManager *manager = [sharedData getOperationManager];
    
    //events/list/
    NSString *url = [NSString stringWithFormat:@"%@/product/order_list/%@", PHBaseNewURL, sharedData.fb_id];
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
                        NSArray *order_lists = [data objectForKey:@"order_lists"];
                        if (order_lists && order_lists != nil) {
                            self.orderList = order_lists;
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

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orderList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"PurchaseHistoryCell";
    
    PurchaseHistoryCell *cell = (PurchaseHistoryCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[PurchaseHistoryCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        cell.cellWidth = self.visibleSize.width;
    }
    
    NSDictionary *reservation = [self.orderList objectAtIndex:indexPath.row];
    [cell setData:reservation];
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    NSDictionary *reservation = [self.orderList objectAtIndex:indexPath.row];
    if (reservation && reservation != nil) {
        NSDictionary *order = [reservation objectForKey:@"order"];
        if (order && order != nil) {
            NSString *payment_status = [order objectForKey:@"payment_status"];
            if ([payment_status isEqualToString:@"paid"]) {
                TicketSuccessViewController *ticketSuccessViewController = [[TicketSuccessViewController alloc] init];
                [ticketSuccessViewController setOrderID:[order objectForKey:@"order_id"]];
                [ticketSuccessViewController setShowCloseButton:YES];
                [ticketSuccessViewController setShowViewButton:NO];
                [ticketSuccessViewController setIsModalScreen:NO];
                [ticketSuccessViewController setTicketType:@""];
                [self.navigationController pushViewController:ticketSuccessViewController animated:YES];
            } else {
                VirtualAccountViewController *virtualAccountViewController = [[VirtualAccountViewController alloc] init];
                [virtualAccountViewController setOrderID:[order objectForKey:@"order_id"]];
                [virtualAccountViewController setShowCloseButton:YES];
                [virtualAccountViewController setShowOrderButton:NO];
                [virtualAccountViewController setIsModalScreen:NO];
                [virtualAccountViewController setVAType:@""];
                [self.navigationController pushViewController:virtualAccountViewController animated:YES];
            }
        }
    }
}

@end
