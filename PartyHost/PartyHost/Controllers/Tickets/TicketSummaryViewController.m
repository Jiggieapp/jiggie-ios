//
//  TicketSummaryViewController.m
//  Jiggie
//
//  Created by Setiady Wiguna on 2/11/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "TicketSummaryViewController.h"
#import <MessageUI/MessageUI.h>

#import "GuestDetailViewController.h"
#import "TicketConfirmationViewController.h"
#import "UserManager.h"
#import "SVProgressHUD.h"
#import "AnalyticManager.h"

@interface TicketSummaryViewController ()

@end

@implementation TicketSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUserInfo];
    
    // Remove nav bar shadow
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [titleView setBackgroundColor:[UIColor clearColor]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:@"TICKET DETAIL"];
    [titleLabel setFont:[UIFont phBlond:13]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleView addSubview:titleLabel];
    
    UIImageView *titleIcon = [[UIImageView alloc] initWithFrame:CGRectMake(65, 28, 71, 5)];
    [titleIcon setImage:[UIImage imageNamed:@"icon_step_2"]];
    [titleView addSubview:titleIcon];
    
    [self.navigationItem setTitleView:titleView];
    
    UIButton *helpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [helpButton setFrame:CGRectMake(0.0f, 0.0f, 40.0f, 30.0f)];
    [helpButton setImage:[UIImage imageNamed:@"button_help"] forState:UIControlStateNormal];
    [helpButton addTarget:self action:@selector(helpButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *helpBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:helpButton];
    
    [[self navigationItem] setRightBarButtonItem:helpBarButtonItem];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    // SCROLL VIEW
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.visibleSize.width, self.visibleSize.height - 44 - 80 - 80)];
    self.scrollView.showsVerticalScrollIndicator    = NO;
    self.scrollView.showsHorizontalScrollIndicator  = NO;
    self.scrollView.scrollEnabled                   = YES;
    self.scrollView.userInteractionEnabled          = YES;
    self.scrollView.backgroundColor                 = [UIColor whiteColor];
    self.scrollView.contentSize                     = CGSizeMake(self.visibleSize.width, 500);
    [self.view addSubview:self.scrollView];
    
    UIView *tmpPurpleView = [[UIView alloc] initWithFrame:CGRectMake(0, -300, self.visibleSize.width, 300)];
    tmpPurpleView.backgroundColor = [UIColor phPurpleColor];
    [self.scrollView addSubview:tmpPurpleView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 80)];
    [headerView setBackgroundColor:[UIColor phPurpleColor]];
    
    self.summaryHeaderTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, self.view.bounds.size.width, 16)];
    [self.summaryHeaderTitle setFont:[UIFont phBlond:15]];
    [self.summaryHeaderTitle setTextColor:[UIColor whiteColor]];
    [self.summaryHeaderTitle setBackgroundColor:[UIColor clearColor]];
    [self.summaryHeaderTitle setTextAlignment:NSTextAlignmentCenter];
    [headerView addSubview:self.summaryHeaderTitle];
    
    self.summaryHeaderDescription = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, self.view.bounds.size.width, 16)];
    [self.summaryHeaderDescription setFont:[UIFont phBlond:12]];
    [self.summaryHeaderDescription setTextColor:[UIColor whiteColor]];
    [self.summaryHeaderDescription setBackgroundColor:[UIColor clearColor]];
    [self.summaryHeaderDescription setTextAlignment:NSTextAlignmentCenter];
    [headerView addSubview:self.summaryHeaderDescription];
    
    [self.scrollView addSubview:headerView];
    
    NSString *event_name = [self.productList objectForKey:@"event_name"];
    if (event_name && event_name != nil) {
        self.summaryHeaderTitle.text = event_name;
    }
    
    NSString *venue_name = [self.productList objectForKey:@"venue_name"];
    
    NSString *start_datetime = [self.productList objectForKey:@"start_datetime"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:PHDateFormatServer];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSDate *startDatetime = [formatter dateFromString:start_datetime];
    
    [formatter setDateFormat:PHDateFormatAppShort];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *shortDateTime = [formatter stringFromDate:startDatetime];
    
    self.summaryHeaderDescription.text = [NSString stringWithFormat:@"%@ - %@", shortDateTime, venue_name];
    
    CGFloat ticketTitleWidth = self.visibleSize.width/2;
    
    UILabel *ticketTitle = [[UILabel alloc] initWithFrame:CGRectMake(14, 80 + 8, ticketTitleWidth + 10, 20)];
    [ticketTitle setFont:[UIFont phBlond:14]];
    [ticketTitle setTextColor:[UIColor darkGrayColor]];
    [ticketTitle setBackgroundColor:[UIColor clearColor]];
    [ticketTitle setAdjustsFontSizeToFitWidth:YES];
    [self.scrollView addSubview:ticketTitle];
    
    UILabel *ticketSubtitle = [[UILabel alloc] initWithFrame:CGRectMake(14, 80 + 30, ticketTitleWidth + 10, 20)];
    [ticketSubtitle setFont:[UIFont phBlond:13]];
    [ticketSubtitle setTextColor:[UIColor darkGrayColor]];
    [ticketSubtitle setBackgroundColor:[UIColor clearColor]];
    [ticketTitle setAdjustsFontSizeToFitWidth:YES];
    [self.scrollView addSubview:ticketSubtitle];
    
    UILabel *ticketPrice = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 140, 80 + 8, 120, 20)];
    [ticketPrice setFont:[UIFont phBlond:14]];
    [ticketPrice setTextColor:[UIColor darkGrayColor]];
    [ticketPrice setBackgroundColor:[UIColor clearColor]];
    [ticketPrice setTextAlignment:NSTextAlignmentRight];
    [self.scrollView addSubview:ticketPrice];
    
    UILabel *ticketPerson = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 140, 80 + 30, 120, 20)];
    [ticketPerson setFont:[UIFont phBlond:13]];
    [ticketPerson setTextColor:[UIColor darkGrayColor]];
    [ticketPerson setBackgroundColor:[UIColor clearColor]];
    [ticketPerson setTextAlignment:NSTextAlignmentRight];
    [self.scrollView addSubview:ticketPerson];
    
    NSString *name = [self.productSelected objectForKey:@"name"];
    if (name && name != nil) {
        [ticketTitle setText:name];
    }
    
    NSString *summary = [self.productSelected objectForKey:@"summary"];
    if (summary && summary != nil) {
        [ticketSubtitle setText:summary];
    }
    
    NSString *total_price = [self.productSelected objectForKey:@"price"];
    if (total_price && total_price != nil) {
        SharedData *sharedData = [SharedData sharedInstance];
        NSString *formattedPrice = [sharedData formatCurrencyString:total_price];
        [ticketPrice setText:[NSString stringWithFormat:@"Rp%@", formattedPrice]];
    }
    
    if (self.isTicketProduct) {
        NSString *max_purchase = [self.productSelected objectForKey:@"max_purchase"];
        if (max_purchase && max_purchase != nil) {
            [ticketPerson setText:[NSString stringWithFormat:@"Max Purchased %@", max_purchase]];
        }
    } else {
        NSString *max_guests = [self.productSelected objectForKey:@"max_guests"];
        if (max_guests && max_guests != nil) {
            [ticketPerson setText:[NSString stringWithFormat:@"Max Guest %@", max_guests]];
        }
    }

    //  LINE 1 VIEW
    
    UIView *line1View = [[UIView alloc] initWithFrame:CGRectMake(0, 80 + 60, self.visibleSize.width, 1)];
    [line1View setBackgroundColor:[UIColor phLightGrayColor]];
    [self.scrollView addSubview:line1View];
    
    UITextView *ticketDescription = [[UITextView alloc] initWithFrame:CGRectMake(14, 80 + 60 + 10, self.visibleSize.width - 28, 0)];
    ticketDescription.font = [UIFont phBlond:13];
    ticketDescription.textColor = [UIColor darkGrayColor];
    ticketDescription.textAlignment = NSTextAlignmentLeft;
    ticketDescription.userInteractionEnabled = NO;
    ticketDescription.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:ticketDescription];
    
    NSString *description = [self.productSelected objectForKey:@"description"];
    if (description && description != nil) {
        ticketDescription.text = description;
        [ticketDescription sizeToFit];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.visibleSize.width, ticketDescription.frame.origin.y + ticketDescription.frame.size.height + 12);
    
     // LINE 2 VIEW
    
    UIView *line2View = [[UIView alloc] initWithFrame:CGRectMake(0, self.visibleSize.height - 44 - 80 - 80, self.visibleSize.width, 1)];
    [line2View setBackgroundColor:[UIColor phLightGrayColor]];
    [self.view addSubview:line2View];
    
    self.userName = [[UILabel alloc] initWithFrame:CGRectMake(18, line2View.frame.origin.y + 14, self.visibleSize.width - 70, 18)];
    [self.userName setFont:[UIFont phBlond:13]];
    [self.userName setTextColor:[UIColor blackColor]];
    [self.userName setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.userName];
    
    self.userEmail = [[UILabel alloc] initWithFrame:CGRectMake(18, line2View.frame.origin.y + 14 + 18, self.visibleSize.width - 70, 18)];
    [self.userEmail setFont:[UIFont phBlond:13]];
    [self.userEmail setTextColor:[UIColor blackColor]];
    [self.userEmail setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.userEmail];
    
    self.userPhone = [[UILabel alloc] initWithFrame:CGRectMake(18, line2View.frame.origin.y + 14 + 36, self.visibleSize.width - 70, 18)];
    [self.userPhone setFont:[UIFont phBlond:13]];
    [self.userPhone setTextColor:[UIColor blackColor]];
    [self.userPhone setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.userPhone];
    
    UIImageView *accessory = [[UIImageView alloc] initWithFrame:CGRectMake(self.visibleSize.width - 24, line2View.frame.origin.y + 14 + 20, 8, 13)];
    [accessory setImage:[UIImage imageNamed:@"icon_purple_arrow"]];
    [self.view addSubview:accessory];
    
    self.userDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.userDetailButton setFrame:CGRectMake(0, self.visibleSize.height - 44 - 80 - 80, self.visibleSize.width, 80)];
    [self.userDetailButton addTarget:self action:@selector(userDetailButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.userDetailButton setBackgroundColor:[UIColor clearColor]];
    [self.userDetailButton setHighlighted:YES];
    [self.view addSubview:self.userDetailButton];
    
    // LINE 3 VIEW
    
    UIView *line3View = [[UIView alloc] initWithFrame:CGRectMake(0, self.visibleSize.height - 44 - 80, self.visibleSize.width, 1)];
    [line3View setBackgroundColor:[UIColor phLightGrayColor]];
    [self.view addSubview:line3View];
    
    UILabel *estimatedLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, line3View.frame.origin.y + 14, 100, 20)];
    [estimatedLabel setFont:[UIFont phBlond:11]];
    [estimatedLabel setTextColor:[UIColor blackColor]];
    [estimatedLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:estimatedLabel];
    
    if (self.isTicketProduct) {
        [estimatedLabel setText:@"ESTIMATED COST"];
    } else {
        [estimatedLabel setText:@"MINIMUM SPEND"];
    }
    
    self.totalPrice = [[UILabel alloc] initWithFrame:CGRectMake(14, line3View.frame.origin.y + 14 + 24, 160, 24)];
    [self.totalPrice setFont:[UIFont phBlond:20]];
    [self.totalPrice setTextColor:[UIColor blackColor]];
    [self.totalPrice setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.totalPrice];
    
    NSString *price = [self.productSelected objectForKey:@"price"];
    if (price && price != nil) {
        self.price = price.integerValue;
        
        SharedData *sharedData = [SharedData sharedInstance];
        NSString *formattedPrice = [sharedData formatCurrencyString:price];
        [self.totalPrice setText:[NSString stringWithFormat:@"Rp%@", formattedPrice]];
    }
    
    UILabel *ticketLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 130, line3View.frame.origin.y + 14, 120, 20)];
    [ticketLabel setText:@"TICKETS"];
    [ticketLabel setFont:[UIFont phBlond:11]];
    [ticketLabel setTextColor:[UIColor blackColor]];
    [ticketLabel setBackgroundColor:[UIColor clearColor]];
    [ticketLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:ticketLabel];
    
    if (self.isTicketProduct) {
        [ticketLabel setText:@"TICKETS"];
    } else {
        [ticketLabel setText:@"NUMBER OF GUEST"];
    }
    
    UIButton *plusButton = [[UIButton alloc] initWithFrame:CGRectMake(self.visibleSize.width - 40 - 5, line3View.frame.origin.y + 14 + 20, 34, 34)];
    [plusButton setImage:[UIImage imageNamed:@"icon_plus"] forState:UIControlStateNormal];
    [plusButton addTarget:self action:@selector(plusButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:plusButton];
    
    self.totalTicket = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 40 - 50, line3View.frame.origin.y + 14 + 24, 40, 24)];
    [self.totalTicket setFont:[UIFont phBlond:18]];
    [self.totalTicket setTextColor:[UIColor blackColor]];
    [self.totalTicket setBackgroundColor:[UIColor clearColor]];
    [self.totalTicket setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:self.totalTicket];
    
    [self.totalTicket setText:@"1"];
    
    self.maxAmount = 1;
    if (self.isTicketProduct) {
        NSString *max_purchase = [self.productSelected objectForKey:@"max_purchase"];
        if (max_purchase && max_purchase != nil && max_purchase.length > 0) {
            self.maxAmount = max_purchase.integerValue;
        }
    } else {
        NSString *max_guests = [self.productSelected objectForKey:@"max_guests"];
        if (max_guests && max_guests != nil && max_guests.length > 0) {
            self.maxAmount = max_guests.integerValue;
        }
    }
    
    UIButton *minusButton = [[UIButton alloc] initWithFrame:CGRectMake(self.visibleSize.width - 40 - 50 - 40, line3View.frame.origin.y + 14 + 20, 34, 34)];
    [minusButton setImage:[UIImage imageNamed:@"icon_minus"] forState:UIControlStateNormal];
    [minusButton addTarget:self action:@selector(minusButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:minusButton];
    
    NSString *status = [self.productSelected objectForKey:@"status"];
    NSNumber *quantity = [self.productSelected objectForKey:@"quantity"];
    if ([status isEqualToString:@"sold out"] || quantity.integerValue == 0) {
        UIView *soldOutView = [[UIView alloc] initWithFrame:CGRectMake(0, line3View.frame.origin.y + 14, self.visibleSize.width, 60)];
        [soldOutView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:soldOutView];
        
        UILabel *soldOutLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 16, self.visibleSize.width, 20)];
        [soldOutLabel setText:@"SOLD OUT"];
        [soldOutLabel setTextColor:[UIColor redColor]];
        [soldOutLabel setFont:[UIFont phBold:20]];
        [soldOutLabel setTextAlignment:NSTextAlignmentCenter];
        [soldOutView addSubview:soldOutLabel];
        
        self.isSoldOut = YES;
    }
    
    
    // BUTTON
    
    self.continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.continueButton addTarget:self action:@selector(continueButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.continueButton setFrame:CGRectMake(0, self.visibleSize.height - 44, self.visibleSize.width, 44)];
    [self.continueButton setBackgroundColor:[UIColor colorFromHexCode:@"B6ECFF"]];
    [self.continueButton.titleLabel setFont:[UIFont phBold:15]];
    [self.continueButton setTitle:@"CONTINUE" forState:UIControlStateNormal];
    [self.continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.continueButton setEnabled:NO];
    [self.view addSubview:self.continueButton];
    
    // MixPanel
    SharedData *sharedData = [SharedData sharedInstance];
    [sharedData.mixPanelCTicketDict setObject:[self.productSelected objectForKey:@"name"] forKey:@"Ticket Name"];
    [sharedData.mixPanelCTicketDict setObject:[self.productSelected objectForKey:@"ticket_type"] forKey:@"Ticket Type"];
    [sharedData.mixPanelCTicketDict setObject:[self.productSelected objectForKey:@"price"] forKey:@"Ticket Price"];
    if (self.isTicketProduct) {
       [sharedData.mixPanelCTicketDict setObject:[self.productSelected objectForKey:@"max_purchase"] forKey:@"Ticket Max Per Guest"];
    } else {
        [sharedData.mixPanelCTicketDict setObject:[self.productSelected objectForKey:@"max_guests"] forKey:@"Ticket Max Per Guest"];
    }
    
    [[AnalyticManager sharedManager] trackMixPanelWithDict:@"Product Detail" withDict:sharedData.mixPanelCTicketDict];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self populateUserData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (void)continueButtonDidTap:(id)sender {
    
    SharedData *sharedData = [SharedData sharedInstance];
    AFHTTPRequestOperationManager *manager = [sharedData getOperationManager];
    NSString *url = [NSString stringWithFormat:@"%@/product/summary",PHBaseNewURL];
    
    NSDictionary *userInfo = [UserManager loadUserTicketInfo];
    
    NSMutableArray *summaryList = [NSMutableArray array];
    NSDictionary *summary = @{@"ticket_id":[self.productSelected objectForKey:@"ticket_id"],
                              @"num_buy":self.totalTicket.text};
    [summaryList addObject:summary];
    
    NSDictionary *params = @{@"fb_id":sharedData.fb_id,
                             @"event_id":[self.productList objectForKey:@"event_id"],
                             @"product_list":summaryList,
                             @"guest_detail":@{@"name":[userInfo objectForKey:@"name"],
                                               @"email":[userInfo objectForKey:@"email"],
                                               @"phone":[NSString stringWithFormat:@"%@%@", [userInfo objectForKey:@"idd_code"], [userInfo objectForKey:@"phone"]]}};
    
    [SVProgressHUD show];
    [self.continueButton setEnabled:NO];
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        [self.continueButton setEnabled:YES];
        
        NSInteger responseStatusCode = operation.response.statusCode;
        if (responseStatusCode != 200) {
            return;
        }
        
        if (![[responseObject objectForKey:@"response"] boolValue]) {
            NSString *message = [responseObject objectForKey:@"msg"];
            if (!message || message == nil) {
                message = @"";
            }
            
            self.errorType = [responseObject objectForKey:@"type"];
            
            if (([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending)) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Booking Failed"
                                                                message:message
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            else {
                UIAlertController *alertController = [UIAlertController
                                                      alertControllerWithTitle:@"Booking Failed"
                                                      message:message
                                                      preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction
                                               actionWithTitle:@"OK"
                                               style:UIAlertActionStyleCancel
                                               handler:^(UIAlertAction *action)
                                               {
                                                   if ([self.errorType isEqualToString:@"ticket_list"]) {
                                                       [[self navigationController] popToRootViewControllerAnimated:YES];
                                                       
                                                   }
                                               }];
                
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            
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
                        NSDictionary *product_summary = [data objectForKey:@"product_summary"];
                        if (product_summary && product_summary != nil) {
                            NSArray *product_list = [product_summary objectForKey:@"product_list"];
                            if (product_list && product_list != nil && product_list.count > 0) {
                                TicketConfirmationViewController *ticketConfirmationViewController = [[TicketConfirmationViewController alloc] init];
                                ticketConfirmationViewController.productSummary = product_summary;
                                ticketConfirmationViewController.productList = [product_list objectAtIndex:0];
                                ticketConfirmationViewController.eventTitleString = self.summaryHeaderTitle.text;
                                ticketConfirmationViewController.eventDescriptionString = self.summaryHeaderDescription.text;
                                [self.navigationController pushViewController:ticketConfirmationViewController animated:YES];
                            }
                        }
                    }
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
            }
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [self.continueButton setEnabled:YES];
    }];
    
}

