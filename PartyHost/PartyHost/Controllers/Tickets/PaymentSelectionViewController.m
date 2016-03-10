//
//  PaymentSelectionViewController.m
//  Jiggie
//
//  Created by Setiady Wiguna on 3/10/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "PaymentSelectionViewController.h"
#import "AddPaymentViewController.h"

@interface PaymentSelectionViewController ()

@end

@implementation PaymentSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [titleView setBackgroundColor:[UIColor clearColor]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:@"SELECT PAYMENT METHOD"];
    [titleLabel setFont:[UIFont phBlond:15]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleView addSubview:titleLabel];
    
    [self.navigationItem setTitleView:titleView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.visibleSize.width, self.visibleSize.height)];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.tableView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action 
- (void)tutorialButtonDidTap:(id)sender {
    NSLog(@"TEST");
    
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 1)];
    [topLine setBackgroundColor:[UIColor phLightGrayColor]];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 26, tableView.bounds.size.width, 1)];
    [bottomLine setBackgroundColor:[UIColor phLightGrayColor]];
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(14, 0, 320, 26);
    myLabel.font = [UIFont phBlond:12];
    myLabel.textColor = [UIColor blackColor];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 26)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    [headerView addSubview:myLabel];
    [headerView addSubview:topLine];
    [headerView addSubview:bottomLine];
    
    if (section == 1) {
        UIButton *tutorialButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [tutorialButton addTarget:self action:@selector(tutorialButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
        [tutorialButton setFrame:CGRectMake(162, 0, 120, 26)];
        [tutorialButton setBackgroundColor:[UIColor clearColor]];
        [tutorialButton setTitle:@"HOW IT WORKS?" forState:UIControlStateNormal];
        [tutorialButton setTitleColor:[UIColor phBlueColor] forState:UIControlStateNormal];
        [[tutorialButton titleLabel] setFont:[UIFont phBlond:11]];
        [[tutorialButton titleLabel] setTextAlignment:NSTextAlignmentLeft];
        [headerView addSubview:tutorialButton];
        
        UIView *blueBottomLine = [[UIView alloc] initWithFrame:CGRectMake(176, 20, 88, 1)];
        [blueBottomLine setBackgroundColor:[UIColor phBlueColor]];
        [headerView addSubview:blueBottomLine];
    }
    
    return headerView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"CREDIT CARD";
    }
    return @"VIRTUAL BANK TRANSFER";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *simpleTableIdentifier = @"AddPaymentCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            [cell.textLabel setFont:[UIFont phBlond:13]];
            
            UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 60, tableView.bounds.size.width, 1)];
            [bottomLine setBackgroundColor:[UIColor phLightGrayColor]];
            [[cell contentView] addSubview:bottomLine];
        }
        [cell.imageView setImage:[UIImage imageNamed:@"icon_add"]];
        [cell.textLabel setText:@"ADD CREDIT CARD"];
        [cell.textLabel setTextColor:[UIColor phPurpleColor]];
        
        return cell;
    }
    
    static NSString *simpleTableIdentifier = @"VirtualBankCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        [cell.textLabel setFont:[UIFont phBlond:13]];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 60, tableView.bounds.size.width, 1)];
        [bottomLine setBackgroundColor:[UIColor phLightGrayColor]];
        [[cell contentView] addSubview:bottomLine];
    }
    
    if (indexPath.row == 0) {
        [cell.imageView setImage:[UIImage imageNamed:@"logo_mandiri"]];
        [cell.textLabel setText:@"Mandiri Virtual Account"];
    } else if (indexPath.row == 1) {
        [cell.imageView setImage:[UIImage imageNamed:@"logo_mandiri"]];
        [cell.textLabel setText:@"Mandiri Virtual Account"];
    } else {
        [cell.imageView setImage:nil];
        [cell.textLabel setText:@"Other Banks"];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    if ([indexPath section] == 0) {
        AddPaymentViewController *addPaymentViewController = [[AddPaymentViewController alloc] init];
        [self presentViewController:addPaymentViewController animated:YES completion:nil];
    }
}

@end
