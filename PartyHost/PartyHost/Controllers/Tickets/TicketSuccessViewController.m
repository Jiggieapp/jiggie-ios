//
//  TicketSuccessViewController.m
//  Jiggie
//
//  Created by Setiady Wiguna on 3/14/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "TicketSuccessViewController.h"
#import "PurchaseHistoryViewController.h"
#import "AnalyticManager.h"
#import "NSString+HTML.h"

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
        [closeButton setFrame:CGRectMake(self.visibleSize.width - 50, 20, 40, 40)];
        [closeButton setImage:[UIImage imageNamed:@"nav_close_blue"] forState:UIControlStateNormal];
        [closeButton setImageEdgeInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
        [closeButton addTarget:self action:@selector(closeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:closeButton];
        
        closeButtonSize = 0;
    }
    
    CGFloat orderButtonSize = 0;
    if (self.showViewButton) {
        orderButtonSize = 54;
    }
    
    [self loadPurchaseView];
    [self loadBookingView];
    
    // LINE 5
    
    UIView *line5View = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - orderButtonSize - 42, self.visibleSize.width, 1)];
    [line5View setBackgroundColor:[UIColor phLightGrayColor]];
    [self.view addSubview:line5View];
    
    CGFloat padding = 0;
    if (self.visibleSize.width > 320) {
        padding = 12.0;
    }
    UILabel *starLabel = [[UILabel alloc] initWithFrame:CGRectMake(16 + padding, self.view.bounds.size.height - orderButtonSize - 28, 8, 20)];
    [starLabel setText:@"*"];
    [starLabel setNumberOfLines:2];
    [starLabel setTextColor:[UIColor purpleColor]];
    [starLabel setFont:[UIFont phBlond:15]];
    [starLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:starLabel];
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(26 + padding, self.view.bounds.size.height - orderButtonSize - 32, self.visibleSize.width, 20)];
    [infoLabel setText:@"Tap \"Bookings\" from \"More\" tab to return to this screen"];
    [infoLabel setNumberOfLines:2];
    [infoLabel setTextColor:[UIColor blackColor]];
    [infoLabel setFont:[UIFont phBlond:11]];
    [infoLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:infoLabel];
    
    if (self.showViewButton) {
        UIButton *viewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [viewButton addTarget:self action:@selector(viewOrderButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
        [viewButton setFrame:CGRectMake(0, self.view.bounds.size.height - orderButtonSize, self.visibleSize.width, orderButtonSize)];
        [viewButton setBackgroundColor:[UIColor phBlueColor]];
        [viewButton.titleLabel setFont:[UIFont phBold:15]];
        [viewButton setTitle:@"VIEW BOOKINGS" forState:UIControlStateNormal];
        [viewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:viewButton];
    }
    
    self.emptyView = [[EmptyView alloc] initWithFrame:CGRectMake(0, 60, self.view.bounds.size.width, self.view.bounds.size.height - 60)];
    [self.emptyView setData:@"No data found" subtitle:@"Sorry we're having some server issues, please check back in a few minutes." imageNamed:@""];
    [self.emptyView setMode:@"load"];
    [self.emptyView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.emptyView];
    
    [self loadData];
}

- (void)loadPurchaseView {
    // SCROLL VIEW
    
    CGFloat closeButtonSize = 30;
    if (self.showCloseButton) {
        closeButtonSize = 0;
    }
    
    CGFloat orderButtonSize = 0;
    if (self.showViewButton) {
        orderButtonSize = 54;
    }
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60 - closeButtonSize, self.visibleSize.width, self.view.bounds.size.height - orderButtonSize - 60 + closeButtonSize - 42)];
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
    [self.congratsLabel setText:@"Congratulations!"];
    [self.congratsLabel setFont:[UIFont phBlond:16]];
    [self.congratsLabel setTextColor:[UIColor blackColor]];
    [self.congratsLabel setBackgroundColor:[UIColor clearColor]];
    [self.congratsLabel setTextAlignment:NSTextAlignmentCenter];
    [self.congratsLabel setAdjustsFontSizeToFitWidth:YES];
    [self.scrollView addSubview:self.congratsLabel];
    
    UILabel *successLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 10 + 100 + 16 + 24, self.visibleSize.width - 28, 20)];
    [successLabel setText:@"You have successfully booked a ticket for"];
    [successLabel setFont:[UIFont phBlond:13]];
    [successLabel setTextColor:[UIColor blackColor]];
    [successLabel setBackgroundColor:[UIColor clearColor]];
    [successLabel setTextAlignment:NSTextAlignmentCenter];
    [self.scrollView addSubview:successLabel];
    
    UIImageView *rectangleView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10 + 100 + 16 + 24 + 36, self.visibleSize.width - 20, 60)];
    [rectangleView setImage:[UIImage imageNamed:@"icon_rectangle"]];
    [self.scrollView addSubview:rectangleView];
    
    self.eventName = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, rectangleView.bounds.size.width - 20, 20)];
    [self.eventName setFont:[UIFont phBlond:14]];
    [self.eventName setTextColor:[UIColor phPurpleColor]];
    [self.eventName setBackgroundColor:[UIColor clearColor]];
    [self.eventName setTextAlignment:NSTextAlignmentCenter];
    [self.eventName setAdjustsFontSizeToFitWidth:YES];
    [rectangleView addSubview:self.eventName];
    
    self.eventDate = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, rectangleView.bounds.size.width - 20, 20)];
    [self.eventDate setFont:[UIFont phBlond:12]];
    [self.eventDate setTextColor:[UIColor darkGrayColor]];
    [self.eventDate setBackgroundColor:[UIColor clearColor]];
    [self.eventDate setTextAlignment:NSTextAlignmentCenter];
    [rectangleView addSubview:self.eventDate];
    
    UILabel *orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(rectangleView.frame) + 20, 120, 20)];
    [orderLabel setText:@"BOOKING NUMBER"];
    [orderLabel setFont:[UIFont phBlond:15]];
    [orderLabel setTextColor:[UIColor blackColor]];
    [orderLabel setBackgroundColor:[UIColor clearColor]];
    [self.scrollView addSubview:orderLabel];
    
    self.orderNumber = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 140, CGRectGetMaxY(rectangleView.frame) + 20, 120, 20)];
    [self.orderNumber setFont:[UIFont phBlond:15]];
    [self.orderNumber setTextColor:[UIColor phPurpleColor]];
    [self.orderNumber setBackgroundColor:[UIColor clearColor]];
    [self.orderNumber setTextAlignment:NSTextAlignmentRight];
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
    [self.scrollView addSubview:self.totalPrice];
    
    
    // LINE 3
    
    self.instructionLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(line2View.frame) + 46 + 30 + 30 + 30 + 10 + 50, 120, 20)];
    [self.instructionLabel setText:@"INSTRUCTIONS"];
    [self.instructionLabel setFont:[UIFont phBlond:15]];
    [self.instructionLabel setTextColor:[UIColor blackColor]];
    [self.instructionLabel setBackgroundColor:[UIColor clearColor]];
    [self.scrollView addSubview:self.instructionLabel];
    
    self.instructionLine = [[UIView alloc] initWithFrame:CGRectMake(self.visibleSize.width - 160, CGRectGetMaxY(line2View.frame) + 46 + 30 + 30 + 30 + 10 + 60, 160, 1)];
    [self.instructionLine setBackgroundColor:[UIColor phLightGrayColor]];
    [self.scrollView addSubview:self.instructionLine];
    
    self.instruction = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(self.instructionLine.frame) + 16, self.visibleSize.width - 28, 20)];
    [self.instruction setFont:[UIFont phBlond:12]];
    [self.instruction setTextColor:[UIColor blackColor]];
    [self.instruction setBackgroundColor:[UIColor clearColor]];
    [self.instruction setNumberOfLines:0];
    [self.scrollView addSubview:self.instruction];
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.instruction.frame) + 20, self.visibleSize.width, 110)];
    [self.bottomView setBackgroundColor:[UIColor clearColor]];
    [self.scrollView addSubview:self.bottomView];
    
    // LINE 4
    
    UIView *line4View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.visibleSize.width, 1)];
    [line4View setBackgroundColor:[UIColor phLightGrayColor]];
    [self.bottomView addSubview:line4View];
    
    UIImageView *timeView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 26, 18, 18)];
    [timeView setImage:[UIImage imageNamed:@"icon_time_purple"]];
    [self.bottomView addSubview:timeView];
    
    self.eventNameBottom = [[UILabel alloc] initWithFrame:CGRectMake(50, 16, self.visibleSize.width - 50 - 14, 20)];
    [self.eventNameBottom setFont:[UIFont phBlond:12]];
    [self.eventNameBottom setTextColor:[UIColor blackColor]];
    [self.eventNameBottom setBackgroundColor:[UIColor clearColor]];
    [self.bottomView addSubview:self.eventNameBottom];
    
    self.eventTimeBottom = [[UILabel alloc] initWithFrame:CGRectMake(50, 16 + 20, self.visibleSize.width - 50 - 14, 20)];
    [self.eventTimeBottom setFont:[UIFont phBlond:12]];
    [self.eventTimeBottom setTextColor:[UIColor darkGrayColor]];
    [self.eventTimeBottom setBackgroundColor:[UIColor clearColor]];
    [self.bottomView addSubview:self.eventTimeBottom];
    
    UIImageView *locationView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 80, 12, 18)];
    [locationView setImage:[UIImage imageNamed:@"icon_location_purple"]];
    [self.bottomView addSubview:locationView];
    
    self.eventPlaceBottom = [[UILabel alloc] initWithFrame:CGRectMake(50, 70, self.visibleSize.width - 50 - 14, 20)];
    [self.eventPlaceBottom setFont:[UIFont phBlond:12]];
    [self.eventPlaceBottom setTextColor:[UIColor blackColor]];
    [self.eventPlaceBottom setBackgroundColor:[UIColor clearColor]];
    [self.bottomView addSubview:self.eventPlaceBottom];
    
    self.eventDateBottom = [[UILabel alloc] initWithFrame:CGRectMake(50, 70 + 20, self.visibleSize.width - 50 - 14, 20)];
    [self.eventDateBottom setFont:[UIFont phBlond:12]];
    [self.eventDateBottom setTextColor:[UIColor darkGrayColor]];
    [self.eventDateBottom setBackgroundColor:[UIColor clearColor]];
    [self.bottomView addSubview:self.eventDateBottom];
    
    self.scrollView.contentSize = CGSizeMake(self.visibleSize.width, CGRectGetMaxY(self.bottomView.frame) + 10);
}

