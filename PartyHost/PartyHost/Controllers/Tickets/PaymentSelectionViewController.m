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
#import "AnalyticManager.h"
#import "PaymentSelectionCell.h"

@interface PaymentSelectionViewController ()

@end

@implementation PaymentSelectionViewController

- (id)init {
    if ((self = [super init])) {
        self.sharedData = [SharedData sharedInstance];
        self.creditCardNew = [NSMutableArray array];
        self.paymentMethods = [NSMutableArray array];
        self.isCreditCardAllowed = NO;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorFromHexCode:@"F1F1F1"]];
    
    // Do any additional setup after loading the view.
    self.navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.visibleSize.width, 60)];
    [self.navBar setBackgroundColor:[UIColor phPurpleColor]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, self.visibleSize.width - 80, 40)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:@"Select Payment Method"];
    [titleLabel setFont:[UIFont phBlond:16]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.navBar addSubview:titleLabel];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(0.0f, 20.0f, 40.0f, 40.0f)];
    [closeButton setImageEdgeInsets:UIEdgeInsetsMake(8, 14, 8, 14)];
    [closeButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:closeButton];
    
    [self.view addSubview:self.navBar];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, self.visibleSize.width, self.visibleSize.height)];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.tableView];
    
    self.emptyView = [[EmptyView alloc] initWithFrame:CGRectMake(0, 60, self.visibleSize.width, self.view.bounds.size.height - 60)];
    [self.emptyView setData:@"No data found" subtitle:@"Sorry we're having some server issues, please check back in a few minutes." imageNamed:@""];
    [self.emptyView setMode:@"load"];
    [self.emptyView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.emptyView];
    
    [self loadData];
    
    // MixPanel
    SharedData *sharedData = [SharedData sharedInstance];
    [[AnalyticManager sharedManager] trackMixPanelWithDict:@"Payment Selection" withDict:sharedData.mixPanelCTicketDict];
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
- (void)closeButtonDidTap:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

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
    NSString *url = [NSString stringWithFormat:@"%@/product/payment_method",PHBaseNewURL];
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
                        NSMutableArray *paymentMethods = [data objectForKey:@"paymentmethod"];
                        if (paymentMethods && paymentMethods != nil) {
                            for (NSDictionary *paymentMethod in paymentMethods) {
                                if ([[paymentMethod objectForKey:@"type"] isEqualToString:@"cc"]) {
                                    if ([[paymentMethod objectForKey:@"status"] boolValue]) {
                                        self.isCreditCardAllowed = YES;
                                    }
                                } else {
                                    if ([[paymentMethod objectForKey:@"status"] boolValue]) {
                                        [self.paymentMethods addObject:[paymentMethod objectForKey:@"type"]];
                                    }
                                }
                            }
                        }
                    }
                    [self.tableView reloadData];
                    
                    if (self.isCreditCardAllowed) {
                        [self loadCreditCards];
                    } else {
                        [self.emptyView setMode:@"hide"];
                    }
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
            }
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.response.statusCode == 410) {
            [self reloadLoginWithFBToken:@"payment_method" andAdditionalInfo:nil];
        } else {
            [self.emptyView setMode:@"hide"];
        }
    }];
}

- (void)loadCreditCards {
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
        if (operation.response.statusCode == 410) {
            [self reloadLoginWithFBToken:@"credit_card" andAdditionalInfo:nil];
        } else {
            [self.emptyView setMode:@"hide"];
        }
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
        if (operation.response.statusCode == 410) {
            [self reloadLoginWithFBToken:@"delete_cc" andAdditionalInfo:maskedCard];
        }
    }];
    
}

