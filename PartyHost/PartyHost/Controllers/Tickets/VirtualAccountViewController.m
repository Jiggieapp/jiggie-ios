//
//  VirtualAccountViewController.m
//  Jiggie
//
//  Created by Setiady Wiguna on 3/14/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "VirtualAccountViewController.h"
#import "PurchaseHistoryViewController.h"
#import "AnalyticManager.h"

@interface VirtualAccountViewController ()

@end

@implementation VirtualAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.navigationController setNavigationBarHidden:YES];   //it hides
    
    self.navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.visibleSize.width, 60)];
    [self.navBar setBackgroundColor:[UIColor phPurpleColor]];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, self.visibleSize.width - 80, 40)];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleLabel setFont:[UIFont phBlond:16]];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.navBar addSubview:self.titleLabel];
    
    if ([self.VAType isEqualToString:@"bca"]) {
        [self.titleLabel setText:@"BCA Virtual Account"];
    } else if ([self.VAType isEqualToString:@"bp"]) {
        [self.titleLabel setText:@"Mandiri Virtual Account"];
    } else if ([self.VAType isEqualToString:@"va"]) {
        [self.titleLabel setText:@"Bank Transfer"];
    }
    
    if (self.showCloseButton) {
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setFrame:CGRectMake(0.0f, 20.0f, 40.0f, 40.0f)];
        [closeButton setImageEdgeInsets:UIEdgeInsetsMake(8, 14, 8, 14)];
        [closeButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.navBar addSubview:closeButton];
    }

    [self.view addSubview:self.navBar];
    
    UIView *line1View = [[UIView alloc] initWithFrame:CGRectMake(0, 60, self.visibleSize.width, 1)];
    [line1View setBackgroundColor:[UIColor phLightGrayColor]];
    [line1View setHidden:YES];
    [self.view addSubview:line1View];
    
    // SCROLL VIEW
    
    CGFloat orderButtonSize = 0;
    if (self.showOrderButton) {
        orderButtonSize = 44;
    }
    
    UILabel *transferTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(line1View.frame) + 10, 140, 24)];
    [transferTimeLabel setText:@"Transfer time limit"];
    [transferTimeLabel setTextColor:[UIColor blackColor]];
    [transferTimeLabel setFont:[UIFont phBlond:13]];
    [transferTimeLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:transferTimeLabel];
    
    self.transferTime = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(line1View.frame) + 34, 200, 24)];
    [self.transferTime setText:@"Xh Xm"];
    [self.transferTime setTextColor:[UIColor phPurpleColor]];
    [self.transferTime setFont:[UIFont phBlond:16]];
    [self.transferTime setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.transferTime];
    
    UIView *lineVertical = [[UIView alloc] initWithFrame:CGRectMake(self.visibleSize.width/2, CGRectGetMaxY(line1View.frame) + 14 , 1, 40)];
    [lineVertical setBackgroundColor:[UIColor phLightGrayColor]];
    [self.view addSubview:lineVertical];
    
    UILabel *transferAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width/2 + 14, CGRectGetMaxY(line1View.frame) + 10, 140, 24)];
    [transferAmountLabel setText:@"Transfer amount"];
    [transferAmountLabel setTextColor:[UIColor blackColor]];
    [transferAmountLabel setFont:[UIFont phBlond:13]];
    [transferAmountLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:transferAmountLabel];
    
    self.transferAmount = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width/2 + 14, CGRectGetMaxY(line1View.frame) + 34, 140, 24)];
    [self.transferAmount setText:@"RpX.XXX K"];
    [self.transferAmount setTextColor:[UIColor phPurpleColor]];
    [self.transferAmount setFont:[UIFont phBlond:16]];
    [self.transferAmount setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.transferAmount];
    
    UILabel *transferToLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(line1View.frame) + 34 + 30, 140, 24)];
    [transferToLabel setText:@"Transfer To"];
    [transferToLabel setTextColor:[UIColor blackColor]];
    [transferToLabel setFont:[UIFont phBlond:13]];
    [transferToLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:transferToLabel];
    
    self.transferTo = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(line1View.frame) + 34 + 30 + 26, 200, 24)];
    [self.transferTo setText:@"XXXXXXXXXX"];
    [self.transferTo setTextColor:[UIColor phPurpleColor]];
    [self.transferTo setFont:[UIFont phBlond:16]];
    [self.transferTo setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.transferTo];
    
    UILabel *jiggieLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(line1View.frame) + 34 + 30 + 30 + 18, 200, 24)];
    [jiggieLabel setText:@"JIGGIE Teknologi Indonesia"];
    [jiggieLabel setTextColor:[UIColor blackColor]];
    [jiggieLabel setFont:[UIFont phBlond:13]];
    [jiggieLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:jiggieLabel];
    
    UIView *line2View = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line1View.frame) + 34 + 30 + 30 + 20 + 36, self.visibleSize.width, 1)];
    [line2View setBackgroundColor:[UIColor phLightGrayColor]];
    [self.view addSubview:line2View];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line2View.frame), self.visibleSize.width, self.view.bounds.size.height - CGRectGetMaxY(line2View.frame) - orderButtonSize - 42)];
    self.scrollView.showsVerticalScrollIndicator    = NO;
    self.scrollView.showsHorizontalScrollIndicator  = NO;
    self.scrollView.scrollEnabled                   = YES;
    self.scrollView.userInteractionEnabled          = YES;
    self.scrollView.backgroundColor                 = [UIColor whiteColor];
    self.scrollView.contentSize                     = CGSizeMake(self.visibleSize.width, 500);
    [self.view addSubview:self.scrollView];
    
    self.scrollView.contentSize = CGSizeMake(self.visibleSize.width, self.listY + 8);
    
    UILabel *starLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.bounds.size.height - orderButtonSize - 36, 8, 20)];
    [starLabel setText:@"*"];
    [starLabel setNumberOfLines:2];
    [starLabel setTextColor:[UIColor purpleColor]];
    [starLabel setFont:[UIFont phBlond:15]];
    [starLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:starLabel];
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, self.view.bounds.size.height - orderButtonSize - 40, self.visibleSize.width - 30 - 14, 40)];
    [infoLabel setText:@"We have also emailed you with these steps along with our Virtual Account number"];
    [infoLabel setNumberOfLines:2];
    [infoLabel setTextColor:[UIColor blackColor]];
    [infoLabel setFont:[UIFont phBlond:11]];
    [infoLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:infoLabel];
    
    if (self.showOrderButton) {
        UIButton *viewOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [viewOrderButton addTarget:self action:@selector(viewOrderButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
        [viewOrderButton setFrame:CGRectMake(0, self.view.bounds.size.height - orderButtonSize, self.visibleSize.width, orderButtonSize)];
        [viewOrderButton setBackgroundColor:[UIColor phBlueColor]];
        [viewOrderButton.titleLabel setFont:[UIFont phBold:15]];
        [viewOrderButton setTitle:@"VIEW BOOKINGS" forState:UIControlStateNormal];
        [viewOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:viewOrderButton];
    }
    
    self.emptyView = [[EmptyView alloc] initWithFrame:CGRectMake(0, 60, self.visibleSize.width, self.view.bounds.size.height - 60)];
    [self.emptyView setData:@"No data found" subtitle:@"Sorry we're having some server issues, please check back in a few minutes." imageNamed:@""];
    [self.emptyView setMode:@"load"];
    [self.emptyView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.emptyView];
    
    if ([self.VAType isEqualToString:@"tutorial"]) {
        [self.titleLabel setText:@"HOW TO PAY"];
        [self loadTutorialData];
        
        // MixPanel
        SharedData *sharedData = [SharedData sharedInstance];
        [[AnalyticManager sharedManager] trackMixPanelWithDict:@"VA Instruction" withDict:sharedData.mixPanelCTicketDict];
        
    } else {
        [self loadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (void)closeButtonDidTap:(id)sender {
    if (self.isModalScreen) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [[self navigationController] popViewControllerAnimated:YES];
    }
}

- (void)viewOrderButtonDidTap:(id)sender {
    PurchaseHistoryViewController *purchaseHistoryViewController = [[PurchaseHistoryViewController alloc] init];
    [purchaseHistoryViewController setIsModalScreen:YES];
    [self.navigationController pushViewController:purchaseHistoryViewController animated:YES];
}

#pragma mark - Data
- (void)loadData {
    SharedData *sharedData = [SharedData sharedInstance];
    AFHTTPRequestOperationManager *manager = [sharedData getOperationManager];

    //events/list/
    NSString *url = [NSString stringWithFormat:@"%@/product/success_screen/%@",PHBaseNewURL,self.orderID];
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
                        NSDictionary *success_screen = [data objectForKey:@"success_screen"];
                        if (success_screen && success_screen != nil) {
                            self.successData = success_screen;
                            [self populateData];
                            
                            
                            // MixPanel
                            NSDictionary *summary = [self.successData objectForKey:@"summary"];
                            if (summary && summary != nil) {
                                NSDictionary *summary = [self.successData objectForKey:@"summary"];
                                if (summary && summary != nil) {
                                    SharedData *sharedData = [SharedData sharedInstance];
                                    
                                    NSDictionary *productList = [[summary objectForKey:@"product_list"] objectAtIndex:0];
                                    if ([[productList objectForKey:@"ticket_type"] isEqualToString:@"booking"]) {
                                        [sharedData.mixPanelCTicketDict setObject:[productList objectForKey:@"num_buy"] forKey:@"Total Guest"];
                                    } else {
                                        [sharedData.mixPanelCTicketDict setObject:[productList objectForKey:@"num_buy"] forKey:@"Purchase Quantity"];
                                    }
                                    
                                    [sharedData.mixPanelCTicketDict setObject:[summary objectForKey:@"created_at"] forKey:@"Date Time"];
                                    [sharedData.mixPanelCTicketDict setObject:[productList objectForKey:@"total_price_all"] forKey:@"Purchase Amount"];
                                    [sharedData.mixPanelCTicketDict setObject:[self.successData objectForKey:@"payment_type"] forKey:@"Purchase Payment"];
                                    NSString *creditUsed = self.successData[@"credit"][@"credit_used"];
                                    if (creditUsed && ![creditUsed isEqual:[NSNull null]] && creditUsed.integerValue > 0) {
                                        [sharedData.mixPanelCTicketDict setObject:creditUsed forKey:@"Credit"];
                                    } else {
                                        [sharedData.mixPanelCTicketDict setObject:@"0" forKey:@"Credit"];
                                    }
                                    
                                    if (self.showOrderButton) {
                                        [[AnalyticManager sharedManager] trackMixPanelWithDict:@"Commerce Finish VA" withDict:sharedData.mixPanelCTicketDict];
                                    }
                                }
                            }
                        }
                    }
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
            [self.emptyView setMode:@"load"];
            [self reloadLoginWithFBToken:@"success_screen"];
        } else {
            [self.emptyView setMode:@"empty"];
        }
    }];
}

