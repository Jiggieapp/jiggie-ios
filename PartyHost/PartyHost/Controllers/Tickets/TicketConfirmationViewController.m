//
//  TicketConfirmationViewController.m
//  Jiggie
//
//  Created by Setiady Wiguna on 3/9/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "TicketConfirmationViewController.h"
#import <MessageUI/MessageUI.h>

#import "PaymentSelectionViewController.h"
#import "TicketSuccessViewController.h"
#import "VirtualAccountViewController.h"
#import "SVProgressHUD.h"
#import "VTConfig.h"
#import "VTDirect.h"
#import "AnalyticManager.h"

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
    [self.view setBackgroundColor:[UIColor colorFromHexCode:@"F1F1F1"]];
    
    self.navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.visibleSize.width, 60)];
    [self.navBar setBackgroundColor:[UIColor phPurpleColor]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, self.visibleSize.width - 80, 40)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:@"Booking Info"];
    [titleLabel setFont:[UIFont phBlond:16]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.navBar addSubview:titleLabel];
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton setFrame:CGRectMake(0.0f, 20.0f, 40.0f, 40.0f)];
    [self.closeButton setImageEdgeInsets:UIEdgeInsetsMake(8, 14, 8, 14)];
    [self.closeButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:self.closeButton];
    
    UIButton *helpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [helpButton setFrame:CGRectMake(self.visibleSize.width - 60, 20.0f, 50.0f, 40.0f)];
    [helpButton setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 0)];
    [helpButton setImage:[UIImage imageNamed:@"button_help"] forState:UIControlStateNormal];
    [helpButton addTarget:self action:@selector(helpButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:helpButton];
    
    [self.view addSubview:self.navBar];
    
    self.selectPaymentLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, self.view.bounds.size.height - 54 - 100, 120, 20)];
    [self.selectPaymentLabel setText:@"SELECT PAYMENT"];
    [self.selectPaymentLabel setFont:[UIFont phBlond:13]];
    [self.selectPaymentLabel setTextColor:[UIColor blackColor]];
    [self.selectPaymentLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.selectPaymentLabel];
    
    self.paymentBox = [[UIImageView alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(self.selectPaymentLabel.frame) + 4, self.visibleSize.width - 16, 70)];
    [self.paymentBox setImage:[[UIImage imageNamed:@"bg_rectangle"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    [self.view addSubview:self.paymentBox];
    
    self.paymentLogoView = [[UIImageView alloc] initWithFrame:CGRectMake(24, 15, 40, 40)];
    [self.paymentLogoView setImage:[UIImage imageNamed:@"icon_add"]];
    [self.paymentLogoView setContentMode:UIViewContentModeCenter];
    [self.paymentBox addSubview:self.paymentLogoView];
    
    self.paymentTitleView = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, self.visibleSize.width - 80 - 24, 30)];
    [self.paymentTitleView setText:@"CHOOSE PAYMENT METHOD"];
    [self.paymentTitleView setFont:[UIFont phBlond:13]];
    [self.paymentTitleView setTextColor:[UIColor phPurpleColor]];
    [self.paymentTitleView setBackgroundColor:[UIColor clearColor]];
    [self.paymentBox addSubview:self.paymentTitleView];
    
    UIImageView *accessory = [[UIImageView alloc] initWithFrame:CGRectMake(self.paymentBox.bounds.size.width - 28, 23, 16, 24)];
    [accessory setImage:[UIImage imageNamed:@"icon_blue_arrow"]];
    [self.paymentBox addSubview:accessory];
    
    self.paymentAddButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.paymentAddButton setFrame:self.paymentBox.frame];
    [self.paymentAddButton addTarget:self action:@selector(paymentAddButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.paymentAddButton setBackgroundColor:[UIColor clearColor]];
    [self.paymentAddButton setHighlighted:YES];
    [self.view addSubview:self.paymentAddButton];
    
    self.continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.continueButton setFrame:CGRectMake(self.visibleSize.width, 0, self.visibleSize.width, 54)];
    [self.continueButton setBackgroundColor:[UIColor clearColor]];
    [self.continueButton.titleLabel setFont:[UIFont phBold:15]];
    [self.continueButton setTitle:@"SWIPE TO PAY" forState:UIControlStateNormal];
    [self.continueButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [self.continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.continueButton setEnabled:NO];
    
    self.iconArrow1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.visibleSize.width/2 + 50, (self.continueButton.bounds.size.height-15) /2, 9, 15)];
    [self.iconArrow1 setImage:[UIImage imageNamed:@"icon_arrow"]];
    [self.continueButton addSubview:self.iconArrow1];
    
    self.iconArrow2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.visibleSize.width/2 + 56, (self.continueButton.bounds.size.height-15) /2, 9, 15)];
    [self.iconArrow2 setImage:[UIImage imageNamed:@"icon_arrow"]];
    [self.continueButton addSubview:self.iconArrow2];
    
    self.swipeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 54, self.visibleSize.width, 54)];
    [self.swipeScrollView setBackgroundColor:[UIColor colorFromHexCode:@"B6ECFF"]];
    [self.swipeScrollView setContentSize:CGSizeMake(self.visibleSize.width * 2, 54)];
    [self.swipeScrollView setShowsHorizontalScrollIndicator:NO];
    [self.swipeScrollView setPagingEnabled:YES];
    [self.swipeScrollView setDelegate:self];
    [self.swipeScrollView addSubview:self.continueButton];
    [self.swipeScrollView setContentOffset:CGPointMake(self.visibleSize.width, 0)];
    [self.view addSubview:self.swipeScrollView];
    
    
    if ([[self.productList objectForKey:@"ticket_type"] isEqualToString:@"booking"]) {
        [self loadBookingView];
        
        if (self.currentPrice == 0) {
            [self showPaymentMethod:NO withAnimation:NO];
        }
    } else {
        [self loadPurchaseView];
        
        // hide payment for free ticket
        NSString *total_price = [self.productList objectForKey:@"total_price_all"];
        if ([total_price integerValue] == 0) {
            [self showPaymentMethod:NO withAnimation:NO];
        }
    }
    
    [self prePopulatePayment];

    // MixPanel
    SharedData *sharedData = [SharedData sharedInstance];
    [[AnalyticManager sharedManager] trackMixPanelWithDict:@"Purchase Confirmation" withDict:sharedData.mixPanelCTicketDict];
}

