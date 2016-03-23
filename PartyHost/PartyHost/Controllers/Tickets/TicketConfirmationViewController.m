//
//  TicketConfirmationViewController.m
//  Jiggie
//
//  Created by Setiady Wiguna on 3/9/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "TicketConfirmationViewController.h"
#import "PaymentSelectionViewController.h"
#import "TicketSuccessViewController.h"
#import "VirtualAccountViewController.h"
#import "SVProgressHUD.h"
#import "VTConfig.h"
#import "VTDirect.h"

@interface TicketConfirmationViewController ()

@end

@implementation TicketConfirmationViewController

- (id)init {
    if ((self = [super init])) {
        self.agreeButtonArray = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [titleView setBackgroundColor:[UIColor clearColor]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:@"PURCHASE INFO"];
    [titleLabel setFont:[UIFont phBlond:13]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleView addSubview:titleLabel];
    
    UIImageView *titleIcon = [[UIImageView alloc] initWithFrame:CGRectMake(65, 28, 71, 5)];
    [titleIcon setImage:[UIImage imageNamed:@"icon_step_3"]];
    [titleView addSubview:titleIcon];
    
    [self.navigationItem setTitleView:titleView];
    
    // SCROLL VIEW
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.visibleSize.width, self.visibleSize.height - 44 - 60 - 60)];
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
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 160)];
    [headerView setBackgroundColor:[UIColor phPurpleColor]];
    
    UILabel *agreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 6, self.visibleSize.width - 36, 20)];
    [agreeLabel setText:@"I Agree That ..."];
    [agreeLabel setFont:[UIFont phBlond:14]];
    [agreeLabel setTextColor:[UIColor whiteColor]];
    [agreeLabel setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:agreeLabel];
    
    CGFloat listY = 34;
    NSArray *terms = [self.productList objectForKey:@"terms"];
    for (NSDictionary *term in terms) {
        UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [checkButton setImage:[UIImage imageNamed:@"button_checked_on"] forState:UIControlStateSelected];
        [checkButton setImage:[UIImage imageNamed:@"button_checked_off"] forState:UIControlStateNormal];
        [checkButton setFrame:CGRectMake(18, listY + 5, 30, 30)];
        [checkButton addTarget:self action:@selector(checkButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:checkButton];
        
        [self.agreeButtonArray addObject:checkButton];
        
        UILabel *termLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, listY, self.visibleSize.width - 60 - 14, 40)];
        [termLabel setText:[term objectForKey:@"body"]];
        [termLabel setFont:[UIFont phBlond:12]];
        [termLabel setTextColor:[UIColor whiteColor]];
        [termLabel setAdjustsFontSizeToFitWidth:YES];
        [termLabel setBackgroundColor:[UIColor clearColor]];
        [termLabel setNumberOfLines:2];
        [headerView addSubview:termLabel];
        
        listY += 48;
    }
    
    [headerView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, listY)];
    [self.scrollView addSubview:headerView];
    
    UILabel *eventTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, listY + 10, self.view.bounds.size.width, 16)];
    [eventTitle setFont:[UIFont phBlond:15]];
    [eventTitle setTextColor:[UIColor blackColor]];
    [eventTitle setBackgroundColor:[UIColor clearColor]];
    [eventTitle setTextAlignment:NSTextAlignmentCenter];
    [eventTitle setText:self.eventTitleString];
    [self.scrollView addSubview:eventTitle];
    
    UILabel *eventDescription = [[UILabel alloc] initWithFrame:CGRectMake(0, listY + 10 + 20, self.view.bounds.size.width, 16)];
    [eventDescription setFont:[UIFont phBlond:12]];
    [eventDescription setTextColor:[UIColor blackColor]];
    [eventDescription setBackgroundColor:[UIColor clearColor]];
    [eventDescription setTextAlignment:NSTextAlignmentCenter];
    [eventDescription setText:self.eventDescriptionString];
    [self.scrollView addSubview:eventDescription];
    
    UIView *line1View = [[UIView alloc] initWithFrame:CGRectMake(14, listY + 10 + 20 + 24, self.visibleSize.width - 28, 1)];
    [line1View setBackgroundColor:[UIColor phLightGrayColor]];
    [self.scrollView addSubview:line1View];
    
    CGFloat ticketTitleWidth = self.visibleSize.width/2;
    
    UILabel *ticketTitle = [[UILabel alloc] initWithFrame:CGRectMake(18, CGRectGetMaxY(line1View.frame) + 14, ticketTitleWidth, 20)];
    [ticketTitle setFont:[UIFont phBlond:13]];
    [ticketTitle setTextColor:[UIColor darkGrayColor]];
    [ticketTitle setBackgroundColor:[UIColor clearColor]];
    [ticketTitle setText:[NSString stringWithFormat:@"%@ (%@x)",[self.productList objectForKey:@"name"], [self.productList objectForKey:@"num_buy"]]];
    [self.scrollView addSubview:ticketTitle];
    
    UILabel *ticketPrice = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 140, CGRectGetMaxY(line1View.frame) + 14, 120, 20)];
    [ticketPrice setFont:[UIFont phBlond:13]];
    [ticketPrice setTextColor:[UIColor darkGrayColor]];
    [ticketPrice setBackgroundColor:[UIColor clearColor]];
    [ticketPrice setTextAlignment:NSTextAlignmentRight];
    [ticketPrice setText:[self.productList objectForKey:@"total_price"]];
    [self.scrollView addSubview:ticketPrice];
    
    UILabel *adminTitle = [[UILabel alloc] initWithFrame:CGRectMake(18, CGRectGetMaxY(line1View.frame) + 14 + 30, ticketTitleWidth, 20)];
    [adminTitle setFont:[UIFont phBlond:13]];
    [adminTitle setTextColor:[UIColor darkGrayColor]];
    [adminTitle setBackgroundColor:[UIColor clearColor]];
    [adminTitle setText:@"Administrative Fee"];
    [self.scrollView addSubview:adminTitle];
    
    UILabel *adminPrice = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 140, CGRectGetMaxY(line1View.frame) + 14 + 30, 120, 20)];
    [adminPrice setFont:[UIFont phBlond:13]];
    [adminPrice setTextColor:[UIColor darkGrayColor]];
    [adminPrice setBackgroundColor:[UIColor clearColor]];
    [adminPrice setTextAlignment:NSTextAlignmentRight];
    [adminPrice setText:[self.productList objectForKey:@"admin_fee"]];
    [self.scrollView addSubview:adminPrice];
    
    UILabel *taxTitle = [[UILabel alloc] initWithFrame:CGRectMake(18, CGRectGetMaxY(line1View.frame) + 14 + 30 + 30, ticketTitleWidth, 20)];
    [taxTitle setFont:[UIFont phBlond:13]];
    [taxTitle setTextColor:[UIColor darkGrayColor]];
    [taxTitle setBackgroundColor:[UIColor clearColor]];
    [taxTitle setText:@"Tax"];
    [self.scrollView addSubview:taxTitle];
    
    UILabel *taxPrice = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 140, CGRectGetMaxY(line1View.frame) + 14 + 30 + 30, 120, 20)];
    [taxPrice setFont:[UIFont phBlond:13]];
    [taxPrice setTextColor:[UIColor darkGrayColor]];
    [taxPrice setBackgroundColor:[UIColor clearColor]];
    [taxPrice setTextAlignment:NSTextAlignmentRight];
    [taxPrice setText:[self.productList objectForKey:@"tax_amount"]];
    [self.scrollView addSubview:taxPrice];
    
    self.scrollView.contentSize = CGSizeMake(self.visibleSize.width, CGRectGetMaxY(taxPrice.frame) + 16);
                                             
    UIView *line2View = [[UIView alloc] initWithFrame:CGRectMake(0, self.visibleSize.height - 44 - 60 - 60, self.visibleSize.width, 1)];
    [line2View setBackgroundColor:[UIColor phLightGrayColor]];
    [self.view addSubview:line2View];
    
    UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, CGRectGetMaxY(line2View.frame) + 20, 100, 20)];
    [totalLabel setText:@"Total Price"];
    [totalLabel setFont:[UIFont phBlond:13]];
    [totalLabel setTextColor:[UIColor blackColor]];
    [totalLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:totalLabel];
    
    self.totalPrice = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 100 - 20, CGRectGetMaxY(line2View.frame) + 20, 100, 20)];
    [self.totalPrice setText:[self.productSummary objectForKey:@"total_price"]];
    [self.totalPrice setTextAlignment:NSTextAlignmentRight];
    [self.totalPrice setFont:[UIFont phBlond:20]];
    [self.totalPrice setTextColor:[UIColor blackColor]];
    [self.totalPrice setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.totalPrice];
    
    UIView *line3View = [[UIView alloc] initWithFrame:CGRectMake(0, self.visibleSize.height - 44 - 60, self.visibleSize.width, 1)];
    [line3View setBackgroundColor:[UIColor phLightGrayColor]];
    [self.view addSubview:line3View];
    
    self.paymentLogoView = [[UIImageView alloc] initWithFrame:CGRectMake(24, CGRectGetMaxY(line3View.frame) + 10, 40, 40)];
    [self.paymentLogoView setImage:[UIImage imageNamed:@"icon_add"]];
    [self.paymentLogoView setContentMode:UIViewContentModeCenter];
    [self.view addSubview:self.paymentLogoView];
    
    self.paymentTitleView = [[UILabel alloc] initWithFrame:CGRectMake(80, CGRectGetMaxY(line3View.frame) + 15, self.visibleSize.width - 80 - 14, 30)];
    [self.paymentTitleView setText:@"CHOOSE PAYMENT METHOD"];
    [self.paymentTitleView setFont:[UIFont phBlond:12]];
    [self.paymentTitleView setTextColor:[UIColor phPurpleColor]];
    [self.paymentTitleView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.paymentTitleView];
    
    UIImageView *accessory = [[UIImageView alloc] initWithFrame:CGRectMake(self.visibleSize.width - 24, CGRectGetMaxY(line3View.frame) + 23, 8, 13)];
    [accessory setImage:[UIImage imageNamed:@"icon_purple_arrow"]];
    [self.view addSubview:accessory];
    
    self.paymentAddButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.paymentAddButton setFrame:CGRectMake(0, self.visibleSize.height - 44 - 60, self.visibleSize.width, 80)];
    [self.paymentAddButton addTarget:self action:@selector(paymentAddButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.paymentAddButton setBackgroundColor:[UIColor clearColor]];
    [self.paymentAddButton setHighlighted:YES];
    [self.view addSubview:self.paymentAddButton];
    
    self.continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.continueButton addTarget:self action:@selector(continueButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.continueButton setFrame:CGRectMake(0, self.visibleSize.height - 44, self.visibleSize.width, 44)];
    [self.continueButton setBackgroundColor:[UIColor colorFromHexCode:@"B6ECFF"]];
    [self.continueButton.titleLabel setFont:[UIFont phBold:15]];
    [self.continueButton setTitle:@"CONTINUE" forState:UIControlStateNormal];
    [self.continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.continueButton setEnabled:NO];
    [self.view addSubview:self.continueButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary *payment = [prefs objectForKey:@"pdata"];
    if (payment && payment != nil) {
        self.paymentDetail = payment;
        [prefs removeObjectForKey:@"pdata"];
        [prefs synchronize];
    }
    
    [self populatePaymentData];
}

- (BOOL)isAllAgree {
    for (UIButton *checkButton in self.agreeButtonArray) {
        if(![checkButton isSelected]) {
            return NO;
        }
    }
    return YES;
}

- (void)checkValidToContinue {
    if (self.paymentDetail && self.paymentDetail != nil && [self isAllAgree]) {
        
        [self.continueButton setEnabled:YES];
        [self.continueButton setBackgroundColor:[UIColor phBlueColor]];
    } else {
        
        [self.continueButton setEnabled:NO];
        [self.continueButton setBackgroundColor:[UIColor colorFromHexCode:@"B6ECFF"]];
    }
}

- (void)populatePaymentData {
    if (self.paymentDetail && self.paymentDetail != nil) {
        if ([[self.paymentDetail objectForKey:@"type"] isEqualToString:@"CC"]) {
            if ([[self.paymentDetail objectForKey:@"is_new_card"] isEqualToString:@"1"]) {
                
                NSDictionary *content = [self.paymentDetail objectForKey:@"content"];
                NSString *cardNumber = [content objectForKey:@"card_number"];
                NSString *cardSubstring = [cardNumber substringFromIndex:cardNumber.length - 4];
                
                [self.paymentTitleView setText:[NSString stringWithFormat:@"**** **** **** %@", cardSubstring]];
                [self.paymentTitleView setTextColor:[UIColor blackColor]];
                
                NSString *firstDigit = [cardNumber substringToIndex:1];
                if ([firstDigit isEqualToString:@"4"]) {
                    [self.paymentLogoView setImage:[UIImage imageNamed:@"logo_visa"]];
                } else if ([firstDigit isEqualToString:@"5"]) {
                    [self.paymentLogoView setImage:[UIImage imageNamed:@"logo_master"]];
                } else {
                    [self.paymentLogoView setImage:nil];
                }
                
            } else {
                
                NSString *cardNumber = [self.paymentDetail objectForKey:@"masked_card"];
                NSString *cardSubstring = [cardNumber substringFromIndex:cardNumber.length - 4];
                
                [self.paymentTitleView setText:[NSString stringWithFormat:@"**** **** **** %@", cardSubstring]];
                [self.paymentTitleView setTextColor:[UIColor blackColor]];
                
                NSString *firstDigit = [cardNumber substringToIndex:1];
                if ([firstDigit isEqualToString:@"4"]) {
                    [self.paymentLogoView setImage:[UIImage imageNamed:@"logo_visa"]];
                } else if ([firstDigit isEqualToString:@"5"]) {
                    [self.paymentLogoView setImage:[UIImage imageNamed:@"logo_master"]];
                } else {
                    [self.paymentLogoView setImage:nil];
                }
            }
            
        } else if ([[self.paymentDetail objectForKey:@"type"] isEqualToString:@"BP"]) {
            [self.paymentLogoView setImage:[UIImage imageNamed:@"logo_mandiri"]];
            
            [self.paymentTitleView setText:@"Mandiri Virtual Account"];
            [self.paymentTitleView setTextColor:[UIColor blackColor]];
            
        } else if ([[self.paymentDetail objectForKey:@"type"] isEqualToString:@"VA"]) {
            [self.paymentLogoView setImage:nil];
            
            [self.paymentTitleView setText:@"Other Banks"];
            [self.paymentTitleView setTextColor:[UIColor blackColor]];
        }
        
    } else {
        [self.paymentLogoView setImage:[UIImage imageNamed:@"icon_add"]];
        
        [self.paymentTitleView setText:@"CHOOSE PAYMENT METHOD"];
        [self.paymentTitleView setTextColor:[UIColor phPurpleColor]];
    }

    [self checkValidToContinue];
}

#pragma mark - Action
- (void)checkButtonDidTap:(id)sender {
    UIButton *checkButton = (UIButton *)sender;
    
    if ([checkButton isSelected]) {
        [checkButton setSelected:NO];
    } else {
        [checkButton setSelected:YES];
    }
    
    [self checkValidToContinue];
}

- (void)paymentAddButtonDidTap:(id)sender {
    [self.paymentAddButton setBackgroundColor:[UIColor lightGrayColor]];
    [UIView animateWithDuration:0.15 animations:^()
     {
         [self.paymentAddButton setBackgroundColor:[UIColor clearColor]];
     } completion:^(BOOL finished){
         self.paymentDetail = nil;
         
         PaymentSelectionViewController *paymentSelectionViewController = [[PaymentSelectionViewController alloc] init];
         paymentSelectionViewController.productList = self.productList;
         [self.navigationController pushViewController:paymentSelectionViewController animated:YES];
     }];
}

- (void)continueButtonDidTap:(id)sender {
    if ([[self.paymentDetail objectForKey:@"is_new_card"] isEqualToString:@"1"]) {
        NSDictionary *content = [self.paymentDetail objectForKey:@"content"];
        
        VTDirect *vtDirect = [[VTDirect alloc] init];
        
        VTCardDetails *cardDetails = [[VTCardDetails alloc] init];
        cardDetails.card_number = [content objectForKey:@"card_number"];
        cardDetails.card_cvv =[content objectForKey:@"card_cvv"];
        cardDetails.card_exp_month =[content objectForKey:@"card_exp_month"];
        cardDetails.card_exp_year = [[content objectForKey:@"card_exp_year"] integerValue];
        cardDetails.gross_amount = [self.productSummary objectForKey:@"total_price"];
        cardDetails.secure = YES;
        
        vtDirect.card_details = cardDetails;
        
        [SVProgressHUD show];
        [vtDirect getToken:^(VTToken *token, NSException *exception) {
            [SVProgressHUD dismiss];
            
            NSData *newToken = (NSData *)token;
            
            NSError *error;
            NSDictionary *json = (NSDictionary *)[NSJSONSerialization
                                                  JSONObjectWithData:newToken
                                                  options:kNilOptions
                                                  error:&error];
            if(exception == nil){
                if ([[json objectForKey:@"status_code"] isEqualToString:@"200"]) {
                    if (json[@"redirect_url"] != nil) {
                        self.paymentNew = nil;
                        self.paymentNew = @{@"token_id":[json objectForKey:@"token_id"],
                                            @"name_cc":[content objectForKey:@"name_cc"]};
                        
                        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.visibleSize.width, self.visibleSize.height)];
                        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:json[@"redirect_url"]]]];
                        [webView setDelegate:self];
                        [webView setScalesPageToFit:YES];
                        [webView setMultipleTouchEnabled:NO];
                        [webView setContentMode:UIViewContentModeScaleAspectFit];
                        [self.view addSubview:webView];
                    }
                }
                
            } else {
                NSLog(@"Reason: %@",exception.reason);
                
            }
        }];
    } else {
        [self postPayment];
    }
}