- (void)populateData {
    
    @try {
        NSString *payment_type = [self.successData objectForKey:@"payment_type"];
        if (payment_type && payment_type!= nil) {
            if ([payment_type isEqualToString:@"bca"]) {
                [self.titleLabel setText:@"BCA Virtual Account"];
            } else if ([payment_type isEqualToString:@"bp"]) {
                [self.titleLabel setText:@"Mandiri Virtual Account"];
            } else if ([payment_type isEqualToString:@"va"]) {
                [self.titleLabel setText:@"Bank Transfer"];
            } else {
                [self.titleLabel setText:@"How To Pay"];
            }
        }
        
        NSString *payment_status = [self.successData objectForKey:@"payment_status"];
        if (payment_status && payment_status != nil && [payment_status isEqualToString:@"expire"]) {
            [self.transferTime setText:@"Expired"];
            
        } else {
            NSString *timelimit = [self.successData objectForKey:@"timelimit"];
            if (timelimit && timelimit != nil) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:PHDateFormatServer];
                [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
                [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
                NSDate *timelimitDate = [formatter dateFromString:timelimit];
                
                [self populateTimeLimit:timelimitDate];
            }
        }
       
        NSString *amount = [[self.successData objectForKey:@"amount"] stringValue];
        if (amount && amount!= nil) {
            SharedData *sharedData = [SharedData sharedInstance];
            NSString *formattedPrice = [sharedData formatCurrencyString:amount];
            
            [self.transferAmount setText:[NSString stringWithFormat:@"Rp%@",formattedPrice]];
        }
        
        NSString *transfer_to = [self.successData objectForKey:@"transfer_to"];
        if (transfer_to && transfer_to != nil) {
            [self.transferTo setText:transfer_to];
        }
        
        NSArray *stepPayments = [self.successData objectForKey:@"step_payment"];
        self.listY = 10;
        for (NSDictionary *stepPayment in stepPayments) {
            NSString *header = [stepPayment objectForKey:@"header"];
            if (header && header != nil) {
                UILabel *stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, self.listY, self.visibleSize.width - 28, 40)];
                [stepLabel setText:header];
                [stepLabel setTextColor:[UIColor blackColor]];
                [stepLabel setFont:[UIFont phBlond:13]];
                [stepLabel setBackgroundColor:[UIColor clearColor]];
                [stepLabel setNumberOfLines:2];
                [stepLabel sizeToFit];
                [self.scrollView addSubview:stepLabel];
                
                UIView *line3View = [[UIView alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(stepLabel.frame) + 8, 60, 3)];
                [line3View setBackgroundColor:[UIColor phLightGrayColor]];
                [self.scrollView addSubview:line3View];
                
                self.listY = CGRectGetMaxY(line3View.frame) + 12;
                
                UILabel *lineVertical = [[UILabel alloc] initWithFrame:CGRectMake(26, self.listY + 26, 1, self.listY - CGRectGetMaxY(line3View.frame) - 30)];
                [lineVertical setBackgroundColor:[UIColor phLightGrayColor]];
                [self.scrollView addSubview:lineVertical];
                
                NSArray *steps = [stepPayment objectForKey:@"steps"];
                if (steps && steps != nil) {
                    NSInteger count = 1;
                    for (NSString *step in steps) {
                        UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
                        [iconButton setBackgroundImage:[UIImage imageNamed:@"icon_purple"] forState:UIControlStateNormal];
                        [iconButton setFrame:CGRectMake(14, self.listY + 8, 24, 24)];
                        [iconButton setEnabled:NO];
                        [iconButton setTitle:[NSString stringWithFormat:@"%li", count] forState:UIControlStateNormal];
                        [iconButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [[iconButton titleLabel] setFont:[UIFont phBlond:13]];
                        [iconButton setAdjustsImageWhenDisabled:NO];
                        [self.scrollView addSubview:iconButton];
                        
                        UILabel *termLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, self.listY, self.visibleSize.width - 60 - 14, 40)];
                        [termLabel setText:step];
                        [termLabel setFont:[UIFont phBlond:12]];
                        [termLabel setTextColor:[UIColor blackColor]];
                        [termLabel setAdjustsFontSizeToFitWidth:YES];
                        [termLabel setBackgroundColor:[UIColor clearColor]];
                        [termLabel setNumberOfLines:3];
                        [self.scrollView addSubview:termLabel];
                        
                        self.listY += 48;
                        count++;
                    }
                    
                    [lineVertical setFrame:CGRectMake(lineVertical.frame.origin.x, lineVertical.frame.origin.y, lineVertical.bounds.size.width, self.listY - CGRectGetMaxY(line3View.frame) - 50)];
                    self.listY += 20;
                }
            }
        }
        
        self.scrollView.contentSize = CGSizeMake(self.visibleSize.width, self.listY + 8);
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (void)populateTimeLimit:(NSDate *)timelimitDate {
    NSDate *currentDate = [NSDate date];

    if ([timelimitDate timeIntervalSinceDate:currentDate] > 0) {
        unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSWeekCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [gregorian components:unitFlags fromDate:currentDate  toDate:timelimitDate  options:0];
        
        [self.transferTime setText:[NSString stringWithFormat:@"%02li:%02li:%02li", (long)comps.hour, (long)comps.minute, (long)comps.second]];
        
        if ([self isViewLoaded]) {
            [self performSelector:@selector(populateTimeLimit:) withObject:timelimitDate afterDelay:1.0];
        }
    } else {
        [self.transferTime setText:@"Expired"];
    }
}