#pragma mark - View
- (void)loadPurchaseView {
    // SCROLL VIEW
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, self.visibleSize.width, self.view.bounds.size.height - 60 - 100)];
    self.scrollView.showsVerticalScrollIndicator    = YES;
    self.scrollView.showsHorizontalScrollIndicator  = NO;
    self.scrollView.scrollEnabled                   = YES;
    self.scrollView.userInteractionEnabled          = YES;
    self.scrollView.backgroundColor                 = [UIColor clearColor];
    self.scrollView.contentSize                     = CGSizeMake(self.visibleSize.width, 500);
    [self.view addSubview:self.scrollView];
    
    UIView *tmpPurpleView = [[UIView alloc] initWithFrame:CGRectMake(0, -300, self.visibleSize.width, 300)];
    tmpPurpleView.backgroundColor = [UIColor phPurpleColor];
    [self.scrollView addSubview:tmpPurpleView];
    
    CGRect eventFrame = [self.eventTitleString boundingRectWithSize:CGSizeMake(self.view.bounds.size.width - 28, 40)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{NSFontAttributeName:[UIFont phBlond:15]}
                                                            context:nil];
    
    UILabel *eventTitle = [[UILabel alloc] initWithFrame:CGRectMake(14, 16, self.view.bounds.size.width - 28, eventFrame.size.height)];
    [eventTitle setFont:[UIFont phBlond:15]];
    [eventTitle setTextColor:[UIColor blackColor]];
    [eventTitle setBackgroundColor:[UIColor clearColor]];
    [eventTitle setTextAlignment:NSTextAlignmentCenter];
    [eventTitle setNumberOfLines:2];
    [eventTitle setText:self.eventTitleString];
    [self.scrollView addSubview:eventTitle];
    
    UILabel *eventVenue = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(eventTitle.frame) + 4, self.view.bounds.size.width - 28, 16)];
    [eventVenue setFont:[UIFont phBlond:12]];
    [eventVenue setTextColor:[UIColor darkGrayColor]];
    [eventVenue setBackgroundColor:[UIColor clearColor]];
    [eventVenue setTextAlignment:NSTextAlignmentCenter];
    [eventVenue setText:self.eventVenueString];
    [self.scrollView addSubview:eventVenue];
    
    UILabel *eventDate = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(eventVenue.frame) + 4, self.view.bounds.size.width, 16)];
    [eventDate setFont:[UIFont phBlond:12]];
    [eventDate setTextColor:[UIColor darkGrayColor]];
    [eventDate setBackgroundColor:[UIColor clearColor]];
    [eventDate setTextAlignment:NSTextAlignmentCenter];
    [eventDate setText:self.eventDateString];
    [self.scrollView addSubview:eventDate];
    
    UIView *line1View = [[UIView alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(eventDate.frame) + 8, self.visibleSize.width - 28, 1)];
    [line1View setBackgroundColor:[UIColor phLightGrayColor]];
    [self.scrollView addSubview:line1View];

    
    CGFloat ticketTitleWidth = self.visibleSize.width/2;
    
    UILabel *ticketTitle = [[UILabel alloc] initWithFrame:CGRectMake(18, CGRectGetMaxY(line1View.frame) + 14, ticketTitleWidth, 20)];
    [ticketTitle setFont:[UIFont phBlond:13]];
    [ticketTitle setTextColor:[UIColor darkGrayColor]];
    [ticketTitle setBackgroundColor:[UIColor clearColor]];
    [ticketTitle setText:[NSString stringWithFormat:@"%@ (%@x)",[self.productList objectForKey:@"name"], [self.productList objectForKey:@"num_buy"]]];
    [self.scrollView addSubview:ticketTitle];
    
    
    SharedData *sharedData = [SharedData sharedInstance];
    
    UILabel *ticketPrice = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 140, CGRectGetMaxY(line1View.frame) + 14, 120, 20)];
    [ticketPrice setFont:[UIFont phBlond:13]];
    [ticketPrice setTextColor:[UIColor phPurpleColor]];
    [ticketPrice setBackgroundColor:[UIColor clearColor]];
    [ticketPrice setTextAlignment:NSTextAlignmentRight];
    NSString *price = [sharedData formatCurrencyString:[self.productList objectForKey:@"total_price"]];
    if ([price integerValue] == 0) {
        [ticketPrice setText:@"FREE"];
    } else {
        [ticketPrice setText:[NSString stringWithFormat:@"Rp%@",price]];
    }
    [self.scrollView addSubview:ticketPrice];
    
    UILabel *adminTitle = [[UILabel alloc] initWithFrame:CGRectMake(18, CGRectGetMaxY(line1View.frame) + 14 + 30, ticketTitleWidth, 20)];
    [adminTitle setFont:[UIFont phBlond:13]];
    [adminTitle setTextColor:[UIColor darkGrayColor]];
    [adminTitle setBackgroundColor:[UIColor clearColor]];
    [adminTitle setText:@"Administrative Fee"];
    [self.scrollView addSubview:adminTitle];
    
    UILabel *adminPrice = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 140, CGRectGetMaxY(line1View.frame) + 14 + 30, 120, 20)];
    [adminPrice setFont:[UIFont phBlond:13]];
    [adminPrice setTextColor:[UIColor phPurpleColor]];
    [adminPrice setBackgroundColor:[UIColor clearColor]];
    [adminPrice setTextAlignment:NSTextAlignmentRight];
    NSString *admin_fee = [sharedData formatCurrencyString:[self.productList objectForKey:@"admin_fee"]];
    if ([admin_fee integerValue] == 0) {
        [adminPrice setText:@"FREE"];
    } else {
        [adminPrice setText:[NSString stringWithFormat:@"Rp%@",admin_fee]];
    }
    [self.scrollView addSubview:adminPrice];
    
    UILabel *taxTitle = [[UILabel alloc] initWithFrame:CGRectMake(18, CGRectGetMaxY(line1View.frame) + 14 + 30 + 30, ticketTitleWidth, 20)];
    [taxTitle setFont:[UIFont phBlond:13]];
    [taxTitle setTextColor:[UIColor darkGrayColor]];
    [taxTitle setBackgroundColor:[UIColor clearColor]];
    [taxTitle setText:@"Tax"];
    [self.scrollView addSubview:taxTitle];
    
    UILabel *taxPrice = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 140, CGRectGetMaxY(line1View.frame) + 14 + 30 + 30, 120, 20)];
    [taxPrice setFont:[UIFont phBlond:13]];
    [taxPrice setTextColor:[UIColor phPurpleColor]];
    [taxPrice setBackgroundColor:[UIColor clearColor]];
    [taxPrice setTextAlignment:NSTextAlignmentRight];
    NSString *tax_amount = [sharedData formatCurrencyString:[self.productList objectForKey:@"tax_amount"]];
    if ([tax_amount integerValue] == 0) {
        [taxPrice setText:@"FREE"];
    } else {
        [taxPrice setText:[NSString stringWithFormat:@"Rp%@",tax_amount]];
    }
    [self.scrollView addSubview:taxPrice];
    
    // Line 2
    UIView *line2View = [[UIView alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(line1View.frame) + 14 + 30 + 30 + 30, self.visibleSize.width - 28, 1)];
    [line2View setBackgroundColor:[UIColor phLightGrayColor]];
    [self.scrollView addSubview:line2View];
    
    UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, CGRectGetMaxY(line2View.frame) + 20, 100, 20)];
    [totalLabel setText:@"Total Price"];
    [totalLabel setFont:[UIFont phBlond:13]];
    [totalLabel setTextColor:[UIColor blackColor]];
    [totalLabel setBackgroundColor:[UIColor clearColor]];
    [self.scrollView addSubview:totalLabel];
    
    self.totalPrice = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 100 - 20, CGRectGetMaxY(line2View.frame) + 20, 100, 20)];
    [self.totalPrice setTextAlignment:NSTextAlignmentRight];
    [self.totalPrice setFont:[UIFont phBlond:18]];
    [self.totalPrice setTextColor:[UIColor phPurpleColor]];
    [self.totalPrice setBackgroundColor:[UIColor clearColor]];
    NSString *total_price = [sharedData formatCurrencyString:[self.productList objectForKey:@"total_price_all"]];
    if ([total_price integerValue] == 0) {
        [self.totalPrice setText:@"FREE"];
    } else {
        [self.totalPrice setText:[NSString stringWithFormat:@"Rp%@",total_price]];
    }
    [self.scrollView addSubview:self.totalPrice];
    
    self.scrollView.contentSize = CGSizeMake(self.visibleSize.width, CGRectGetMaxY(self.totalPrice.frame) + 16);
}