- (void)helpButtonDidTap:(id)sender {
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        NSArray *myReceivers = [[NSArray alloc] initWithObjects:@"+6281218288317", nil];
        [picker setRecipients:myReceivers];
        picker.delegate = self;
        picker.messageComposeDelegate = self;
        picker.navigationBar.barStyle = UIBarStyleDefault;
        [self presentViewController:picker animated:YES completion:^{}];
    }
}

- (void)plusButtonDidTap:(id)sender {
    NSInteger currentAmount = self.totalTicket.text.integerValue;
    
    if (currentAmount < self.maxAmount) {
        currentAmount++;
        self.totalTicket.text = [NSString stringWithFormat:@"%li", (long)currentAmount];
    }
    
    if (self.isTicketProduct) {
        SharedData *sharedData = [SharedData sharedInstance];
        NSString *totalPrice = [NSString stringWithFormat:@"%li", currentAmount * self.price];
        NSString *formattedPrice = [sharedData formatCurrencyString:totalPrice];
        
        self.totalPrice.text = [NSString stringWithFormat:@"Rp%@", formattedPrice];
    }
}

- (void)minusButtonDidTap:(id)sender {
    NSInteger currentAmount = self.totalTicket.text.integerValue;
    
    if (currentAmount > 1) {
        currentAmount--;
        self.totalTicket.text = [NSString stringWithFormat:@"%li", (long)currentAmount];
    }
    
    if (self.isTicketProduct) {
        SharedData *sharedData = [SharedData sharedInstance];
        NSString *totalPrice = [NSString stringWithFormat:@"%li", currentAmount * self.price];
        NSString *formattedPrice = [sharedData formatCurrencyString:totalPrice];
        
        self.totalPrice.text = [NSString stringWithFormat:@"Rp%@", formattedPrice];
    }
}

