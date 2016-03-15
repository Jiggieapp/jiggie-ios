//
//  TicketSuccessViewController.m
//  Jiggie
//
//  Created by Setiady Wiguna on 3/14/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "TicketSuccessViewController.h"

@interface TicketSuccessViewController ()

@end

@implementation TicketSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    if (self.showCloseButton) {
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setFrame:CGRectMake(self.visibleSize.width - 80, 28, 60, 26)];
        [closeButton setTitle:@"CLOSE" forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
        [[closeButton titleLabel] setFont:[UIFont phBlond:12]];
        [closeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [closeButton setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:closeButton];
    }
    
    // SCROLL VIEW
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, self.visibleSize.width, self.visibleSize.height - 44 - 60)];
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
    
    UILabel *congratsLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 10 + 100 + 16, self.visibleSize.width - 28, 20)];
    [congratsLabel setText:@"Congratulations Disky!"];
    [congratsLabel setFont:[UIFont phBlond:16]];
    [congratsLabel setTextColor:[UIColor blackColor]];
    [congratsLabel setBackgroundColor:[UIColor clearColor]];
    [congratsLabel setTextAlignment:NSTextAlignmentCenter];
    [congratsLabel setAdjustsFontSizeToFitWidth:YES];
    [self.scrollView addSubview:congratsLabel];
    
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
    
    self.orderNumber = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 140, CGRectGetMaxY(line1View.frame) + 16, 120, 20)];
    [self.orderNumber setFont:[UIFont phBlond:11]];
    [self.orderNumber setTextColor:[UIColor phPurpleColor]];
    [self.orderNumber setBackgroundColor:[UIColor clearColor]];
    [self.orderNumber setTextAlignment:NSTextAlignmentRight];
    [self.orderNumber setText:@"BUSY PUTRI"];
    [self.scrollView addSubview:self.orderNumber];
    
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
    
    self.ticketName = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(line2View.frame) + 50, 120, 20)];
    [self.ticketName setText:@"REGULAR TICKET (3X)"];
    [self.ticketName setFont:[UIFont phBlond:11]];
    [self.ticketName setTextColor:[UIColor blackColor]];
    [self.ticketName setBackgroundColor:[UIColor clearColor]];
    [self.scrollView addSubview:self.ticketName];
    
    self.ticketPrice = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 160, CGRectGetMaxY(line2View.frame) + 50, 140, 20)];
    [self.ticketPrice setFont:[UIFont phBlond:13]];
    [self.ticketPrice setTextColor:[UIColor phPurpleColor]];
    [self.ticketPrice setBackgroundColor:[UIColor clearColor]];
    [self.ticketPrice setTextAlignment:NSTextAlignmentRight];
    [self.ticketPrice setText:@"RP3.000.000"];
    [self.scrollView addSubview:self.ticketPrice];
    
    UILabel *adminLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(line2View.frame) + 50 + 30, 120, 20)];
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
    [self.adminPrice setText:@"RP500.000"];
    [self.scrollView addSubview:self.adminPrice];
    
    UILabel *taxLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(line2View.frame) + 50 + 30 + 30, 120, 20)];
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
    [self.taxPrice setText:@"RP150.000"];
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
    [self.instruction setFont:[UIFont phBlond:11]];
    [self.instruction setTextColor:[UIColor blackColor]];
    [self.instruction setBackgroundColor:[UIColor clearColor]];
    [self.instruction setNumberOfLines:0];
    [self.scrollView addSubview:self.instruction];
    
    self.instruction.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
    [self.instruction sizeToFit];
    
    
    UIView *line4View = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.instruction.frame) + 20, self.visibleSize.width, 1)];
    [line4View setBackgroundColor:[UIColor phLightGrayColor]];
    [self.scrollView addSubview:line4View];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (void)closeButtonDidTap:(id)sender {
    if (self.showViewButton) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [[self navigationController] popViewControllerAnimated:YES];
    }
}

- (void)viewOrderButtonDidTap:(id)sender {
    
}

@end