- (void)loadBookingView {
    // SCROLL VIEW
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, self.visibleSize.width, self.view.bounds.size.height - 60 - 54 - 100 - 110)];
    self.scrollView.showsVerticalScrollIndicator    = YES;
    self.scrollView.showsHorizontalScrollIndicator  = NO;
    self.scrollView.scrollEnabled                   = YES;
    self.scrollView.userInteractionEnabled          = YES;
    self.scrollView.backgroundColor                 = [UIColor clearColor];
    self.scrollView.contentSize                     = CGSizeMake(self.visibleSize.width, 500);
    [self.view addSubview:self.scrollView];
    
    UIView *tmpPurpleView = [[UIView alloc] initWithFrame:CGRectMake(0, -300, self.visibleSize.width, 300)];
    tmpPurpleView.backgroundColor = [UIColor phPurpleColor];
    [self.scrollView addSubview:tmpPurpleView];
    
    CGRect eventFrame = [self.eventTitleString boundingRectWithSize:CGSizeMake(self.view.bounds.size.width - 28, 40)
                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                          attributes:@{NSFontAttributeName:[UIFont phBlond:15]}
                                                             context:nil];
    
    UILabel *eventTitle = [[UILabel alloc] initWithFrame:CGRectMake(14, 16, self.view.bounds.size.width - 28, eventFrame.size.height)];
    [eventTitle setFont:[UIFont phBlond:15]];
    [eventTitle setTextColor:[UIColor blackColor]];
    [eventTitle setBackgroundColor:[UIColor clearColor]];
    [eventTitle setTextAlignment:NSTextAlignmentCenter];
    [eventTitle setNumberOfLines:2];
    [eventTitle setText:self.eventTitleString];
    [self.scrollView addSubview:eventTitle];
    
    UILabel *eventVenue = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(eventTitle.frame) + 4, self.view.bounds.size.width - 28, 16)];
    [eventVenue setFont:[UIFont phBlond:12]];
    [eventVenue setTextColor:[UIColor darkGrayColor]];
    [eventVenue setBackgroundColor:[UIColor clearColor]];
    [eventVenue setTextAlignment:NSTextAlignmentCenter];
    [eventVenue setText:self.eventVenueString];
    [self.scrollView addSubview:eventVenue];
    
    UILabel *eventDate = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(eventVenue.frame) + 4, self.view.bounds.size.width, 16)];
    [eventDate setFont:[UIFont phBlond:12]];
    [eventDate setTextColor:[UIColor darkGrayColor]];
    [eventDate setBackgroundColor:[UIColor clearColor]];
    [eventDate setTextAlignment:NSTextAlignmentCenter];
    [eventDate setText:self.eventDateString];
    [self.scrollView addSubview:eventDate];
    
    UIView *line1View = [[UIView alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(eventDate.frame) + 8, self.visibleSize.width - 28, 1)];
    [line1View setBackgroundColor:[UIColor phLightGrayColor]];
    [self.scrollView addSubview:line1View];
    
    CGFloat ticketTitleWidth = self.visibleSize.width/2;
    
    UILabel *ticketTitle = [[UILabel alloc] initWithFrame:CGRectMake(18, CGRectGetMaxY(line1View.frame) + 14, ticketTitleWidth, 20)];
    [ticketTitle setFont:[UIFont phBlond:13]];
    [ticketTitle setTextColor:[UIColor darkGrayColor]];
    [ticketTitle setBackgroundColor:[UIColor clearColor]];
    [ticketTitle setText:[NSString stringWithFormat:@"%@ (Estimate)",[self.productList objectForKey:@"name"]]];
    [self.scrollView addSubview:ticketTitle];
    
    
    SharedData *sharedData = [SharedData sharedInstance];
    
    UILabel *ticketPrice = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 140, CGRectGetMaxY(line1View.frame) + 14, 120, 20)];
    [ticketPrice setFont:[UIFont phBlond:13]];
    [ticketPrice setTextColor:[UIColor phPurpleColor]];
    [ticketPrice setBackgroundColor:[UIColor clearColor]];
    [ticketPrice setTextAlignment:NSTextAlignmentRight];
    NSString *price = [sharedData formatCurrencyString:[self.productList objectForKey:@"total_price"]];
    [ticketPrice setText:[NSString stringWithFormat:@"Rp%@",price]];
    [self.scrollView addSubview:ticketPrice];
    
    UILabel *taxTitle = [[UILabel alloc] initWithFrame:CGRectMake(18, CGRectGetMaxY(line1View.frame) + 14 + 30, ticketTitleWidth, 20)];
    [taxTitle setFont:[UIFont phBlond:13]];
    [taxTitle setTextColor:[UIColor darkGrayColor]];
    [taxTitle setBackgroundColor:[UIColor clearColor]];
    [taxTitle setText:@"Tax"];
    [self.scrollView addSubview:taxTitle];
    
    UILabel *taxPrice = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 140, CGRectGetMaxY(line1View.frame) + 14 + 30, 120, 20)];
    [taxPrice setFont:[UIFont phBlond:13]];
    [taxPrice setTextColor:[UIColor phPurpleColor]];
    [taxPrice setBackgroundColor:[UIColor clearColor]];
    [taxPrice setTextAlignment:NSTextAlignmentRight];
    NSString *tax_amount = [sharedData formatCurrencyString:[self.productList objectForKey:@"tax_amount"]];
    [taxPrice setText:[NSString stringWithFormat:@"Rp%@",tax_amount]];
    [self.scrollView addSubview:taxPrice];
    
    UILabel *serviceChargeTitle = [[UILabel alloc] initWithFrame:CGRectMake(18, CGRectGetMaxY(line1View.frame) + 14 + 30 + 30, ticketTitleWidth, 20)];
    [serviceChargeTitle setFont:[UIFont phBlond:13]];
    [serviceChargeTitle setTextColor:[UIColor darkGrayColor]];
    [serviceChargeTitle setBackgroundColor:[UIColor clearColor]];
    [serviceChargeTitle setText:@"Service Charge"];
    [self.scrollView addSubview:serviceChargeTitle];
    
    UILabel *servicePrice = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 140, CGRectGetMaxY(line1View.frame) + 14 + 30 + 30, 120, 20)];
    [servicePrice setFont:[UIFont phBlond:13]];
    [servicePrice setTextColor:[UIColor phPurpleColor]];
    [servicePrice setBackgroundColor:[UIColor clearColor]];
    [servicePrice setTextAlignment:NSTextAlignmentRight];
    NSString *admin_fee = [sharedData formatCurrencyString:[self.productList objectForKey:@"admin_fee"]];
    [servicePrice setText:[NSString stringWithFormat:@"Rp%@",admin_fee]];
    [self.scrollView addSubview:servicePrice];
    
    UIImageView *lineDot1View = [[UIImageView alloc] initWithFrame:CGRectMake(self.visibleSize.width - 120, CGRectGetMaxY(line1View.frame) + 14 + 30 + 30 + 30, 100, 1)];
    [lineDot1View setImage:[UIImage imageNamed:@"line_dot"]];
    [self.scrollView addSubview:lineDot1View];
    
    UILabel *estimatedLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, CGRectGetMaxY(lineDot1View.frame) + 14, ticketTitleWidth, 20)];
    [estimatedLabel setFont:[UIFont phBlond:13]];
    [estimatedLabel setTextColor:[UIColor darkGrayColor]];
    [estimatedLabel setBackgroundColor:[UIColor clearColor]];
    [estimatedLabel setText:@"Estimated Total"];
    [self.scrollView addSubview:estimatedLabel];
    
    UILabel *estimatedPrice = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 140, CGRectGetMaxY(lineDot1View.frame) + 14, 120, 20)];
    [estimatedPrice setFont:[UIFont phBlond:13]];
    [estimatedPrice setTextColor:[UIColor phPurpleColor]];
    [estimatedPrice setBackgroundColor:[UIColor clearColor]];
    [estimatedPrice setTextAlignment:NSTextAlignmentRight];
    NSString *total_price_all = [sharedData formatCurrencyString:[self.productList objectForKey:@"total_price_all"]];
    [estimatedPrice setText:[NSString stringWithFormat:@"Rp%@",total_price_all]];
    [self.scrollView addSubview:estimatedPrice];
    
    UILabel *requiredLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, CGRectGetMaxY(lineDot1View.frame) + 14 + 30, ticketTitleWidth, 20)];
    [requiredLabel setFont:[UIFont phBlond:13]];
    [requiredLabel setTextColor:[UIColor blackColor]];
    [requiredLabel setBackgroundColor:[UIColor clearColor]];
    [requiredLabel setText:@"Required Deposit"];
    [self.scrollView addSubview:requiredLabel];
    
    self.requiredPrice = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 140, CGRectGetMaxY(lineDot1View.frame) + 14 + 30, 120, 20)];
    [self.requiredPrice setFont:[UIFont phBlond:13]];
    [self.requiredPrice setTextColor:[UIColor blackColor]];
    [self.requiredPrice setBackgroundColor:[UIColor clearColor]];
    [self.requiredPrice setTextAlignment:NSTextAlignmentRight];
    NSString *min_deposit_amount = [sharedData formatCurrencyString:[self.productList objectForKey:@"min_deposit_amount"]];
    [self.requiredPrice setText:[NSString stringWithFormat:@"Rp%@",min_deposit_amount]];
    [self.scrollView addSubview:self.requiredPrice];
    
    UIImageView *lineDot2View = [[UIImageView alloc] initWithFrame:CGRectMake(self.visibleSize.width - 120, CGRectGetMaxY(lineDot1View.frame) + 14 + 30 + 30, 100, 1)];
    [lineDot2View setImage:[UIImage imageNamed:@"line_dot"]];
    [self.scrollView addSubview:lineDot2View];
    
    UILabel *balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, CGRectGetMaxY(lineDot2View.frame) + 14, ticketTitleWidth + 40, 20)];
    [balanceLabel setFont:[UIFont phBlond:13]];
    [balanceLabel setTextColor:[UIColor darkGrayColor]];
    [balanceLabel setBackgroundColor:[UIColor clearColor]];
    [balanceLabel setText:@"Estimated Balance (pay at venue)"];
    [self.scrollView addSubview:balanceLabel];
    
    self.balancePrice = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 140, CGRectGetMaxY(lineDot2View.frame) + 14, 120, 20)];
    [self.balancePrice setFont:[UIFont phBlond:13]];
    [self.balancePrice setTextColor:[UIColor phPurpleColor]];
    [self.balancePrice setBackgroundColor:[UIColor clearColor]];
    [self.balancePrice setTextAlignment:NSTextAlignmentRight];
    NSInteger balance = [[self.productList objectForKey:@"total_price_all"] integerValue] - [[self.productList objectForKey:@"min_deposit_amount"] integerValue];
    NSString *balanceText = [sharedData formatCurrencyString:[NSString stringWithFormat:@"%li", balance]];
    [self.balancePrice setText:[NSString stringWithFormat:@"Rp%@",balanceText]];
    [self.scrollView addSubview:self.balancePrice];
    
    self.maxPrice = [[self.productList objectForKey:@"total_price_all"] integerValue];
    self.minPrice = [[self.productList objectForKey:@"min_deposit_amount"] integerValue];
    self.currentPrice = self.minPrice;
    
    self.scrollView.contentSize = CGSizeMake(self.visibleSize.width, CGRectGetMaxY(self.balancePrice.frame) + 16);
    
    
    UIView *line2View = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 54 - 100 - 110, self.visibleSize.width, 1)];
    [line2View setBackgroundColor:[UIColor phLightGrayColor]];
    [self.view addSubview:line2View];
    
    UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, CGRectGetMaxY(line2View.frame) + 8, 100, 20)];
    [totalLabel setText:@"PAY DEPOSIT"];
    [totalLabel setFont:[UIFont phBlond:13]];
    [totalLabel setTextColor:[UIColor blackColor]];
    [totalLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:totalLabel];
    
    UIImageView *priceBox = [[UIImageView alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(line2View.frame) + 12 + 20 , self.visibleSize.width - 16, 70)];
    [priceBox setImage:[[UIImage imageNamed:@"bg_rectangle"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    [priceBox setUserInteractionEnabled:YES];
    [self.view addSubview:priceBox];
    
    UIButton *plusButton = [[UIButton alloc] initWithFrame:CGRectMake(priceBox.frame.size.width - 24 - 34, 18, 34, 34)];
    [plusButton setImage:[UIImage imageNamed:@"icon_plus"] forState:UIControlStateNormal];
    [plusButton addTarget:self action:@selector(plusButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [priceBox addSubview:plusButton];
    
    self.totalPrice = [[UILabel alloc] initWithFrame:CGRectMake((priceBox.frame.size.width - 120) /2, 25, 120, 20)];
    NSString *total_price = [sharedData formatCurrencyString:[self.productList objectForKey:@"min_deposit_amount"]];
    [self.totalPrice setText:[NSString stringWithFormat:@"Rp%@",total_price]];
    [self.totalPrice setTextAlignment:NSTextAlignmentCenter];
    [self.totalPrice setFont:[UIFont phBlond:20]];
    [self.totalPrice setTextColor:[UIColor blackColor]];
    [self.totalPrice setBackgroundColor:[UIColor clearColor]];
    [priceBox addSubview:self.totalPrice];
    
    UIButton *minusButton = [[UIButton alloc] initWithFrame:CGRectMake(24, 18, 34, 34)];
    [minusButton setImage:[UIImage imageNamed:@"icon_minus"] forState:UIControlStateNormal];
    [minusButton addTarget:self action:@selector(minusButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [priceBox addSubview:minusButton];
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

- (void)prePopulatePayment {
    NSDictionary *lastPayment = [self.productSummary objectForKey:@"last_payment"];
    if (lastPayment && lastPayment != nil) {
        NSString *payment_type = [lastPayment objectForKey:@"payment_type"];
        if ([payment_type isEqualToString:@"bca"]) {
            self.paymentDetail = @{@"type":@"bca",
                                   @"is_new_card":@"0",
                                   @"token_id":@""};
        } else if ([payment_type isEqualToString:@"bp"]) {
            self.paymentDetail = @{@"type":@"bp",
                                   @"is_new_card":@"0",
                                   @"token_id":@""};
        } else if ([payment_type isEqualToString:@"va"]) {
            self.paymentDetail = @{@"type":@"va",
                                   @"is_new_card":@"0",
                                   @"token_id":@""};
        } else if ([payment_type isEqualToString:@"cc"]) {
            self.paymentDetail = @{@"type":@"cc",
                                   @"is_new_card":@"0",
                                   @"token_id":[lastPayment objectForKey:@"saved_token_id"],
                                   @"masked_card":[lastPayment objectForKey:@"masked_card"]};
        }
    }
}

- (void)checkValidToContinue {

    if ((self.paymentDetail && self.paymentDetail != nil)) {
        [self.swipeScrollView setScrollEnabled:YES];
        [self.swipeScrollView setBackgroundColor:[UIColor phBlueColor]];
        
    } else if([[self.productList objectForKey:@"total_price_all"] integerValue] == 0) {
        // check if free event
        [self.swipeScrollView setScrollEnabled:YES];
        [self.swipeScrollView setBackgroundColor:[UIColor phBlueColor]];
        
    } else if([[self.productList objectForKey:@"ticket_type"] isEqualToString:@"booking"] && self.currentPrice == 0) {
        // check if no min booking payment required
        [self.swipeScrollView setScrollEnabled:YES];
        [self.swipeScrollView setBackgroundColor:[UIColor phBlueColor]];
        
    } else {
        [self.swipeScrollView setScrollEnabled:NO];
        [self.swipeScrollView setBackgroundColor:[UIColor colorFromHexCode:@"B6ECFF"]];
    }
}

- (void)populatePaymentData {
    if (self.paymentDetail && self.paymentDetail != nil) {
        if ([[self.paymentDetail objectForKey:@"type"] isEqualToString:@"cc"]) {
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
            
        } else if ([[self.paymentDetail objectForKey:@"type"] isEqualToString:@"bca"]) {
            [self.paymentLogoView setImage:[UIImage imageNamed:@"logo_bca"]];
            
            [self.paymentTitleView setText:@"BCA Virtual Account"];
            [self.paymentTitleView setTextColor:[UIColor blackColor]];
            
        } else if ([[self.paymentDetail objectForKey:@"type"] isEqualToString:@"bp"]) {
            [self.paymentLogoView setImage:[UIImage imageNamed:@"logo_mandiri"]];
            
            [self.paymentTitleView setText:@"Mandiri Virtual Account"];
            [self.paymentTitleView setTextColor:[UIColor blackColor]];
            
        } else if ([[self.paymentDetail objectForKey:@"type"] isEqualToString:@"va"]) {
            [self.paymentLogoView setImage:nil];
            
            [self.paymentTitleView setText:@"Other Banks"];
            [self.paymentTitleView setTextColor:[UIColor blackColor]];
        }
        
        [self.paymentTitleView setFrame:CGRectMake(80, 20, self.visibleSize.width - 80 - 24, 30)];
        [self.paymentBox setImage:[[UIImage imageNamed:@"bg_rectangle"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
        
    } else {
        [self.paymentLogoView setImage:nil];
        
        [self.paymentTitleView setText:@"CHOOSE PAYMENT METHOD"];
        [self.paymentTitleView setTextColor:[UIColor phBlueColor]];
        [self.paymentTitleView setFrame:CGRectMake(24, 20, self.visibleSize.width - 80 - 24, 30)];
        
        [self.paymentBox setImage:[[UIImage imageNamed:@"bg_rectangle_red"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    }

    [self checkValidToContinue];
}

#pragma mark - Action
- (void)closeButtonDidTap:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)helpButtonDidTap:(id)sender {
    if ([MFMessageComposeViewController canSendText]) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *support = [prefs objectForKey:@"support"];
        if (support && support != nil) {
            NSString *telp = [support objectForKey:@"telp"];
            if (telp && telp != nil) {
                MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
                NSArray *myReceivers = [[NSArray alloc] initWithObjects:telp, nil];
                [picker setRecipients:myReceivers];
                picker.delegate = self;
                picker.messageComposeDelegate = self;
                picker.navigationBar.barStyle = UIBarStyleDefault;
                [self presentViewController:picker animated:YES completion:^{}];
            }
        }
    }
}

- (void)paymentAddButtonDidTap:(id)sender {
    [self.paymentAddButton setBackgroundColor:[UIColor lightGrayColor]];
    [UIView animateWithDuration:0.15 animations:^()
     {
         [self.paymentAddButton setBackgroundColor:[UIColor clearColor]];
     } completion:^(BOOL finished){
//         self.paymentDetail = nil;
         
         PaymentSelectionViewController *paymentSelectionViewController = [[PaymentSelectionViewController alloc] init];
         paymentSelectionViewController.productList = self.productList;
         [self.navigationController pushViewController:paymentSelectionViewController animated:YES];
     }];
}

- (void)plusButtonDidTap:(id)sender {
    
    if (self.currentPrice < self.maxPrice) {
        self.currentPrice += 500000;
        if (self.currentPrice > self.maxPrice) {
            self.currentPrice = self.maxPrice;
        }
        
        SharedData *sharedData = [SharedData sharedInstance];
        NSString *totalPrice = [NSString stringWithFormat:@"%li", self.currentPrice];
        NSString *formattedPrice = [sharedData formatCurrencyString:totalPrice];
        
        NSInteger balance = self.maxPrice - self.currentPrice;
        NSString *balanceText = [sharedData formatCurrencyString:[NSString stringWithFormat:@"%li", balance]];
        
        self.requiredPrice.text = [NSString stringWithFormat:@"Rp%@", formattedPrice];
        self.balancePrice.text = [NSString stringWithFormat:@"Rp%@", balanceText];
        self.totalPrice.text = [NSString stringWithFormat:@"Rp%@", formattedPrice];
        
        [self checkValidToContinue];
        
        if (!self.isPaymentMethodShow) {
            [self showPaymentMethod:YES withAnimation:YES];
        }
    }
}

- (void)minusButtonDidTap:(id)sender {
    
    if (self.currentPrice > self.minPrice) {
        self.currentPrice -= 500000;
        if (self.currentPrice < self.minPrice) {
            self.currentPrice = self.minPrice;
        }
        
        SharedData *sharedData = [SharedData sharedInstance];
        NSString *totalPrice = [NSString stringWithFormat:@"%li", self.currentPrice];
        NSString *formattedPrice = [sharedData formatCurrencyString:totalPrice];
        
        NSInteger balance = self.maxPrice - self.currentPrice;
        NSString *balanceText = [sharedData formatCurrencyString:[NSString stringWithFormat:@"%li", balance]];
        
        self.requiredPrice.text = [NSString stringWithFormat:@"Rp%@", formattedPrice];
        self.balancePrice.text = [NSString stringWithFormat:@"Rp%@", balanceText];
        self.totalPrice.text = [NSString stringWithFormat:@"Rp%@", formattedPrice];
        
        [self checkValidToContinue];
        
        if (self.currentPrice == 0 && self.isPaymentMethodShow) {
            [self showPaymentMethod:NO withAnimation:YES];
        }
    }
}

- (void)showPaymentMethod:(BOOL)isShow withAnimation:(BOOL)isAnimated {
    self.isPaymentMethodShow = isShow;
    
    CGFloat animateDuration = 0.0;
    if (isAnimated) {
        animateDuration = 0.25;
    }
    
    if (isShow) {
        [UIView animateWithDuration:animateDuration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.selectPaymentLabel setAlpha:1.0];
            [self.paymentBox setAlpha:1.0];
            
            [self.continueButton setTitle:@"SWIPE TO PAY" forState:UIControlStateNormal];
            [self.iconArrow1 setFrame:CGRectMake(self.visibleSize.width/2 + 50, self.iconArrow1.frame.origin.y, self.iconArrow1.bounds.size.width, self.iconArrow1.bounds.size.height)];
            [self.iconArrow2 setFrame:CGRectMake(self.visibleSize.width/2 + 56, self.iconArrow2.frame.origin.y, self.iconArrow2.bounds.size.width, self.iconArrow2.bounds.size.height)];
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [UIView animateWithDuration:animateDuration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.selectPaymentLabel setAlpha:0.0];
            [self.paymentBox setAlpha:0.0];
            
            [self.continueButton setTitle:@"SWIPE TO BOOK" forState:UIControlStateNormal];
            [self.iconArrow1 setFrame:CGRectMake(self.visibleSize.width/2 + 56, self.iconArrow1.frame.origin.y, self.iconArrow1.bounds.size.width, self.iconArrow1.bounds.size.height)];
            [self.iconArrow2 setFrame:CGRectMake(self.visibleSize.width/2 + 62, self.iconArrow2.frame.origin.y, self.iconArrow2.bounds.size.width, self.iconArrow2.bounds.size.height)];
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark - Data
- (void)readyForPayment {
    
    if ([[self.productList objectForKey:@"total_price_all"] integerValue] == 0) {
        // Check if free event
        [self postPaymentFree];
        
    } else if([[self.productList objectForKey:@"ticket_type"] isEqualToString:@"booking"] && self.currentPrice == 0) {
        // check if no min booking payment required
        [self postPaymentFree];
        
    } else {
        if ([[self.paymentDetail objectForKey:@"is_new_card"] isEqualToString:@"1"]) {
            NSDictionary *content = [self.paymentDetail objectForKey:@"content"];
            
            VTDirect *vtDirect = [[VTDirect alloc] init];
            
            VTCardDetails *cardDetails = [[VTCardDetails alloc] init];
            cardDetails.card_number = [content objectForKey:@"card_number"];
            cardDetails.card_cvv =[content objectForKey:@"card_cvv"];
            cardDetails.card_exp_month =[content objectForKey:@"card_exp_month"];
            cardDetails.card_exp_year = [[content objectForKey:@"card_exp_year"] integerValue];
            if ([[self.productList objectForKey:@"ticket_type"] isEqualToString:@"booking"]) {
                cardDetails.gross_amount = [NSString stringWithFormat:@"%li", self.currentPrice];
            } else {
                cardDetails.gross_amount = [self.productSummary objectForKey:@"total_price"];
            }
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
                            
                            UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 60, self.visibleSize.width, self.view.bounds.size.height - 60)];
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
}

- (void)postPayment {
    SharedData *sharedData = [SharedData sharedInstance];
    AFHTTPRequestOperationManager *manager = [sharedData getOperationManager];
    NSString *url = [NSString stringWithFormat:@"%@/product/payment",PHBaseNewURL];

    NSString *payDeposit = @"";
    if ([[self.productList objectForKey:@"ticket_type"] isEqualToString:@"booking"]) {
        payDeposit = [NSString stringWithFormat:@"%li", self.currentPrice];
    }
    
    NSDictionary *params = @{@"type":[self.paymentDetail objectForKey:@"type"],
                             @"is_new_card":[self.paymentDetail objectForKey:@"is_new_card"],
                             @"order_id":[self.productSummary objectForKey:@"order_id"],
                             @"token_id":[self.paymentDetail objectForKey:@"token_id"],
                             @"name_cc":@"",
                             @"pay_deposit":payDeposit};
    
    if ([[self.paymentDetail objectForKey:@"is_new_card"] isEqualToString:@"1"]) {
        params = @{@"type":[self.paymentDetail objectForKey:@"type"],
                   @"is_new_card":[self.paymentDetail objectForKey:@"is_new_card"],
                   @"order_id":[self.productSummary objectForKey:@"order_id"],
                   @"token_id":[self.paymentNew objectForKey:@"token_id"],
                   @"name_cc":[self.paymentNew objectForKey:@"name_cc"],
                   @"pay_deposit":payDeposit};
    }

    [SVProgressHUD show];
    
    // disable all button
    [self.swipeScrollView setScrollEnabled:NO];
    [self.closeButton setEnabled:NO];
    [self.paymentAddButton setEnabled:NO];
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        
        // enable all button
        [self.swipeScrollView setScrollEnabled:YES];
        [self.closeButton setEnabled:YES];
        [self.paymentAddButton setEnabled:YES];
        
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
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payment Failed"
                                                                message:message
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            else {
                UIAlertController *alertController = [UIAlertController
                                                      alertControllerWithTitle:@"Payment Failed"
                                                      message:message
                                                      preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction
                                               actionWithTitle:@"OK"
                                               style:UIAlertActionStyleCancel
                                               handler:^(UIAlertAction *action)
                                               {
                                                   if ([self.errorType isEqualToString:@"ticket_list"]) {
                                                       [[self navigationController] popToRootViewControllerAnimated:YES];
                                                       
                                                   } else if ([self.errorType isEqualToString:@"ticket_details"]) {
                                                       [[self navigationController] popViewControllerAnimated:YES];
                                                       
                                                   } else if ([self.errorType isEqualToString:@"paid"]) {
                                                       if ([[self.paymentDetail objectForKey:@"type"] isEqualToString:@"cc"]) {
                                                           [self openSuccessScreen];
                                                       } else {
                                                           [self openVirtualAccountScreen];
                                                       }
                                                   }
                                               }];
                
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            
            return;
        }
        
        // Remove cache
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs removeObjectForKey:@"temp_da_list"];
        [prefs synchronize];
        
        if ([[self.paymentDetail objectForKey:@"type"] isEqualToString:@"cc"]) {
            [self openSuccessScreen];
        } else {
            [self openVirtualAccountScreen];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.response.statusCode == 410) {
            [self reloadLoginWithFBToken:@"payment"];
        } else {
            // enable all button
            [self.swipeScrollView setScrollEnabled:YES];
            [self.closeButton setEnabled:YES];
            [self.paymentAddButton setEnabled:YES];
            
            [SVProgressHUD dismiss];
        }
    }];
}

- (void)postPaymentFree {
    SharedData *sharedData = [SharedData sharedInstance];
    AFHTTPRequestOperationManager *manager = [sharedData getOperationManager];
    NSString *url = [NSString stringWithFormat:@"%@/product/free_payment",PHBaseNewURL];
    
    NSDictionary *params = @{@"order_id":[self.productSummary objectForKey:@"order_id"],
                             @"pay_deposit":@"0"};
    
    [SVProgressHUD show];
    
    // disable all button
    [self.swipeScrollView setScrollEnabled:NO];
    [self.closeButton setEnabled:NO];
    [self.paymentAddButton setEnabled:NO];
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        
        // enable all button
        [self.swipeScrollView setScrollEnabled:YES];
        [self.closeButton setEnabled:YES];
        [self.paymentAddButton setEnabled:YES];
        
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
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payment Failed"
                                                                message:message
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            else {
                UIAlertController *alertController = [UIAlertController
                                                      alertControllerWithTitle:@"Payment Failed"
                                                      message:message
                                                      preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction
                                               actionWithTitle:@"OK"
                                               style:UIAlertActionStyleCancel
                                               handler:^(UIAlertAction *action)
                                               {
                                                   if ([self.errorType isEqualToString:@"ticket_list"]) {
                                                       [[self navigationController] popToRootViewControllerAnimated:YES];
                                                       
                                                   } else if ([self.errorType isEqualToString:@"ticket_details"]) {
                                                       [[self navigationController] popViewControllerAnimated:YES];
                                                       
                                                   } else if ([self.errorType isEqualToString:@"paid"]) {
                                                       [self openSuccessScreen];
                                                   }
                                               }];
                
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            
            return;
        }
        
        // Remove cache
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs removeObjectForKey:@"temp_da_list"];
        [prefs synchronize];
        
        [self openSuccessScreen];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.response.statusCode == 410) {
            [self reloadLoginWithFBToken:@"free_payment"];
        } else {
            // enable all button
            [self.swipeScrollView setScrollEnabled:YES];
            [self.closeButton setEnabled:YES];
            [self.paymentAddButton setEnabled:YES];
            
            [SVProgressHUD dismiss];
        }
    }];
}

- (void)reloadLoginWithFBToken:(NSString *)loadType {
    SharedData *sharedData = [SharedData sharedInstance];
    
    [sharedData loginWithFBToken:^(AFHTTPRequestOperation *operation, id responseObject) {
        sharedData.ph_token = responseObject[@"data"][@"token"];
        if ([loadType isEqualToString:@"payment"]) {
            [self postPayment];
        } else if ([loadType isEqualToString:@"free_payment"]) {
            [self postPaymentFree];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self reloadLoginWithFBToken:loadType];
    }];
}

#pragma mark - Navigation 
- (void)openSuccessScreen {
    TicketSuccessViewController *ticketSuccessViewController = [[TicketSuccessViewController alloc] init];
    [ticketSuccessViewController setShowCloseButton:YES];
    [ticketSuccessViewController setShowViewButton:YES];
    [ticketSuccessViewController setIsModalScreen:YES];
    [ticketSuccessViewController setOrderID:[self.productSummary objectForKey:@"order_id"]];
    [ticketSuccessViewController setTicketType:[self.productList objectForKey:@"ticket_type"]];
    [[self navigationController] pushViewController:ticketSuccessViewController animated:YES];
}

- (void)openVirtualAccountScreen {
    VirtualAccountViewController *virtualAccountViewController = [[VirtualAccountViewController alloc] init];
    [virtualAccountViewController setShowCloseButton:NO];
    [virtualAccountViewController setShowOrderButton:YES];
    [virtualAccountViewController setOrderID:[self.productSummary objectForKey:@"order_id"]];
    [virtualAccountViewController setVAType:[self.paymentDetail objectForKey:@"type"]];
    [[self navigationController] pushViewController:virtualAccountViewController animated:YES];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([self.errorType isEqualToString:@"ticket_list"]) {
        [[self navigationController] popToRootViewControllerAnimated:YES];
        
    } else if ([self.errorType isEqualToString:@"ticket_details"]) {
        [[self navigationController] popViewControllerAnimated:YES];
        
    } else if ([self.errorType isEqualToString:@"paid"]) {
        if ([[self.paymentDetail objectForKey:@"type"] isEqualToString:@"cc"]) {
            [self openSuccessScreen];
        } else {
            [self openVirtualAccountScreen];
        }
    }
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if ([webView.request.URL.absoluteString rangeOfString:@"callback"].location != NSNotFound) {
        [self postPayment];
        
        [webView performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
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

#pragma mark - UIScrollViewDelegate 
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.swipeScrollView]) {
        if (scrollView.contentOffset.x < self.visibleSize.width/2) {
            [UIView animateWithDuration:0.25 animations:^{
                [scrollView setContentOffset:CGPointMake(self.visibleSize.width, 0)];
            }];
            
            [self readyForPayment];
        }
    }
}

@end