- (void)postPayment {
    SharedData *sharedData = [SharedData sharedInstance];
    AFHTTPRequestOperationManager *manager = [sharedData getOperationManager];
    NSString *url = [NSString stringWithFormat:@"%@/product/payment",PHBaseNewURL];

    NSDictionary *params = @{@"type":[self.paymentDetail objectForKey:@"type"],
                             @"is_new_card":[self.paymentDetail objectForKey:@"is_new_card"],
                             @"order_id":[self.productSummary objectForKey:@"order_id"],
                             @"token_id":[self.paymentDetail objectForKey:@"token_id"],
                             @"name_cc":@""};
    
    if ([[self.paymentDetail objectForKey:@"is_new_card"] isEqualToString:@"1"]) {
        params = @{@"type":[self.paymentDetail objectForKey:@"type"],
                   @"is_new_card":[self.paymentDetail objectForKey:@"is_new_card"],
                   @"order_id":[self.productSummary objectForKey:@"order_id"],
                   @"token_id":[self.paymentNew objectForKey:@"token_id"],
                   @"name_cc":[self.paymentNew objectForKey:@"name_cc"]};
    }

    [SVProgressHUD show];
    [self.continueButton setEnabled:NO];
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        [self.continueButton setEnabled:YES];
        
        NSInteger responseStatusCode = operation.response.statusCode;
        if (responseStatusCode != 200) {
            return;
        }
        
        // Remove cache
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs removeObjectForKey:@"temp_da_list"];
        [prefs synchronize];
        
        if ([[self.paymentDetail objectForKey:@"type"] isEqualToString:@"CC"]) {
            TicketSuccessViewController *ticketSuccessViewController = [[TicketSuccessViewController alloc] init];
            [ticketSuccessViewController setShowCloseButton:YES];
            [ticketSuccessViewController setShowViewButton:YES];
            [ticketSuccessViewController setIsModalScreen:YES];
            [ticketSuccessViewController setOrderID:[self.productSummary objectForKey:@"order_id"]];
            [ticketSuccessViewController setTicketType:[self.productList objectForKey:@"ticket_type"]];
            [[self navigationController] pushViewController:ticketSuccessViewController animated:YES];
            
        } else {
            VirtualAccountViewController *virtualAccountViewController = [[VirtualAccountViewController alloc] init];
            [virtualAccountViewController setShowCloseButton:NO];
            [virtualAccountViewController setShowOrderButton:YES];
            [virtualAccountViewController setOrderID:[self.productSummary objectForKey:@"order_id"]];
            [virtualAccountViewController setVAType:[self.paymentDetail objectForKey:@"type"]];
            [[self navigationController] pushViewController:virtualAccountViewController animated:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.continueButton setEnabled:YES];
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if ([webView.request.URL.absoluteString rangeOfString:@"callback"].location != NSNotFound) {
        [self postPayment];
        
        [webView performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
    }
}

@end