- (void)reloadLoginWithFBToken:(NSString *)loadType andAdditionalInfo:(NSString *)info {
    SharedData *sharedData = [SharedData sharedInstance];
    
    [sharedData loginWithFBToken:^(AFHTTPRequestOperation *operation, id responseObject) {
        sharedData.ph_token = responseObject[@"data"][@"token"];
        if ([loadType isEqualToString:@"payment_method"]) {
            [self loadData];
        } else if ([loadType isEqualToString:@"credit_card"]) {
            [self loadCreditCards];
        } else if ([loadType isEqualToString:@"delete_cc"]) {
            [self deleteCard:info];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self reloadLoginWithFBToken:loadType andAdditionalInfo:info];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 && !self.isCreditCardAllowed) {
        return 0;
    } else if (section == 1) {
        return 0;
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return nil;
    }
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(14, 20, 320, 26);
    myLabel.font = [UIFont phBlond:13];
    myLabel.textColor = [UIColor darkGrayColor];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 26)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:myLabel];
    
    if (section == 2) {
        UIButton *tutorialButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [tutorialButton addTarget:self action:@selector(tutorialButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
        [tutorialButton setFrame:CGRectMake(132, 20, 120, 26)];
        [tutorialButton setBackgroundColor:[UIColor clearColor]];
        [tutorialButton setTitle:@"HOW IT WORKS?" forState:UIControlStateNormal];
        [tutorialButton setTitleColor:[UIColor phBlueColor] forState:UIControlStateNormal];
        [[tutorialButton titleLabel] setFont:[UIFont phBlond:11]];
        [[tutorialButton titleLabel] setTextAlignment:NSTextAlignmentLeft];
        [headerView addSubview:tutorialButton];
        
//        UIView *blueBottomLine = [[UIView alloc] initWithFrame:CGRectMake(176, 40, 90, 1)];
//        [blueBottomLine setBackgroundColor:[UIColor phBlueColor]];
//        [headerView addSubview:blueBottomLine];
    }
    
    return headerView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Credit Card";
    }
    return @"Virtual Bank Transfer";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.creditCardServer.count;
    } else if (section == 1) {
        if (self.isCreditCardAllowed) {
            return self.creditCardNew.count + 1;
        } else {
            return 0;
        }
    } else if (section == 2) {
        return self.paymentMethods.count;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1) {
        if (!self.isCreditCardAllowed) {
            return 0;
        }
    }
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath section] == 0) {
        static NSString *simpleTableIdentifier = @"ServerCreditCardCell";
        
        PaymentSelectionCell *cell = (PaymentSelectionCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[PaymentSelectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            cell.cellWidth = self.visibleSize.width;
        }
        
        NSDictionary *cardDetails = [self.creditCardServer objectAtIndex:indexPath.row];
        NSString *masked_card = [cardDetails objectForKey:@"masked_card"];
        NSString *cardSubstring = [masked_card substringFromIndex:masked_card.length - 4];
        
        NSString *firstDigit = [masked_card substringToIndex:1];
        UIImage *cardImage = nil;
        if ([firstDigit isEqualToString:@"4"]) {
            cardImage = [UIImage imageNamed:@"logo_visa"];
        } else if ([firstDigit isEqualToString:@"5"]) {
            cardImage = [UIImage imageNamed:@"logo_master"];
        }
        
        [cell setTitle:[NSString stringWithFormat:@"**** **** **** %@", cardSubstring] andImage:cardImage];
        
        return cell;
        
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == self.creditCardNew.count) {
            static NSString *simpleTableIdentifier = @"AddPaymentCell";
            
            PaymentSelectionCell *cell = (PaymentSelectionCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil) {
                cell = [[PaymentSelectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
                cell.cellWidth = self.visibleSize.width;
                
                UIImageView *iconPlus = [[UIImageView alloc] initWithFrame:CGRectMake(self.visibleSize.width - 46, 28, 16, 14)];
                [iconPlus setImage:[UIImage imageNamed:@"icon_plus_blue"]];
                [[cell contentView] addSubview:iconPlus];
            }
            
            [cell setTitle:@"ADD CREDIT CARD" andImage:nil];
            [cell.paymentTitle setFont:[UIFont phBlond:14]];
            [cell.paymentTitle setTextColor:[UIColor phBlueColor]];
            
            return cell;
        }
        
        static NSString *simpleTableIdentifier = @"NewCreditCardCell";
        
        PaymentSelectionCell *cell = (PaymentSelectionCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[PaymentSelectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            cell.cellWidth = self.visibleSize.width;
        }
        
        NSDictionary *cardDetails = [self.creditCardNew objectAtIndex:indexPath.row];
        NSString *cardNumber = [cardDetails objectForKey:@"card_number"];
        NSString *cardSubstring = [cardNumber substringFromIndex:cardNumber.length - 4];
        
        NSString *firstDigit = [cardNumber substringToIndex:1];
        UIImage *cardImage = nil;
        if ([firstDigit isEqualToString:@"4"]) {
             cardImage = [UIImage imageNamed:@"logo_visa"];
        } else if ([firstDigit isEqualToString:@"5"]) {
            cardImage = [UIImage imageNamed:@"logo_master"];
        }
        
        [cell setTitle:[NSString stringWithFormat:@"**** **** **** %@", cardSubstring] andImage:cardImage];
        
        return cell;
    }
    
    static NSString *simpleTableIdentifier = @"VirtualBankCell";
    
    PaymentSelectionCell *cell = (PaymentSelectionCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[PaymentSelectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        cell.cellWidth = self.visibleSize.width;
    }
    
    if ([[self.paymentMethods objectAtIndex:indexPath.row] isEqualToString:@"bca"]) {
        [cell setTitle:@"BCA Virtual Account" andImage:[UIImage imageNamed:@"logo_bca"]];
    } else if ([[self.paymentMethods objectAtIndex:indexPath.row] isEqualToString:@"bp"]) {
        [cell setTitle:@"Mandiri Virtual Account" andImage:[UIImage imageNamed:@"logo_mandiri"]];
    } else if ([[self.paymentMethods objectAtIndex:indexPath.row] isEqualToString:@"va"]) {
        [cell setTitle:@"Other Banks" andImage:nil];
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
        
            if (self.creditCardNew.count > 0) {
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                [prefs setObject:self.creditCardNew forKey:@"temp_da_list"];
                [prefs synchronize];
            } else {
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                [prefs removeObjectForKey:@"temp_da_list"];
                [prefs synchronize];
            }

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
        if ([[self.paymentMethods objectAtIndex:indexPath.row] isEqualToString:@"bca"]) {
            NSDictionary *paymentData = @{@"type":@"bca",
                                          @"is_new_card":@"0",
                                          @"token_id":@""};
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setObject:paymentData forKey:@"pdata"];
            [prefs synchronize];
            
            [[self navigationController] popViewControllerAnimated:YES];
        } else if ([[self.paymentMethods objectAtIndex:indexPath.row] isEqualToString:@"bp"]) {
            NSDictionary *paymentData = @{@"type":@"bp",
                                          @"is_new_card":@"0",
                                          @"token_id":@""};
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setObject:paymentData forKey:@"pdata"];
            [prefs synchronize];
            
            [[self navigationController] popViewControllerAnimated:YES];
        } else if ([[self.paymentMethods objectAtIndex:indexPath.row] isEqualToString:@"va"]) {
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
