//
//  TicketSuccessViewController.m
//  Jiggie
//
//  Created by Setiady Wiguna on 3/14/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "TicketSuccessViewController.h"
#import "PurchaseHistoryViewController.h"

@interface TicketSuccessViewController ()

@end

@implementation TicketSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];

    [self.navigationController setNavigationBarHidden:YES];   //it hides
    
    CGFloat closeButtonSize = 30;
    if (self.showCloseButton) {
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setFrame:CGRectMake(self.visibleSize.width - 70, 20, 60, 26)];
        [closeButton setTitle:@"CLOSE" forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
        [[closeButton titleLabel] setFont:[UIFont phBlond:12]];
        [closeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [closeButton setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:closeButton];
        
        closeButtonSize = 0;
    }
    
    // SCROLL VIEW
    
    CGFloat orderButtonSize = 0;
    if (self.showViewButton) {
        orderButtonSize = 44;
    }
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50 - closeButtonSize, self.visibleSize.width, self.view.bounds.size.height - orderButtonSize - 50 + closeButtonSize - 42)];
    self.scrollView.showsVerticalScrollIndicator    = NO;
    self.scrollView.showsHorizontalScrollIndicator  = NO;
    self.scrollView.scrollEnabled                   = YES;
    self.scrollView.userInteractionEnabled          = YES;
    self.scrollView.backgroundColor                 = [UIColor whiteColor];
    self.scrollView.contentSize                     = CGSizeMake(self.visibleSize.width, 500);
    [self.view addSubview:self.scrollView];
    
    UIImageView *ovalIcon = [[UIImageView alloc] initWithFrame:CGRectMake((self.visibleSize.width - 80)/2, 10, 100, 100)];
    [ovalIcon setImage:[UIImage imageNamed:@"icon_oval_checked"]];
    [self.scrollView addSubview:ovalIcon];
    
    self.congratsLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 10 + 100 + 16, self.visibleSize.width - 28, 20)];
    [self.congratsLabel setText:@"Congratulations Disky!"];
    [self.congratsLabel setFont:[UIFont phBlond:16]];
    [self.congratsLabel setTextColor:[UIColor blackColor]];
    [self.congratsLabel setBackgroundColor:[UIColor clearColor]];
    [self.congratsLabel setTextAlignment:NSTextAlignmentCenter];
    [self.congratsLabel setAdjustsFontSizeToFitWidth:YES];
    [self.scrollView addSubview:self.congratsLabel];
    
    UILabel *successLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 10 + 100 + 16 + 24, self.visibleSize.width - 28, 20)];
    [successLabel setText:@"You have successfully placed a reservation for"];
    [successLabel setFont:[UIFont phBlond:13]];
    [successLabel setTextColor:[UIColor blackColor]];
    [successLabel setBackgroundColor:[UIColor clearColor]];
    [successLabel setTextAlignment:NSTextAlignmentCenter];
    [self.scrollView addSubview:successLabel];
    
    UIImageView *rectangleView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10 + 100 + 16 + 24 + 36, self.visibleSize.width - 20, 60)];
    [rectangleView setImage:[UIImage imageNamed:@"icon_rectangle"]];
    [self.scrollView addSubview:rectangleView];
    
    self.eventName = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, rectangleView.bounds.size.width - 20, 20)];
    [self.eventName setText:@"AFRO JACK LIVE IN JAKARTA 2016"];
    [self.eventName setFont:[UIFont phBlond:14]];
    [self.eventName setTextColor:[UIColor phPurpleColor]];
    [self.eventName setBackgroundColor:[UIColor clearColor]];
    [self.eventName setTextAlignment:NSTextAlignmentCenter];
    [self.eventName setAdjustsFontSizeToFitWidth:YES];
    [rectangleView addSubview:self.eventName];
    
    self.eventDate = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, rectangleView.bounds.size.width - 20, 20)];
    [self.eventDate setText:@"Sun, 29 Feb 2016"];
    [self.eventDate setFont:[UIFont phBlond:12]];
    [self.eventDate setTextColor:[UIColor darkGrayColor]];
    [self.eventDate setBackgroundColor:[UIColor clearColor]];
    [self.eventDate setTextAlignment:NSTextAlignmentCenter];
    [rectangleView addSubview:self.eventDate];
    
    UILabel *orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(rectangleView.frame) + 20, 120, 20)];
    [orderLabel setText:@"ORDER NUMBER"];
    [orderLabel setFont:[UIFont phBlond:15]];
    [orderLabel setTextColor:[UIColor blackColor]];
    [orderLabel setBackgroundColor:[UIColor clearColor]];
    [self.scrollView addSubview:orderLabel];
    
    self.orderNumber = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 140, CGRectGetMaxY(rectangleView.frame) + 20, 120, 20)];
    [self.orderNumber setFont:[UIFont phBlond:15]];
    [self.orderNumber setTextColor:[UIColor phPurpleColor]];
    [self.orderNumber setBackgroundColor:[UIColor clearColor]];
    [self.orderNumber setTextAlignment:NSTextAlignmentRight];
    [self.orderNumber setText:@"6GBFF991"];
    [self.scrollView addSubview:self.orderNumber];
    
    // LINE 1
    
    UIView *line1View = [[UIView alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(rectangleView.frame) + 16 + 36, self.visibleSize.width - 28, 1)];
    [line1View setBackgroundColor:[UIColor phLightGrayColor]];
    [self.scrollView addSubview:line1View];
    
    UILabel *guestNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(line1View.frame) + 16, 120, 20)];
    [guestNameLabel setText:@"GUEST NAME"];
    [guestNameLabel setFont:[UIFont phBlond:11]];
    [guestNameLabel setTextColor:[UIColor blackColor]];
    [guestNameLabel setBackgroundColor:[UIColor clearColor]];
    [self.scrollView addSubview:guestNameLabel];
    
    self.guestName = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 140, CGRectGetMaxY(line1View.frame) + 16, 120, 20)];
    [self.guestName setFont:[UIFont phBlond:11]];
    [self.guestName setTextColor:[UIColor phPurpleColor]];
    [self.guestName setBackgroundColor:[UIColor clearColor]];
    [self.guestName setTextAlignment:NSTextAlignmentRight];
    [self.scrollView addSubview:self.guestName];
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(line1View.frame) + 16 + 30, 120, 20)];
    [statusLabel setText:@"STATUS"];
    [statusLabel setFont:[UIFont phBlond:11]];
    [statusLabel setTextColor:[UIColor blackColor]];
    [statusLabel setBackgroundColor:[UIColor clearColor]];
    [self.scrollView addSubview:statusLabel];
    
    self.status = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 140, CGRectGetMaxY(line1View.frame) + 16 + 30, 120, 20)];
    [self.status setFont:[UIFont phBlond:11]];
    [self.status setTextColor:[UIColor phPurpleColor]];
    [self.status setBackgroundColor:[UIColor clearColor]];
    [self.status setTextAlignment:NSTextAlignmentRight];
    [self.status setText:@"PAID"];
    [self.scrollView addSubview:self.status];
    
    UILabel *paymentLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(line1View.frame) + 16 + 30 + 30, 120, 20)];
    [paymentLabel setText:@"PAYMENT METHOD"];
    [paymentLabel setFont:[UIFont phBlond:11]];
    [paymentLabel setTextColor:[UIColor blackColor]];
    [paymentLabel setBackgroundColor:[UIColor clearColor]];
    [self.scrollView addSubview:paymentLabel];
    
    self.paymentMethod = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 180, CGRectGetMaxY(line1View.frame) + 16 + 30 + 30, 160, 20)];
    [self.paymentMethod setFont:[UIFont phBlond:11]];
    [self.paymentMethod setTextColor:[UIColor phPurpleColor]];
    [self.paymentMethod setBackgroundColor:[UIColor clearColor]];
    [self.paymentMethod setTextAlignment:NSTextAlignmentRight];
    [self.paymentMethod setText:@"MANDIRI VIRTUAL ACCOUNT"];
    [self.scrollView addSubview:self.paymentMethod];
    
    // LINE 2
    
    UILabel *orderSummaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(line1View.frame) + 16 + 30 + 30 + 50, 200, 20)];
    [orderSummaryLabel setText:@"ORDER SUMMARY"];
    [orderSummaryLabel setFont:[UIFont phBlond:14]];
    [orderSummaryLabel setTextColor:[UIColor blackColor]];
    [orderSummaryLabel setBackgroundColor:[UIColor clearColor]];
    [self.scrollView addSubview:orderSummaryLabel];

    UIView *line2View = [[UIView alloc] initWithFrame:CGRectMake(self.visibleSize.width - 120, CGRectGetMaxY(line1View.frame) + 16 + 30 + 30 + 60, 100, 1)];
    [line2View setBackgroundColor:[UIColor phLightGrayColor]];
    [self.scrollView addSubview:line2View];
    
    self.orderDate = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(line2View.frame) + 10, 200, 20)];
    [self.orderDate setText:@"15 January 2016 - 16:12:49"];
    [self.orderDate setFont:[UIFont phBlond:11]];
    [self.orderDate setTextColor:[UIColor blackColor]];
    [self.orderDate setBackgroundColor:[UIColor clearColor]];
    [self.scrollView addSubview:self.orderDate];
    
    self.ticketName = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(line2View.frame) + 50, 160, 20)];
    [self.ticketName setText:@"REGULAR TICKET (3X)"];
    [self.ticketName setFont:[UIFont phBlond:11]];
    [self.ticketName setTextColor:[UIColor blackColor]];
    [self.ticketName setBackgroundColor:[UIColor clearColor]];
    [self.scrollView addSubview:self.ticketName];
    
    self.ticketPrice = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 160, CGRectGetMaxY(line2View.frame) + 50, 140, 20)];
    [self.ticketPrice setFont:[UIFont phBlond:11]];
    [self.ticketPrice setTextColor:[UIColor phPurpleColor]];
    [self.ticketPrice setBackgroundColor:[UIColor clearColor]];
    [self.ticketPrice setTextAlignment:NSTextAlignmentRight];
    [self.scrollView addSubview:self.ticketPrice];
    
    UILabel *adminLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(line2View.frame) + 50 + 30, 160, 20)];
    [adminLabel setText:@"ADMINISTRATIVE FEE"];
    [adminLabel setFont:[UIFont phBlond:11]];
    [adminLabel setTextColor:[UIColor blackColor]];
    [adminLabel setBackgroundColor:[UIColor clearColor]];
    [self.scrollView addSubview:adminLabel];
    
    self.adminPrice = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 160, CGRectGetMaxY(line2View.frame) + 50 + 30, 140, 20)];
    [self.adminPrice setFont:[UIFont phBlond:11]];
    [self.adminPrice setTextColor:[UIColor phPurpleColor]];
    [self.adminPrice setBackgroundColor:[UIColor clearColor]];
    [self.adminPrice setTextAlignment:NSTextAlignmentRight];
    [self.scrollView addSubview:self.adminPrice];
    
    UILabel *taxLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(line2View.frame) + 50 + 30 + 30, 160, 20)];
    [taxLabel setText:@"TAX"];
    [taxLabel setFont:[UIFont phBlond:11]];
    [taxLabel setTextColor:[UIColor blackColor]];
    [taxLabel setBackgroundColor:[UIColor clearColor]];
    [self.scrollView addSubview:taxLabel];
    
    self.taxPrice = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 160, CGRectGetMaxY(line2View.frame) + 50 + 30 + 30, 140, 20)];
    [self.taxPrice setFont:[UIFont phBlond:11]];
    [self.taxPrice setTextColor:[UIColor phPurpleColor]];
    [self.taxPrice setBackgroundColor:[UIColor clearColor]];
    [self.taxPrice setTextAlignment:NSTextAlignmentRight];
    [self.scrollView addSubview:self.taxPrice];
    
    UIImageView *lineDotView = [[UIImageView alloc] initWithFrame:CGRectMake(self.visibleSize.width - 120, CGRectGetMaxY(line2View.frame) + 50 + 30 + 30 + 30, 100, 1)];
    [lineDotView setImage:[UIImage imageNamed:@"line_dot"]];
    [self.scrollView addSubview:lineDotView];
    
    UILabel *totalPrice = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(line2View.frame) + 50 + 30 + 30 + 30 + 10, 120, 20)];
    [totalPrice setText:@"TOTAL"];
    [totalPrice setFont:[UIFont phBlond:15]];
    [totalPrice setTextColor:[UIColor blackColor]];
    [totalPrice setBackgroundColor:[UIColor clearColor]];
    [self.scrollView addSubview:totalPrice];
    
    self.totalPrice = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 160, CGRectGetMaxY(line2View.frame) + 50 + 30 + 30 + 30 + 10, 140, 20)];
    [self.totalPrice setFont:[UIFont phBlond:15]];
    [self.totalPrice setTextColor:[UIColor phPurpleColor]];
    [self.totalPrice setBackgroundColor:[UIColor clearColor]];
    [self.totalPrice setTextAlignment:NSTextAlignmentRight];
    [self.totalPrice setText:@"RP3.650.000"];
    [self.scrollView addSubview:self.totalPrice];
    
    
    // LINE 3
    
    UILabel *instructionLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(line2View.frame) + 46 + 30 + 30 + 30 + 10 + 50, 120, 20)];
    [instructionLabel setText:@"INSTRUCTIONS"];
    [instructionLabel setFont:[UIFont phBlond:15]];
    [instructionLabel setTextColor:[UIColor blackColor]];
    [instructionLabel setBackgroundColor:[UIColor clearColor]];
    [self.scrollView addSubview:instructionLabel];
    
    UIView *line3View = [[UIView alloc] initWithFrame:CGRectMake(self.visibleSize.width - 160, CGRectGetMaxY(line2View.frame) + 46 + 30 + 30 + 30 + 10 + 60, 160, 1)];
    [line3View setBackgroundColor:[UIColor phLightGrayColor]];
    [self.scrollView addSubview:line3View];
    
    self.instruction = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(line3View.frame) + 16, self.visibleSize.width - 28, 20)];
    [self.instruction setFont:[UIFont phBlond:12]];
    [self.instruction setTextColor:[UIColor blackColor]];
    [self.instruction setBackgroundColor:[UIColor clearColor]];
    [self.instruction setNumberOfLines:0];
    [self.scrollView addSubview:self.instruction];
    
    self.instruction.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
    [self.instruction sizeToFit];
    
    
    // LINE 4
    
    UIView *line4View = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.instruction.frame) + 20, self.visibleSize.width, 1)];
    [line4View setBackgroundColor:[UIColor phLightGrayColor]];
    [self.scrollView addSubview:line4View];
    
    UIImageView *timeView = [[UIImageView alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(line4View.frame) + 26, 18, 18)];
    [timeView setImage:[UIImage imageNamed:@"icon_time_purple"]];
    [self.scrollView addSubview:timeView];
    
    self.eventNameBottom = [[UILabel alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(line4View.frame) + 16, self.visibleSize.width - 50 - 14, 20)];
    [self.eventNameBottom setFont:[UIFont phBlond:12]];
    [self.eventNameBottom setTextColor:[UIColor blackColor]];
    [self.eventNameBottom setBackgroundColor:[UIColor clearColor]];
    [self.eventNameBottom setText:@"AFROJACK LIVE IN JAKARTA 2016"];
    [self.scrollView addSubview:self.eventNameBottom];
    
    self.eventTimeBottom = [[UILabel alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(line4View.frame) + 16 + 20, self.visibleSize.width - 50 - 14, 20)];
    [self.eventTimeBottom setFont:[UIFont phBlond:12]];
    [self.eventTimeBottom setTextColor:[UIColor darkGrayColor]];
    [self.eventTimeBottom setBackgroundColor:[UIColor clearColor]];
    [self.eventTimeBottom setText:@"19:00 - 23:00"];
    [self.scrollView addSubview:self.eventTimeBottom];
    
    UIImageView *locationView = [[UIImageView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(line4View.frame) + 80, 12, 18)];
    [locationView setImage:[UIImage imageNamed:@"icon_location_purple"]];
    [self.scrollView addSubview:locationView];
    
    self.eventPlaceBottom = [[UILabel alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(line4View.frame) + 70, self.visibleSize.width - 50 - 14, 20)];
    [self.eventPlaceBottom setFont:[UIFont phBlond:12]];
    [self.eventPlaceBottom setTextColor:[UIColor blackColor]];
    [self.eventPlaceBottom setBackgroundColor:[UIColor clearColor]];
    [self.eventPlaceBottom setText:@"GLORA BUNG KARNO"];
    [self.scrollView addSubview:self.eventPlaceBottom];
    
    self.eventTimeBottom = [[UILabel alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(line4View.frame) + 70 + 20, self.visibleSize.width - 50 - 14, 20)];
    [self.eventTimeBottom setFont:[UIFont phBlond:12]];
    [self.eventTimeBottom setTextColor:[UIColor darkGrayColor]];
    [self.eventTimeBottom setBackgroundColor:[UIColor clearColor]];
    [self.eventTimeBottom setText:@"Sun, 29 Feb 2016"];
    [self.scrollView addSubview:self.eventTimeBottom];
    
    self.scrollView.contentSize = CGSizeMake(self.visibleSize.width, CGRectGetMaxY(line4View.frame) + 120);
    
    // LINE 5
    
    UIView *line5View = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - orderButtonSize - 42, self.visibleSize.width, 1)];
    [line5View setBackgroundColor:[UIColor phLightGrayColor]];
    [self.view addSubview:line5View];
    
    
    UILabel *starLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.bounds.size.height - orderButtonSize - 28, 8, 20)];
    [starLabel setText:@"*"];
    [starLabel setNumberOfLines:2];
    [starLabel setTextColor:[UIColor purpleColor]];
    [starLabel setFont:[UIFont phBlond:15]];
    [starLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:starLabel];
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, self.view.bounds.size.height - orderButtonSize - 32, self.visibleSize.width - 30 - 14, 20)];
    [infoLabel setText:@"Tap \"Orders\" from the \"More\" tab to return to this screen"];
    [infoLabel setNumberOfLines:2];
    [infoLabel setTextColor:[UIColor blackColor]];
    [infoLabel setFont:[UIFont phBlond:11]];
    [infoLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:infoLabel];
    
    if (self.showViewButton) {
        UIButton *viewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [viewButton addTarget:self action:@selector(viewOrderButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
        [viewButton setFrame:CGRectMake(0, self.view.bounds.size.height - 44, self.visibleSize.width, 44)];
        [viewButton setBackgroundColor:[UIColor phBlueColor]];
        [viewButton.titleLabel setFont:[UIFont phBold:15]];
        [viewButton setTitle:@"VIEW ORDERS" forState:UIControlStateNormal];
        [viewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:viewButton];
    }
    
    self.emptyView = [[EmptyView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];    // it shows
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
        
        [self.emptyView setMode:@"hide"];
        
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
                            
                            return;
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
        [self.emptyView setMode:@"empty"];
    }];
}