- (void)loadBookingView {
    // SCROLL VIEW
    
    CGFloat closeButtonSize = 30;
    if (self.showCloseButton) {
        closeButtonSize = 0;
    }
    
    CGFloat orderButtonSize = 0;
    if (self.showViewButton) {
        orderButtonSize = 54;
    }
    
    self.bookingScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60 - closeButtonSize, self.visibleSize.width, self.view.bounds.size.height - orderButtonSize - 60 + closeButtonSize - 42)];
    self.bookingScrollView.showsVerticalScrollIndicator    = NO;
    self.bookingScrollView.showsHorizontalScrollIndicator  = NO;
    self.bookingScrollView.scrollEnabled                   = YES;
    self.bookingScrollView.userInteractionEnabled          = YES;
    self.bookingScrollView.backgroundColor                 = [UIColor whiteColor];
    self.scrollView.contentSize                     = CGSizeMake(self.visibleSize.width, 500);
    [self.view addSubview:self.bookingScrollView];
    
    UIImageView *ovalIcon = [[UIImageView alloc] initWithFrame:CGRectMake((self.visibleSize.width - 80)/2, 10, 100, 100)];
    [ovalIcon setImage:[UIImage imageNamed:@"icon_oval_checked"]];
    [self.bookingScrollView addSubview:ovalIcon];
    
    self.bookingCongratsLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 10 + 100 + 16, self.visibleSize.width - 28, 20)];
    [self.bookingCongratsLabel setText:@"Congratulations!"];
    [self.bookingCongratsLabel setFont:[UIFont phBlond:16]];
    [self.bookingCongratsLabel setTextColor:[UIColor blackColor]];
    [self.bookingCongratsLabel setBackgroundColor:[UIColor clearColor]];
    [self.bookingCongratsLabel setTextAlignment:NSTextAlignmentCenter];
    [self.bookingCongratsLabel setAdjustsFontSizeToFitWidth:YES];
    [self.bookingScrollView addSubview:self.bookingCongratsLabel];
    
    UILabel *successLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 10 + 100 + 16 + 24, self.visibleSize.width - 28, 20)];
    [successLabel setText:@"You have successfully placed a reservation for"];
    [successLabel setFont:[UIFont phBlond:13]];
    [successLabel setTextColor:[UIColor blackColor]];
    [successLabel setBackgroundColor:[UIColor clearColor]];
    [successLabel setTextAlignment:NSTextAlignmentCenter];
    [self.bookingScrollView addSubview:successLabel];
    
    UIImageView *rectangleView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10 + 100 + 16 + 24 + 36, self.visibleSize.width - 20, 60)];
    [rectangleView setImage:[UIImage imageNamed:@"icon_rectangle"]];
    [self.bookingScrollView addSubview:rectangleView];
    
    self.bookingEventName = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, rectangleView.bounds.size.width - 20, 20)];
    [self.bookingEventName setFont:[UIFont phBlond:14]];
    [self.bookingEventName setTextColor:[UIColor phPurpleColor]];
    [self.bookingEventName setBackgroundColor:[UIColor clearColor]];
    [self.bookingEventName setTextAlignment:NSTextAlignmentCenter];
    [self.bookingEventName setAdjustsFontSizeToFitWidth:YES];
    [rectangleView addSubview:self.bookingEventName];
    
    self.bookingEventDate = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, rectangleView.bounds.size.width - 20, 20)];
    [self.bookingEventDate setFont:[UIFont phBlond:12]];
    [self.bookingEventDate setTextColor:[UIColor darkGrayColor]];
    [self.bookingEventDate setBackgroundColor:[UIColor clearColor]];
    [self.bookingEventDate setTextAlignment:NSTextAlignmentCenter];
    [rectangleView addSubview:self.bookingEventDate];
    
    UILabel *orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(rectangleView.frame) + 20, 120, 20)];
    [orderLabel setText:@"ORDER NUMBER"];
    [orderLabel setFont:[UIFont phBlond:15]];
    [orderLabel setTextColor:[UIColor blackColor]];
    [orderLabel setBackgroundColor:[UIColor clearColor]];
    [self.bookingScrollView addSubview:orderLabel];
    
    self.bookingOrderNumber = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 140, CGRectGetMaxY(rectangleView.frame) + 20, 120, 20)];
    [self.bookingOrderNumber setFont:[UIFont phBlond:15]];
    [self.bookingOrderNumber setTextColor:[UIColor phPurpleColor]];
    [self.bookingOrderNumber setBackgroundColor:[UIColor clearColor]];
    [self.bookingOrderNumber setTextAlignment:NSTextAlignmentRight];
    [self.bookingScrollView addSubview:self.bookingOrderNumber];
    
    // LINE 1
    
    UIView *line1View = [[UIView alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(rectangleView.frame) + 16 + 36, self.visibleSize.width - 28, 1)];
    [line1View setBackgroundColor:[UIColor phLightGrayColor]];
    [self.bookingScrollView addSubview:line1View];
    
    UILabel *guestNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(line1View.frame) + 16, 120, 20)];
    [guestNameLabel setText:@"GUEST NAME"];
    [guestNameLabel setFont:[UIFont phBlond:11]];
    [guestNameLabel setTextColor:[UIColor blackColor]];
    [guestNameLabel setBackgroundColor:[UIColor clearColor]];
    [self.bookingScrollView addSubview:guestNameLabel];
    
    self.bookingGuestName = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 140, CGRectGetMaxY(line1View.frame) + 16, 120, 20)];
    [self.bookingGuestName setFont:[UIFont phBlond:11]];
    [self.bookingGuestName setTextColor:[UIColor phPurpleColor]];
    [self.bookingGuestName setBackgroundColor:[UIColor clearColor]];
    [self.bookingGuestName setTextAlignment:NSTextAlignmentRight];
    [self.bookingScrollView addSubview:self.bookingGuestName];
    
    UILabel *totalGuestLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(line1View.frame) + 16 + 30, 120, 20)];
    [totalGuestLabel setText:@"TOTAL GUEST"];
    [totalGuestLabel setFont:[UIFont phBlond:11]];
    [totalGuestLabel setTextColor:[UIColor blackColor]];
    [totalGuestLabel setBackgroundColor:[UIColor clearColor]];
    [self.bookingScrollView addSubview:totalGuestLabel];
    
    self.bookingTotalGuest = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 140, CGRectGetMaxY(line1View.frame) + 16 + 30, 120, 20)];
    [self.bookingTotalGuest setFont:[UIFont phBlond:11]];
    [self.bookingTotalGuest setTextColor:[UIColor phPurpleColor]];
    [self.bookingTotalGuest setBackgroundColor:[UIColor clearColor]];
    [self.bookingTotalGuest setTextAlignment:NSTextAlignmentRight];
    [self.bookingScrollView addSubview:self.bookingTotalGuest];
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(line1View.frame) + 16 + 30 + 30, 120, 20)];
    [statusLabel setText:@"STATUS"];
    [statusLabel setFont:[UIFont phBlond:11]];
    [statusLabel setTextColor:[UIColor blackColor]];
    [statusLabel setBackgroundColor:[UIColor clearColor]];
    [self.bookingScrollView addSubview:statusLabel];
    
    self.bookingStatus = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 140, CGRectGetMaxY(line1View.frame) + 16 + 30 + 30, 120, 20)];
    [self.bookingStatus setFont:[UIFont phBlond:11]];
    [self.bookingStatus setTextColor:[UIColor phPurpleColor]];
    [self.bookingStatus setBackgroundColor:[UIColor clearColor]];
    [self.bookingStatus setTextAlignment:NSTextAlignmentRight];
    [self.bookingStatus setText:@"PAID"];
    [self.bookingScrollView addSubview:self.bookingStatus];
    
    UILabel *paymentLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(line1View.frame) + 16 + 30 + 30 + 30, 120, 20)];
    [paymentLabel setText:@"PAYMENT METHOD"];
    [paymentLabel setFont:[UIFont phBlond:11]];
    [paymentLabel setTextColor:[UIColor blackColor]];
    [paymentLabel setBackgroundColor:[UIColor clearColor]];
    [self.bookingScrollView addSubview:paymentLabel];
    
    self.bookingPaymentMethod = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 180, CGRectGetMaxY(line1View.frame) + 16 + 30 + 30 + 30, 160, 20)];
    [self.bookingPaymentMethod setFont:[UIFont phBlond:11]];
    [self.bookingPaymentMethod setTextColor:[UIColor phPurpleColor]];
    [self.bookingPaymentMethod setBackgroundColor:[UIColor clearColor]];
    [self.bookingPaymentMethod setTextAlignment:NSTextAlignmentRight];
    [self.bookingScrollView addSubview:self.bookingPaymentMethod];
    
    // LINE 2
    
    UILabel *orderSummaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(line1View.frame) + 16 + 30 + 30 + 30 + 50, 200, 20)];
    [orderSummaryLabel setText:@"BOOKING SUMMARY"];
    [orderSummaryLabel setFont:[UIFont phBlond:14]];
    [orderSummaryLabel setTextColor:[UIColor blackColor]];
    [orderSummaryLabel setBackgroundColor:[UIColor clearColor]];
    [self.bookingScrollView addSubview:orderSummaryLabel];
    
    UIView *line2View = [[UIView alloc] initWithFrame:CGRectMake(self.visibleSize.width - 120, CGRectGetMaxY(line1View.frame) + 16 + 30 + 30 + 30 + 60, 100, 1)];
    [line2View setBackgroundColor:[UIColor phLightGrayColor]];
    [self.bookingScrollView addSubview:line2View];
    
    self.bookingOrderDate = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(line2View.frame) + 10, 200, 20)];
    [self.bookingOrderDate setFont:[UIFont phBlond:11]];
    [self.bookingOrderDate setTextColor:[UIColor blackColor]];
    [self.bookingOrderDate setBackgroundColor:[UIColor clearColor]];
    [self.bookingScrollView addSubview:self.bookingOrderDate];
    
    self.bookingTicketName = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(line2View.frame) + 50, 160, 20)];
    [self.bookingTicketName setText:@"REGULAR TICKET (ESTIMATE)"];
    [self.bookingTicketName setFont:[UIFont phBlond:11]];
    [self.bookingTicketName setTextColor:[UIColor blackColor]];
    [self.bookingTicketName setBackgroundColor:[UIColor clearColor]];
    [self.bookingScrollView addSubview:self.bookingTicketName];
    
    self.bookingTicketPrice = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 160, CGRectGetMaxY(line2View.frame) + 50, 140, 20)];
    [self.bookingTicketPrice setFont:[UIFont phBlond:11]];
    [self.bookingTicketPrice setTextColor:[UIColor phPurpleColor]];
    [self.bookingTicketPrice setBackgroundColor:[UIColor clearColor]];
    [self.bookingTicketPrice setTextAlignment:NSTextAlignmentRight];
    [self.bookingScrollView addSubview:self.bookingTicketPrice];
    
    UILabel *taxLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(line2View.frame) + 50 + 30, 160, 20)];
    [taxLabel setText:@"TAX"];
    [taxLabel setFont:[UIFont phBlond:11]];
    [taxLabel setTextColor:[UIColor blackColor]];
    [taxLabel setBackgroundColor:[UIColor clearColor]];
    [self.bookingScrollView addSubview:taxLabel];
    
    self.bookingTaxPrice = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 160, CGRectGetMaxY(line2View.frame) + 50 + 30, 140, 20)];
    [self.bookingTaxPrice setFont:[UIFont phBlond:11]];
    [self.bookingTaxPrice setTextColor:[UIColor phPurpleColor]];
    [self.bookingTaxPrice setBackgroundColor:[UIColor clearColor]];
    [self.bookingTaxPrice setTextAlignment:NSTextAlignmentRight];
    [self.bookingScrollView addSubview:self.bookingTaxPrice];
    
    UILabel *adminLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(line2View.frame) + 50 + 30 + 30, 160, 20)];
    [adminLabel setText:@"SERVICE CHARGE"];
    [adminLabel setFont:[UIFont phBlond:11]];
    [adminLabel setTextColor:[UIColor blackColor]];
    [adminLabel setBackgroundColor:[UIColor clearColor]];
    [self.bookingScrollView addSubview:adminLabel];
    
    self.bookingServicePrice = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 160, CGRectGetMaxY(line2View.frame) + 50 + 30 + 30, 140, 20)];
    [self.bookingServicePrice setFont:[UIFont phBlond:11]];
    [self.bookingServicePrice setTextColor:[UIColor phPurpleColor]];
    [self.bookingServicePrice setBackgroundColor:[UIColor clearColor]];
    [self.bookingServicePrice setTextAlignment:NSTextAlignmentRight];
    [self.bookingScrollView addSubview:self.bookingServicePrice];
    
    UIImageView *lineDot1View = [[UIImageView alloc] initWithFrame:CGRectMake(self.visibleSize.width - 120, CGRectGetMaxY(line2View.frame) + 50 + 30 + 30 + 30, 100, 1)];
    [lineDot1View setImage:[UIImage imageNamed:@"line_dot"]];
    [self.bookingScrollView addSubview:lineDot1View];
    
    UILabel *totalPrice = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(lineDot1View.frame) + 10, 120, 20)];
    [totalPrice setText:@"ESTIMATED TOTAL"];
    [totalPrice setFont:[UIFont phBlond:11]];
    [totalPrice setTextColor:[UIColor blackColor]];
    [totalPrice setBackgroundColor:[UIColor clearColor]];
    [self.bookingScrollView addSubview:totalPrice];
    
    self.bookingTotalPrice = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 160, CGRectGetMaxY(lineDot1View.frame) + 10, 140, 20)];
    [self.bookingTotalPrice setFont:[UIFont phBlond:11]];
    [self.bookingTotalPrice setTextColor:[UIColor phPurpleColor]];
    [self.bookingTotalPrice setBackgroundColor:[UIColor clearColor]];
    [self.bookingTotalPrice setTextAlignment:NSTextAlignmentRight];
    [self.bookingScrollView addSubview:self.bookingTotalPrice];
    
    UILabel *depositLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(lineDot1View.frame) + 10 + 30, 120, 20)];
    [depositLabel setText:@"REQUIRED DEPOSIT"];
    [depositLabel setFont:[UIFont phBlond:11]];
    [depositLabel setTextColor:[UIColor blackColor]];
    [depositLabel setBackgroundColor:[UIColor clearColor]];
    [self.bookingScrollView addSubview:depositLabel];
    
    self.bookingDepositPrice = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 160, CGRectGetMaxY(lineDot1View.frame) + 10 + 30, 140, 20)];
    [self.bookingDepositPrice setFont:[UIFont phBlond:11]];
    [self.bookingDepositPrice setTextColor:[UIColor phPurpleColor]];
    [self.bookingDepositPrice setBackgroundColor:[UIColor clearColor]];
    [self.bookingDepositPrice setTextAlignment:NSTextAlignmentRight];
    [self.bookingScrollView addSubview:self.bookingDepositPrice];
    
    UIImageView *lineDot2View = [[UIImageView alloc] initWithFrame:CGRectMake(self.visibleSize.width - 120, CGRectGetMaxY(lineDot1View.frame) + 10 + 30 + 30, 100, 1)];
    [lineDot2View setImage:[UIImage imageNamed:@"line_dot"]];
    [self.bookingScrollView addSubview:lineDot2View];
    
    UILabel *balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(lineDot2View.frame) + 10, 120, 34)];
    [balanceLabel setText:@"ESTIMATED BALANCE \n(PAY AT VENUE)"];
    [balanceLabel setNumberOfLines:2];
    [balanceLabel setFont:[UIFont phBlond:11]];
    [balanceLabel setTextColor:[UIColor blackColor]];
    [balanceLabel setBackgroundColor:[UIColor clearColor]];
    [self.bookingScrollView addSubview:balanceLabel];
    
    self.bookingBalancePrice = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 160, CGRectGetMaxY(lineDot2View.frame) + 10, 140, 20)];
    [self.bookingBalancePrice setFont:[UIFont phBlond:15]];
    [self.bookingBalancePrice setTextColor:[UIColor phPurpleColor]];
    [self.bookingBalancePrice setBackgroundColor:[UIColor clearColor]];
    [self.bookingBalancePrice setTextAlignment:NSTextAlignmentRight];
    [self.bookingScrollView addSubview:self.bookingBalancePrice];
    
    
    // LINE 3
    
    self.bookingInstructionLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(lineDot2View.frame) + 10 + 30 + 50, 120, 20)];
    [self.bookingInstructionLabel setText:@"INSTRUCTIONS"];
    [self.bookingInstructionLabel setFont:[UIFont phBlond:15]];
    [self.bookingInstructionLabel setTextColor:[UIColor blackColor]];
    [self.bookingInstructionLabel setBackgroundColor:[UIColor clearColor]];
    [self.bookingScrollView addSubview:self.bookingInstructionLabel];
    
    self.bookingInstructionLine = [[UIView alloc] initWithFrame:CGRectMake(self.visibleSize.width - 160, CGRectGetMaxY(lineDot2View.frame) + 10 + 30 + 60, 160, 1)];
    [self.bookingInstructionLine setBackgroundColor:[UIColor phLightGrayColor]];
    [self.bookingScrollView addSubview:self.bookingInstructionLine];
    
    self.bookingInstruction = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(self.bookingInstructionLine.frame) + 16, self.visibleSize.width - 28, 20)];
    [self.bookingInstruction setFont:[UIFont phBlond:12]];
    [self.bookingInstruction setTextColor:[UIColor blackColor]];
    [self.bookingInstruction setBackgroundColor:[UIColor clearColor]];
    [self.bookingInstruction setNumberOfLines:0];
    [self.bookingScrollView addSubview:self.bookingInstruction];
    
    self.bookingBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bookingInstruction.frame) + 20, self.visibleSize.width, 110)];
    [self.bookingBottomView setBackgroundColor:[UIColor clearColor]];
    [self.bookingScrollView addSubview:self.bookingBottomView];
    
    // LINE 4
    
    UIView *line4View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.visibleSize.width, 1)];
    [line4View setBackgroundColor:[UIColor phLightGrayColor]];
    [self.bookingBottomView addSubview:line4View];
    
    UIImageView *timeView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 26, 18, 18)];
    [timeView setImage:[UIImage imageNamed:@"icon_time_purple"]];
    [self.bookingBottomView addSubview:timeView];
    
    self.bookingEventNameBottom = [[UILabel alloc] initWithFrame:CGRectMake(50, 16, self.visibleSize.width - 50 - 14, 20)];
    [self.bookingEventNameBottom setFont:[UIFont phBlond:12]];
    [self.bookingEventNameBottom setTextColor:[UIColor blackColor]];
    [self.bookingEventNameBottom setBackgroundColor:[UIColor clearColor]];
    [self.bookingBottomView addSubview:self.bookingEventNameBottom];
    
    self.bookingEventTimeBottom = [[UILabel alloc] initWithFrame:CGRectMake(50, 16 + 20, self.visibleSize.width - 50 - 14, 20)];
    [self.bookingEventTimeBottom setFont:[UIFont phBlond:12]];
    [self.bookingEventTimeBottom setTextColor:[UIColor darkGrayColor]];
    [self.bookingEventTimeBottom setBackgroundColor:[UIColor clearColor]];
    [self.bookingBottomView addSubview:self.bookingEventTimeBottom];
    
    UIImageView *locationView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 80, 12, 18)];
    [locationView setImage:[UIImage imageNamed:@"icon_location_purple"]];
    [self.bookingBottomView addSubview:locationView];
    
    self.bookingEventPlaceBottom = [[UILabel alloc] initWithFrame:CGRectMake(50, 70, self.visibleSize.width - 50 - 14, 20)];
    [self.bookingEventPlaceBottom setFont:[UIFont phBlond:12]];
    [self.bookingEventPlaceBottom setTextColor:[UIColor blackColor]];
    [self.bookingEventPlaceBottom setBackgroundColor:[UIColor clearColor]];
    [self.bookingBottomView addSubview:self.bookingEventPlaceBottom];
    
    self.bookingEventDateBottom = [[UILabel alloc] initWithFrame:CGRectMake(50, 70 + 20, self.visibleSize.width - 50 - 14, 20)];
    [self.bookingEventDateBottom setFont:[UIFont phBlond:12]];
    [self.bookingEventDateBottom setTextColor:[UIColor darkGrayColor]];
    [self.bookingEventDateBottom setBackgroundColor:[UIColor clearColor]];
    [self.bookingBottomView addSubview:self.bookingEventDateBottom];
    
    self.bookingScrollView.contentSize = CGSizeMake(self.visibleSize.width, CGRectGetMaxY(self.bookingBottomView.frame) + 10);
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
                            NSDictionary *summary = [self.successData objectForKey:@"summary"];
                            if (summary && summary != nil) {
                                // MixPanel
                                SharedData *sharedData = [SharedData sharedInstance];
                                
                                NSDictionary *productList = [[summary objectForKey:@"product_list"] objectAtIndex:0];
                                if ([[productList objectForKey:@"ticket_type"] isEqualToString:@"booking"]) {
                                    [self.scrollView setHidden:YES];
                                    [self populateBookingData];
                                    
                                    [sharedData.mixPanelCTicketDict setObject:[productList objectForKey:@"num_buy"] forKey:@"Total Guest"];
                                } else {
                                    [self.bookingScrollView setHidden:YES];
                                    [self populateData];
                                    
                                    [sharedData.mixPanelCTicketDict setObject:[productList objectForKey:@"num_buy"] forKey:@"Purchase Quantity"];
                                }
                                
                                [self.emptyView setMode:@"hide"];
                                
                                [sharedData.mixPanelCTicketDict setObject:[summary objectForKey:@"created_at"] forKey:@"Date Time"];
                                [sharedData.mixPanelCTicketDict setObject:[productList objectForKey:@"total_price_all"] forKey:@"Purchase Amount"];
                                [sharedData.mixPanelCTicketDict setObject:[self.successData objectForKey:@"payment_type"] forKey:@"Purchase Payment"];
                                if (self.showViewButton) {
                                    [[AnalyticManager sharedManager] trackMixPanelWithDict:@"Commerce Finish" withDict:sharedData.mixPanelCTicketDict];
                                }
                                
                                return ;
                            }
                        }
                    }
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
                
                [self.emptyView setMode:@"empty"];
                                                         
            }
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.response.statusCode == 410) {
            [self reloadLoginWithFBToken];
        } else {
            [self.emptyView setMode:@"empty"];
        }
    }];
}