- (void)loadTutorialData {
    SharedData *sharedData = [SharedData sharedInstance];
    AFHTTPRequestOperationManager *manager = [sharedData getOperationManager];
    
    //events/list/
    NSString *url = [NSString stringWithFormat:@"%@/product/walkthrough_payment",PHBaseNewURL];
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
                        NSDictionary *walkthrough_payment = [data objectForKey:@"walkthrough_payment"];
                        if (walkthrough_payment && walkthrough_payment != nil) {
                            self.successData = walkthrough_payment;
                            [self populateTutorialData];
                        }
                    }
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
            [self.emptyView setMode:@"load"];
            [self reloadLoginWithFBToken:@"walkthrough_payment"];
        } else {
            [self.emptyView setMode:@"empty"];
        }
    }];
}

- (void)reloadLoginWithFBToken:(NSString *)loadType {
    SharedData *sharedData = [SharedData sharedInstance];
    
    [sharedData loginWithFBToken:^(AFHTTPRequestOperation *operation, id responseObject) {
        sharedData.ph_token = responseObject[@"data"][@"token"];
        if ([loadType isEqualToString:@"walkthrough_payment"]) {
            [self loadTutorialData];
        } else if ([loadType isEqualToString:@"success_screen"]) {
            [self loadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self reloadLoginWithFBToken:loadType];
    }];
}

- (void)populateTutorialData {
    @try {
        NSMutableArray *stepPayments = [NSMutableArray array];
        
        NSDictionary *va_step = [self.successData objectForKey:@"va_step"];
        if (va_step && va_step != nil) {
            NSArray *step_payment = [va_step objectForKey:@"step_payment"];
            if (step_payment) {
                [stepPayments addObjectsFromArray:step_payment];
            }
        }
        
        NSDictionary *bp_step = [self.successData objectForKey:@"bp_step"];
        if (bp_step && bp_step != nil) {
            NSArray *step_payment = [va_step objectForKey:@"step_payment"];
            if (step_payment) {
                [stepPayments addObjectsFromArray:step_payment];
            }
        }
        
        self.listY = 10;
        for (NSDictionary *stepPayment in stepPayments) {
            NSString *header = [stepPayment objectForKey:@"header"];
            if (header && header != nil) {
                UILabel *stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, self.listY, self.visibleSize.width - 28, 40)];
                [stepLabel setText:header];
                [stepLabel setTextColor:[UIColor blackColor]];
                [stepLabel setFont:[UIFont phBlond:13]];
                [stepLabel setBackgroundColor:[UIColor clearColor]];
                [stepLabel setNumberOfLines:2];
                [stepLabel sizeToFit];
                [self.scrollView addSubview:stepLabel];
                
                UIView *line3View = [[UIView alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(stepLabel.frame) + 8, 60, 3)];
                [line3View setBackgroundColor:[UIColor phLightGrayColor]];
                [self.scrollView addSubview:line3View];
                
                self.listY = CGRectGetMaxY(line3View.frame) + 12;
                
                UILabel *lineVertical = [[UILabel alloc] initWithFrame:CGRectMake(26, self.listY + 26, 1, self.listY - CGRectGetMaxY(line3View.frame) - 30)];
                [lineVertical setBackgroundColor:[UIColor phLightGrayColor]];
                [self.scrollView addSubview:lineVertical];
                
                NSArray *steps = [stepPayment objectForKey:@"steps"];
                if (steps && steps != nil) {
                    NSInteger count = 1;
                    for (NSString *step in steps) {
                        UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
                        [iconButton setBackgroundImage:[UIImage imageNamed:@"icon_purple"] forState:UIControlStateNormal];
                        [iconButton setFrame:CGRectMake(14, self.listY + 8, 24, 24)];
                        [iconButton setEnabled:NO];
                        [iconButton setTitle:[NSString stringWithFormat:@"%li", count] forState:UIControlStateNormal];
                        [iconButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [[iconButton titleLabel] setFont:[UIFont phBlond:13]];
                        [iconButton setAdjustsImageWhenDisabled:NO];
                        [self.scrollView addSubview:iconButton];
                        
                        UILabel *termLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, self.listY, self.visibleSize.width - 60 - 14, 40)];
                        [termLabel setText:step];
                        [termLabel setFont:[UIFont phBlond:12]];
                        [termLabel setTextColor:[UIColor blackColor]];
                        [termLabel setAdjustsFontSizeToFitWidth:YES];
                        [termLabel setBackgroundColor:[UIColor clearColor]];
                        [termLabel setNumberOfLines:3];
                        [self.scrollView addSubview:termLabel];
                        
                        self.listY += 48;
                        count++;
                    }
                    
                    [lineVertical setFrame:CGRectMake(lineVertical.frame.origin.x, lineVertical.frame.origin.y, lineVertical.bounds.size.width, self.listY - CGRectGetMaxY(line3View.frame) - 50)];
                    self.listY += 20;
                }
            }
        }
        
        self.scrollView.contentSize = CGSizeMake(self.visibleSize.width, self.listY + 8);
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

@end