- (void)populateData {
    @try {
        [self.orderNumber setText:[self.successData objectForKey:@"order_number"]];
        
        NSDictionary *event = [self.successData objectForKey:@"event"];
        
        NSString *title = [event objectForKey:@"title"];
        if (title && title != nil) {
            [self.eventName setText:[title uppercaseString]];
            [self.eventNameBottom setText:[title uppercaseString]];
        }
        
        NSString *venueName = [event objectForKey:@"venue_name"];
        if (venueName && venueName != nil) {
            [self.eventPlaceBottom setText:[venueName uppercaseString]];
        }
        
        NSString *start_datetime = [event objectForKey:@"start_datetime"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:PHDateFormatServer];
        [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        NSDate *startDatetime = [formatter dateFromString:start_datetime];
        
        [formatter setDateFormat:PHDateFormatAppShort];
        [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
        [formatter setTimeZone:[NSTimeZone localTimeZone]];
        NSString *shortDateTime = [formatter stringFromDate:startDatetime];
        
        [self.eventDate setText:shortDateTime];
        [self.eventDateBottom setText:shortDateTime];
        
        NSString *end_datetime = [event objectForKey:@"end_datetime"];
        [formatter setDateFormat:PHDateFormatServer];
        [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        NSDate *endDatetime = [formatter dateFromString:end_datetime];
        
        [formatter setDateFormat:@"HH:mm"];
        [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
        [formatter setTimeZone:[NSTimeZone localTimeZone]];
        NSString *startMicroDateTime = [formatter stringFromDate:startDatetime];
        
        [formatter setDateFormat:@"HH:mm"];
        [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
        [formatter setTimeZone:[NSTimeZone localTimeZone]];
        NSString *endMicroDateTime = [formatter stringFromDate:endDatetime];
        
        [self.eventTimeBottom setText:[NSString stringWithFormat:@"%@ - %@", startMicroDateTime, endMicroDateTime]];
        
        
        NSDictionary *summary = [self.successData objectForKey:@"summary"];
        if (summary && summary != nil) {
            NSDictionary *guest_detail = [summary objectForKey:@"guest_detail"];
            
            NSString *name = [guest_detail objectForKey:@"name"];
            if (name && name != nil) {
                [self.congratsLabel setText:[NSString stringWithFormat:@"Congratulations %@!", name]];
                [self.guestName setText:[name uppercaseString]];
            }
            
            NSString *payment_status = [summary objectForKey:@"payment_status"];
            if (payment_status && payment_status != nil) {
                [self.status setText:[payment_status uppercaseString]];
            }
            
            NSString *type = [self.successData objectForKey:@"type"];
            if (type && type != nil) {
                if ([type isEqualToString:@"cc"]) {
                    [self.paymentMethod setText:@"CREDIT CARD"];
                } else if ([type isEqualToString:@"bp"]) {
                    [self.paymentMethod setText:@"MANDIRI VIRTUAL ACCOUNT"];
                } else if ([type isEqualToString:@"va"]) {
                    [self.paymentMethod setText:@"BANK TRANSFER"];
                }
            }
            
            NSDictionary *productList = [[summary objectForKey:@"product_list"] objectAtIndex:0];
            
            SharedData *sharedData = [SharedData sharedInstance];
        
            NSString *total_price = [productList objectForKey:@"total_price"];
            if (total_price && total_price != nil) {
                NSString *formattedPrice = [sharedData formatCurrencyString:total_price];
                [self.ticketPrice setText:[NSString stringWithFormat:@"Rp%@", formattedPrice]];
            }
            
            NSString *admin_fee = [productList objectForKey:@"admin_fee"];
            if (admin_fee && admin_fee != nil) {
                NSString *formattedPrice = [sharedData formatCurrencyString:admin_fee];
                [self.adminPrice setText:[NSString stringWithFormat:@"Rp%@", formattedPrice]];
            }
            
            NSString *tax_amount = [productList objectForKey:@"tax_amount"];
            if (tax_amount && tax_amount != nil) {
                NSString *formattedPrice = [sharedData formatCurrencyString:tax_amount];
                [self.taxPrice setText:[NSString stringWithFormat:@"Rp%@", formattedPrice]];
            }
            
            NSString *total_price_all = [productList objectForKey:@"total_price_all"];
            if (total_price_all && total_price_all != nil) {
                 NSString *formattedPrice = [sharedData formatCurrencyString:total_price_all];
                [self.totalPrice setText:[NSString stringWithFormat:@"Rp%@", formattedPrice]];
            }
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

@end
