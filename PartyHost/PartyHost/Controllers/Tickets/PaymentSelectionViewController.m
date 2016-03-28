//
//  PaymentSelectionViewController.m
//  Jiggie
//
//  Created by Setiady Wiguna on 3/10/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "PaymentSelectionViewController.h"
#import "AddPaymentViewController.h"
#import "VirtualAccountViewController.h"

@interface PaymentSelectionViewController ()

@end

@implementation PaymentSelectionViewController

- (id)init {
    if ((self = [super init])) {
        self.sharedData = [SharedData sharedInstance];
        self.creditCardNew = [NSMutableArray array];
    }
    
    return self;
}

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
    
    self.emptyView = [[EmptyView alloc] initWithFrame:CGRectMake(0, 0, self.visibleSize.width, self.visibleSize.height)];
    [self.emptyView setData:@"No data found" subtitle:@"Sorry we're having some server issues, please check back in a few minutes." imageNamed:@""];
    [self.emptyView setMode:@"load"];
    [self.emptyView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.emptyView];
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary *cardDetails = [prefs objectForKey:@"temp_da"];
    if (cardDetails && cardDetails != nil) {
        if ([prefs objectForKey:@"temp_da_list"] && [prefs objectForKey:@"temp_da_list"]!= nil) {
            NSArray *list = [prefs objectForKey:@"temp_da_list"];
            NSMutableArray *newList = [NSMutableArray arrayWithArray:list];
            [newList addObject:cardDetails];
            [prefs setObject:newList forKey:@"temp_da_list"];
            
        } else {
            NSMutableArray *list = [NSMutableArray array];
            [list addObject:cardDetails];
            [prefs setObject:list forKey:@"temp_da_list"];
        }
        
        [prefs removeObjectForKey:@"temp_da"];
        [prefs synchronize];
    }
    
    if ([prefs objectForKey:@"temp_da_list"] && [prefs objectForKey:@"temp_da_list"]!= nil) {
        self.creditCardNew = [NSMutableArray arrayWithArray:[prefs objectForKey:@"temp_da_list"]];
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action 
- (void)tutorialButtonDidTap:(id)sender {
    VirtualAccountViewController *virtualAccountViewController = [[VirtualAccountViewController alloc] init];
    virtualAccountViewController.isModalScreen = YES;
    virtualAccountViewController.showCloseButton = YES;
    virtualAccountViewController.showOrderButton = NO;
    virtualAccountViewController.VAType = @"tutorial";
    [self presentViewController:virtualAccountViewController animated:YES completion:nil];
}

#pragma mark - Data
- (void)loadData {
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    //events/list/
    NSString *url = [NSString stringWithFormat:@"%@/product/credit_card/%@",PHBaseNewURL,self.sharedData.fb_id];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSInteger responseStatusCode = operation.response.statusCode;
        if (responseStatusCode != 200) {
            [self.emptyView setMode:@"hide"];
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
                        NSMutableArray *creditcard_informations = [data objectForKey:@"creditcard_informations"];
                        if (creditcard_informations && creditcard_informations != nil) {
                            self.creditCardServer = [NSMutableArray arrayWithArray:creditcard_informations];
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
        [self.emptyView setMode:@"hide"];
    }];
}

- (void)deleteCard:(NSString *)maskedCard {
    SharedData *sharedData = [SharedData sharedInstance];
    AFHTTPRequestOperationManager *manager = [sharedData getOperationManager];
    NSString *url = [NSString stringWithFormat:@"%@/product/delete_cc",PHBaseNewURL];
    
    NSDictionary *params = @{@"fb_id":sharedData.fb_id,
                             @"masked_card":maskedCard};
                             
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSInteger responseStatusCode = operation.response.statusCode;
        if (responseStatusCode != 200) {
            return;
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 0;
    }
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return nil;
    }
    
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
    
    if (section == 2) {
        UIButton *tutorialButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [tutorialButton addTarget:self action:@selector(tutorialButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
        [tutorialButton setFrame:CGRectMake(162, 0, 120, 26)];
        [tutorialButton setBackgroundColor:[UIColor clearColor]];
        [tutorialButton setTitle:@"HOW IT WORKS?" forState:UIControlStateNormal];
        [tutorialButton setTitleColor:[UIColor phBlueColor] forState:UIControlStateNormal];
        [[tutorialButton titleLabel] setFont:[UIFont phBlond:11]];
        [[tutorialButton titleLabel] setTextAlignment:NSTextAlignmentLeft];
        [headerView addSubview:tutorialButton];
        
        UIView *blueBottomLine = [[UIView alloc] initWithFrame:CGRectMake(176, 20, 90, 1)];
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
        return self.creditCardServer.count;
    } else if (section == 1) {
        return self.creditCardNew.count + 1;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath section] == 0) {
        static NSString *simpleTableIdentifier = @"ServerCreditCardCell";
        
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            [cell.textLabel setFont:[UIFont phBlond:13]];
            
            UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 60, tableView.bounds.size.width, 1)];
            [bottomLine setBackgroundColor:[UIColor phLightGrayColor]];
            [[cell contentView] addSubview:bottomLine];
        }
        
        NSDictionary *cardDetails = [self.creditCardServer objectAtIndex:indexPath.row];
        NSString *masked_card = [cardDetails objectForKey:@"masked_card"];
        NSString *cardSubstring = [masked_card substringFromIndex:masked_card.length - 4];
        
        [cell.textLabel setText:[NSString stringWithFormat:@"**** **** **** %@", cardSubstring]];
        
        NSString *firstDigit = [masked_card substringToIndex:1];
        if ([firstDigit isEqualToString:@"4"]) {
            [cell.imageView setImage:[UIImage imageNamed:@"logo_visa"]];
        } else if ([firstDigit isEqualToString:@"5"]) {
            [cell.imageView setImage:[UIImage imageNamed:@"logo_master"]];
        } else {
            [cell.imageView setImage:nil];
        }
        
        return cell;
        
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == self.creditCardNew.count) {
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
        
        static NSString *simpleTableIdentifier = @"NewCreditCardCell";
        
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            [cell.textLabel setFont:[UIFont phBlond:13]];
            
            UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 60, tableView.bounds.size.width, 1)];
            [bottomLine setBackgroundColor:[UIColor phLightGrayColor]];
            [[cell contentView] addSubview:bottomLine];
        }
        
        NSDictionary *cardDetails = [self.creditCardNew objectAtIndex:indexPath.row];
        NSString *cardNumber = [cardDetails objectForKey:@"card_number"];
        NSString *cardSubstring = [cardNumber substringFromIndex:cardNumber.length - 4];
        
        [cell.textLabel setText:[NSString stringWithFormat:@"**** **** **** %@", cardSubstring]];
        
        NSString *firstDigit = [cardNumber substringToIndex:1];
        if ([firstDigit isEqualToString:@"4"]) {
            [cell.imageView setImage:[UIImage imageNamed:@"logo_visa"]];
        } else if ([firstDigit isEqualToString:@"5"]) {
            [cell.imageView setImage:[UIImage imageNamed:@"logo_master"]];
        } else {
            [cell.imageView setImage:nil];
        }
        
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
    } else {
        [cell.imageView setImage:nil];
        [cell.textLabel setText:@"Other Banks"];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    if ([indexPath section] == 1) {
        if (indexPath.row == self.creditCardNew.count) {
            return NO;
        }
    } else if (indexPath.section == 2) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        if ([indexPath section] == 0) {
            NSDictionary *selectedCard = [self.creditCardServer objectAtIndex:indexPath.row];
            if ([selectedCard objectForKey:@"masked_card"] && [selectedCard objectForKey:@"masked_card"]!= nil) {
                [self deleteCard:[selectedCard objectForKey:@"masked_card"]];
            }
            
            [self.creditCardServer removeObjectAtIndex:indexPath.row];
            [tableView reloadData];
            
        } else if ([indexPath section] == 1) {
            [self.creditCardNew removeObjectAtIndex:indexPath.row];
        
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setObject:self.creditCardNew forKey:@"temp_da_list"];
            [prefs synchronize];
            
            [tableView reloadData];
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    if ([indexPath section] == 0) {
        NSDictionary *selectedCard = [self.creditCardServer objectAtIndex:indexPath.row];
        NSDictionary *paymentData = @{@"type":@"cc",
                                      @"is_new_card":@"0",
                                      @"token_id":[selectedCard objectForKey:@"saved_token_id"],
                                      @"masked_card":[selectedCard objectForKey:@"masked_card"]};
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:paymentData forKey:@"pdata"];
        [prefs synchronize];
        
        [[self navigationController] popViewControllerAnimated:YES];
        
    } else if ([indexPath section] == 1) {
        if (indexPath.row == self.creditCardNew.count) {
            AddPaymentViewController *addPaymentViewController = [[AddPaymentViewController alloc] init];
            addPaymentViewController.productList = self.productList;
            
            [self presentViewController:addPaymentViewController animated:YES completion:nil];
            
        } else {
            NSDictionary *selectedCard = [self.creditCardNew objectAtIndex:indexPath.row];
            NSDictionary *paymentData = @{@"type":@"cc",
                                          @"is_new_card":@"1",
                                          @"token_id":@"",
                                          @"content":selectedCard};
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setObject:paymentData forKey:@"pdata"];
            [prefs synchronize];
            
            [[self navigationController] popViewControllerAnimated:YES];
        }
        
    } else if ([indexPath section] == 2) {
        if (indexPath.row == 0) {
            NSDictionary *paymentData = @{@"type":@"bp",
                                          @"is_new_card":@"0",
                                          @"token_id":@""};
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setObject:paymentData forKey:@"pdata"];
            [prefs synchronize];
            
            [[self navigationController] popViewControllerAnimated:YES];
        } else {
            NSDictionary *paymentData = @{@"type":@"va",
                                          @"is_new_card":@"0",
                                          @"token_id":@""};
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setObject:paymentData forKey:@"pdata"];
            [prefs synchronize];
            
            [[self navigationController] popViewControllerAnimated:YES];
        }
    }
}

@end