- (void)userDetailButtonDidTap:(id)sender {
    [self.userDetailButton setBackgroundColor:[UIColor lightGrayColor]];
    [UIView animateWithDuration:0.15 animations:^()
     {
         [self.userDetailButton setBackgroundColor:[UIColor clearColor]];
     } completion:^(BOOL finished){
         GuestDetailViewController *guestDetailViewController = [[GuestDetailViewController alloc] init];
         [self presentViewController:guestDetailViewController animated:YES completion:nil];
     }];
}


#pragma mark - Data 
- (void)setupUserInfo {
    [UserManager clearUserTicketInfo];
    
    SharedData *sharedData = [SharedData sharedInstance];
    
    NSString *firstName = @"";
    if ([sharedData.userDict objectForKey:@"first_name"] && [sharedData.userDict objectForKey:@"first_name"] != nil) {
        firstName = [sharedData.userDict objectForKey:@"first_name"];
    }
    
    NSString *lastName = @"";
    if ([sharedData.userDict objectForKey:@"last_name"] && [sharedData.userDict objectForKey:@"last_name"] != nil) {
        lastName = [sharedData.userDict objectForKey:@"last_name"];
    }
 
    NSString *name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    
    NSString *email = @"";
    if ([sharedData.userDict objectForKey:@"email"] && [sharedData.userDict objectForKey:@"email"] != nil) {
        email = [sharedData.userDict objectForKey:@"email"];
    }
    
    NSString *phone = @"";
    NSString *idd_code = @"";
    if ([sharedData.phone length] > 0) {
        idd_code = [NSString stringWithFormat:@"+%@", [sharedData.phone substringWithRange:NSMakeRange(0, 2)]];
        phone = [sharedData.phone substringFromIndex:2];
    }
    
    NSDictionary *userInfo = @{@"name":name,
                               @"email":email,
                               @"idd_code":idd_code,
                               @"phone":phone};
    [UserManager saveUserTicketInfo:userInfo];
}

