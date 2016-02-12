//
//  TicketSummaryViewController.m
//  Jiggie
//
//  Created by Setiady Wiguna on 2/11/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "TicketSummaryViewController.h"

@interface TicketSummaryViewController ()

@end

@implementation TicketSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"Order Summary"];
    
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

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (void)continueButtonDidTap:(id)sender {

}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.productList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"Summary-TicketCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    NSDictionary *reservation = [self.productList objectAtIndex:indexPath.row];
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
