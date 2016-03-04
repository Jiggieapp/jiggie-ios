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
    
    UILabel *ticketTitle = [[UILabel alloc] initWithFrame:CGRectMake(14, 80 + 8, ticketTitleWidth, 20)];
    [ticketTitle setFont:[UIFont phBlond:14]];
    [ticketTitle setTextColor:[UIColor darkGrayColor]];
    [ticketTitle setBackgroundColor:[UIColor clearColor]];
    [self.scrollView addSubview:ticketTitle];
    
    UILabel *ticketSubtitle = [[UILabel alloc] initWithFrame:CGRectMake(14, 80 + 30, ticketTitleWidth, 20)];
    [ticketSubtitle setFont:[UIFont phBlond:13]];
    [ticketSubtitle setTextColor:[UIColor darkGrayColor]];
    [ticketSubtitle setBackgroundColor:[UIColor clearColor]];
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
    
    NSString *description = [self.productSelected objectForKey:@"description"];
    if (description && description != nil) {
        [ticketSubtitle setText:description];
    }
    
    NSString *total_price = [self.productSelected objectForKey:@"total_price"];
    if (total_price && total_price != nil) {
        [ticketPrice setText:[NSString stringWithFormat:@"Rp%@", total_price]];
    }
    
    if (self.isTicketProduct) {
        NSString *max_purchase = [self.productSelected objectForKey:@"max_purchase"];
        if (max_purchase && max_purchase != nil) {
            [ticketPerson setText:[NSString stringWithFormat:@"Max Purchased %@", max_purchase]];
        }
    } else {
        NSString *max_guests = [self.productSelected objectForKey:@"max_guests"];
        if (max_guests && max_guests != nil) {
            CGFloat pricePerPerson = (CGFloat)total_price.floatValue / (CGFloat)max_guests.floatValue;
            [ticketPerson setText:[NSString stringWithFormat:@"%.2f / person", pricePerPerson]];
        }
    }

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
    
    ticketDescription.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
    [ticketDescription sizeToFit];
    
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
        [self.totalPrice setText:[NSString stringWithFormat:@"Rp%@", price]];
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
    
    self.userName.text = @"Han Kao";
    self.userEmail.text = @"han-kao@gmail.com";
    self.userPhone.text = @"phone number";
    
    // BUTTON
    
    UIButton *continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [continueButton addTarget:self action:@selector(continueButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [continueButton setFrame:CGRectMake(0, self.visibleSize.height - 44, self.visibleSize.width, 44)];
    [continueButton setBackgroundColor:[UIColor phBlueColor]];
    [continueButton.titleLabel setFont:[UIFont phBold:15]];
    [continueButton setTitle:@"CONTINUE" forState:UIControlStateNormal];
    [continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:continueButton];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (void)continueButtonDidTap:(id)sender {

}

- (void)helpButtonDidTap:(id)sender {

}

- (void)plusButtonDidTap:(id)sender {
    NSInteger currentAmount = self.totalTicket.text.integerValue;
    
    if (currentAmount < self.maxAmount) {
        currentAmount++;
        self.totalTicket.text = [NSString stringWithFormat:@"%li", (long)currentAmount];
    }
    
    if (self.isTicketProduct) {
        self.totalPrice.text = [NSString stringWithFormat:@"Rp%li", currentAmount * self.price];
    }
}

- (void)minusButtonDidTap:(id)sender {
    NSInteger currentAmount = self.totalTicket.text.integerValue;
    
    if (currentAmount > 1) {
        currentAmount--;
        self.totalTicket.text = [NSString stringWithFormat:@"%li", (long)currentAmount];
    }
    
    if (self.isTicketProduct) {
        self.totalPrice.text = [NSString stringWithFormat:@"Rp%li", currentAmount * self.price];
    }
}

#pragma mark - Data 

- (void)populateUserData {
    
}

@end