- (void)populateUserData {
    
    self.isAllowToContinue = YES;
    NSDictionary *userInfo = [UserManager loadUserTicketInfo];
    
    self.userName.text = [userInfo objectForKey:@"name"];
    
    if (![[userInfo objectForKey:@"email"] isEqualToString:@""]) {
        self.userEmail.text = [userInfo objectForKey:@"email"];
        self.userEmail.textColor = [UIColor blackColor];
    } else {
        self.userEmail.text = @"email";
        self.userEmail.textColor = [UIColor redColor];
        self.isAllowToContinue = NO;
    }
    
    if (![[userInfo objectForKey:@"phone"] isEqualToString:@""]) {
        self.userPhone.text = [NSString stringWithFormat:@"%@%@", [userInfo objectForKey:@"idd_code"], [userInfo objectForKey:@"phone"]];
        self.userPhone.textColor = [UIColor blackColor];
    } else {
        self.userPhone.text = @"phone number";
        self.userPhone.textColor = [UIColor redColor];
        self.isAllowToContinue = NO;
    }
    
    if (self.isAllowToContinue && !self.isSoldOut) {
        [self.continueButton setEnabled:YES];
        [self.continueButton setBackgroundColor:[UIColor phBlueColor]];
    } else {
        [self.continueButton setEnabled:NO];
        [self.continueButton setBackgroundColor:[UIColor colorFromHexCode:@"B6ECFF"]];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([self.errorType isEqualToString:@"ticket_list"]) {
        [[self navigationController] popToRootViewControllerAnimated:YES];
        
    } 
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    switch (result) {
        case MessageComposeResultCancelled:
            break;
        case MessageComposeResultFailed:
            break;
        case MessageComposeResultSent:
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