- (void)reloadLoginWithFBToken {
    SharedData *sharedData = [SharedData sharedInstance];
    
    [sharedData loginWithFBToken:^(AFHTTPRequestOperation *operation, id responseObject) {
        sharedData.ph_token = responseObject[@"data"][@"token"];
        [self loadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self reloadLoginWithFBToken];
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
            
            NSString *type = [self.successData objectForKey:@"payment_type"];
            if (type && type != nil) {
                if ([type isEqualToString:@"cc"]) {
                    [self.paymentMethod setText:@"CREDIT CARD"];
                } else if ([type isEqualToString:@"bca"]) {
                    [self.paymentMethod setText:@"BCA VIRTUAL ACCOUNT"];
                } else if ([type isEqualToString:@"bp"]) {
                    [self.paymentMethod setText:@"MANDIRI VIRTUAL ACCOUNT"];
                } else if ([type isEqualToString:@"va"]) {
                    [self.paymentMethod setText:@"BANK TRANSFER"];
                } else {
                    [self.paymentMethod setText:@"FREE"];
                }
            }
            
            NSString *created_at = [summary objectForKey:@"created_at"];
            if (created_at && created_at != nil) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:PHDateFormatServer];
                [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
                [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
                NSDate *transactionDateTime = [formatter dateFromString:created_at];
                
                [formatter setDateFormat:@"dd MMMM yyyy - HH:mm:ss"];
                [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
                [formatter setTimeZone:[NSTimeZone localTimeZone]];
                NSString *transactionFormatTime = [formatter stringFromDate:transactionDateTime];
                
                [self.orderDate setText:transactionFormatTime];
            }
            
            NSDictionary *productList = [[summary objectForKey:@"product_list"] objectAtIndex:0];
            
            SharedData *sharedData = [SharedData sharedInstance];
            
            NSString *ticketName = [productList objectForKey:@"name"];
            if (ticketName && ticketName != nil) {
                NSString *num_buy = [productList objectForKey:@"num_buy"];
                [self.ticketName setText:[NSString stringWithFormat:@"%@ (%@x)", ticketName, num_buy]];
            }
            
            NSString *total_price = [productList objectForKey:@"total_price"];
            if (total_price && total_price != nil) {
                if ([total_price integerValue] == 0) {
                    [self.ticketPrice setText:@"FREE"];
                } else {
                    NSString *formattedPrice = [sharedData formatCurrencyString:total_price];
                    [self.ticketPrice setText:[NSString stringWithFormat:@"Rp%@", formattedPrice]];
                }
            }
            
            NSString *admin_fee = [productList objectForKey:@"admin_fee"];
            if (admin_fee && admin_fee != nil) {
                if ([admin_fee integerValue] == 0) {
                    [self.adminPrice setText:@"FREE"];
                } else {
                    NSString *formattedPrice = [sharedData formatCurrencyString:admin_fee];
                    [self.adminPrice setText:[NSString stringWithFormat:@"Rp%@", formattedPrice]];
                }
            }
            
            NSString *tax_amount = [productList objectForKey:@"tax_amount"];
            if (tax_amount && tax_amount != nil) {
                if ([tax_amount integerValue] == 0) {
                    [self.taxPrice setText:@"FREE"];
                } else {
                    NSString *formattedPrice = [sharedData formatCurrencyString:tax_amount];
                    [self.taxPrice setText:[NSString stringWithFormat:@"Rp%@", formattedPrice]];
                }
            }
            
            NSString *total_price_all = [productList objectForKey:@"total_price_all"];
            if (total_price_all && total_price_all != nil) {
                if ([total_price_all integerValue] == 0) {
                    [self.totalPrice setText:@"FREE"];
                } else {
                    NSString *formattedPrice = [sharedData formatCurrencyString:total_price_all];
                    [self.totalPrice setText:[NSString stringWithFormat:@"Rp%@", formattedPrice]];
                }
            }
            
            NSString *instructions = [self.successData objectForKey:@"instructions"];
            if (instructions && instructions != nil && ![instructions isEqualToString:@""]) {
                
                NSMutableAttributedString *parsedInstruction = [[NSMutableAttributedString alloc] initWithData:[instructions dataUsingEncoding:NSUTF8StringEncoding]
                                                                                                       options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                                                 NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                                                            documentAttributes:nil
                                                                                                         error:nil];
                UIFont *font = [UIFont fontWithName:@"Lato-Regular" size:11.0];
                NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                            forKey:NSFontAttributeName];
                [parsedInstruction addAttributes:attrsDictionary range:NSMakeRange(0, parsedInstruction.length)];
                self.instruction.attributedText = parsedInstruction;
            } else {
                self.instruction.text = @"";
                [self.instructionLabel setHidden:YES];
                [self.instructionLine setHidden:YES];
            }
            [self.instruction sizeToFit];
            
            [self.bottomView setFrame:CGRectMake(0, CGRectGetMaxY(self.instruction.frame) + 20, self.visibleSize.width, 110)];
            
            self.scrollView.contentSize = CGSizeMake(self.visibleSize.width, CGRectGetMaxY(self.bottomView.frame) + 10);
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (void)populateBookingData {
    @try {
        [self.bookingOrderNumber setText:[self.successData objectForKey:@"order_number"]];
        
        NSDictionary *event = [self.successData objectForKey:@"event"];
        
        NSString *title = [event objectForKey:@"title"];
        if (title && title != nil) {
            [self.bookingEventName setText:[title uppercaseString]];
            [self.bookingEventNameBottom setText:[title uppercaseString]];
        }
        
        NSString *venueName = [event objectForKey:@"venue_name"];
        if (venueName && venueName != nil) {
            [self.bookingEventPlaceBottom setText:[venueName uppercaseString]];
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
        
        [self.bookingEventDate setText:shortDateTime];
        [self.bookingEventDateBottom setText:shortDateTime];
        
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
        
        [self.bookingEventTimeBottom setText:[NSString stringWithFormat:@"%@ - %@", startMicroDateTime, endMicroDateTime]];
        
        
        NSDictionary *summary = [self.successData objectForKey:@"summary"];
        if (summary && summary != nil) {
            NSDictionary *guest_detail = [summary objectForKey:@"guest_detail"];
            
            NSString *name = [guest_detail objectForKey:@"name"];
            if (name && name != nil) {
                [self.bookingCongratsLabel setText:[NSString stringWithFormat:@"Congratulations %@!", name]];
                [self.bookingGuestName setText:[name uppercaseString]];
            }
            
            NSString *payment_status = [summary objectForKey:@"payment_status"];
            if (payment_status && payment_status != nil) {
                [self.bookingStatus setText:[payment_status uppercaseString]];
            }
            
            NSString *type = [self.successData objectForKey:@"payment_type"];
            if (type && type != nil) {
                if ([type isEqualToString:@"cc"]) {
                    [self.bookingPaymentMethod setText:@"CREDIT CARD"];
                } else if ([type isEqualToString:@"bca"]) {
                    [self.bookingPaymentMethod setText:@"BCA VIRTUAL ACCOUNT"];
                } else if ([type isEqualToString:@"bp"]) {
                    [self.bookingPaymentMethod setText:@"MANDIRI VIRTUAL ACCOUNT"];
                } else if ([type isEqualToString:@"va"]) {
                    [self.bookingPaymentMethod setText:@"BANK TRANSFER"];
                } else {
                    [self.bookingPaymentMethod setText:@"FREE"];
                }
            }
            
            if ([self.bookingPaymentMethod.text isEqualToString:@"FREE"]) {
                [self.bookingStatus setText:@"BOOKED"];
            }
            
            NSString *created_at = [summary objectForKey:@"created_at"];
            if (created_at && created_at != nil) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:PHDateFormatServer];
                [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
                [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
                NSDate *transactionDateTime = [formatter dateFromString:created_at];
                
                [formatter setDateFormat:@"dd MMMM yyyy - HH:mm:ss"];
                [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
                [formatter setTimeZone:[NSTimeZone localTimeZone]];
                NSString *transactionFormatTime = [formatter stringFromDate:transactionDateTime];
                
                [self.bookingOrderDate setText:transactionFormatTime];
            }
            
            NSDictionary *productList = [[summary objectForKey:@"product_list"] objectAtIndex:0];
            
            SharedData *sharedData = [SharedData sharedInstance];
            
            NSString *ticketName = [productList objectForKey:@"name"];
            if (ticketName && ticketName != nil) {
                [self.bookingTicketName setText:[NSString stringWithFormat:@"%@", [ticketName uppercaseString]]];
            }
            
            NSString *num_buy = [productList objectForKey:@"num_buy"];
            if (num_buy && num_buy != nil) {
                [self.bookingTotalGuest setText:[NSString stringWithFormat:@"%@", num_buy]];
            }
            
            NSString *total_price = [productList objectForKey:@"total_price"];
            if (total_price && total_price != nil) {
                NSString *formattedPrice = [sharedData formatCurrencyString:total_price];
                [self.bookingTicketPrice setText:[NSString stringWithFormat:@"Rp%@", formattedPrice]];
            }
            
            NSString *admin_fee = [productList objectForKey:@"admin_fee"];
            if (admin_fee && admin_fee != nil) {
                NSString *formattedPrice = [sharedData formatCurrencyString:admin_fee];
                [self.bookingServicePrice setText:[NSString stringWithFormat:@"Rp%@", formattedPrice]];
            }
            
            NSString *tax_amount = [productList objectForKey:@"tax_amount"];
            if (tax_amount && tax_amount != nil) {
                NSString *formattedPrice = [sharedData formatCurrencyString:tax_amount];
                [self.bookingTaxPrice setText:[NSString stringWithFormat:@"Rp%@", formattedPrice]];
            }
            
            NSString *total_price_all = [productList objectForKey:@"total_price_all"];
            if (total_price_all && total_price_all != nil) {
                NSString *formattedPrice = [sharedData formatCurrencyString:total_price_all];
                [self.bookingTotalPrice setText:[NSString stringWithFormat:@"Rp%@", formattedPrice]];
            }
            
            NSNumber *pay_deposit = [summary objectForKey:@"pay_deposit"];
            if (pay_deposit && pay_deposit != nil) {
                NSString *depositPrice = [sharedData formatCurrencyString:[pay_deposit stringValue]];
                [self.bookingDepositPrice setText:[NSString stringWithFormat:@"Rp%@", depositPrice]];
            }
            
            if (pay_deposit && total_price_all) {
                NSInteger balance = [total_price_all integerValue] - [pay_deposit integerValue];
                NSString *balanceText = [NSString stringWithFormat:@"%li", (long)balance];
                NSString *balancePrice = [sharedData formatCurrencyString:balanceText];
                [self.bookingBalancePrice setText:[NSString stringWithFormat:@"Rp%@", balancePrice]];
            }
            
            NSString *instructions = [self.successData objectForKey:@"instructions"];
            if (instructions && instructions != nil && ![instructions isEqualToString:@""]) {
                
                NSMutableAttributedString *parsedInstruction = [[NSMutableAttributedString alloc] initWithData:[instructions dataUsingEncoding:NSUTF8StringEncoding]
                                                                                         options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                                   NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                                              documentAttributes:nil
                                                                                           error:nil];
                UIFont *font = [UIFont fontWithName:@"Lato-Regular" size:11.0];
                NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                            forKey:NSFontAttributeName];
                [parsedInstruction addAttributes:attrsDictionary range:NSMakeRange(0, parsedInstruction.length)];
                self.bookingInstruction.attributedText = parsedInstruction;
            } else {
                self.bookingInstruction.text = @"";
                [self.bookingInstructionLabel setHidden:YES];
                [self.bookingInstructionLine setHidden:YES];
            }
            [self.bookingInstruction sizeToFit];
            
            [self.bookingBottomView setFrame:CGRectMake(0, CGRectGetMaxY(self.bookingInstruction.frame) + 20, self.visibleSize.width, 110)];
            
            self.bookingScrollView.contentSize = CGSizeMake(self.visibleSize.width, CGRectGetMaxY(self.bookingBottomView.frame) + 10);
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}


@end
