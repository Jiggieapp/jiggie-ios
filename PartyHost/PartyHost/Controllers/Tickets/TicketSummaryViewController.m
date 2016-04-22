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
    
//    [self setupUserInfo];
    
    self.navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.visibleSize.width, 60)];
    [self.navBar setBackgroundColor:[UIColor phPurpleColor]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, self.visibleSize.width - 80, 40)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont phBlond:16]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.navBar addSubview:titleLabel];
    
    NSString *name = [self.productSelected objectForKey:@"name"];
    if (name && name != nil) {
        [titleLabel setText:name];
    }
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(0.0f, 20.0f, 40.0f, 40.0f)];
    [closeButton setImageEdgeInsets:UIEdgeInsetsMake(8, 14, 8, 14)];
    [closeButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:closeButton];
    
    UIButton *helpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [helpButton setFrame:CGRectMake(self.visibleSize.width - 60, 20.0f, 50.0f, 40.0f)];
    [helpButton setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 0)];
    [helpButton setImage:[UIImage imageNamed:@"button_help"] forState:UIControlStateNormal];
    [helpButton addTarget:self action:@selector(helpButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:helpButton];
    
    [self.view addSubview:self.navBar];
    
    [self.view setBackgroundColor:[UIColor colorFromHexCode:@"F1F1F1"]];
    
    
    // SCROLL VIEW
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, self.visibleSize.width, self.view.bounds.size.height - 60 - 54 - 140 - 140)];
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
    
    UILabel *ticketInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, 120, 20)];
    [ticketInfoLabel setText:@"TICKET INFO"];
    [ticketInfoLabel setFont:[UIFont phBlond:12]];
    [ticketInfoLabel setTextColor:[UIColor blackColor]];
    [ticketInfoLabel setBackgroundColor:[UIColor clearColor]];
    [self.scrollView addSubview:ticketInfoLabel];
    
    UITextView *ticketDescription = [[UITextView alloc] initWithFrame:CGRectMake(14, 16 + 20 + 8, self.visibleSize.width - 28, 0)];
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
    
    UIView *line2View = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 54 - 140 - 140, self.visibleSize.width, 1)];
    [line2View setBackgroundColor:[UIColor phLightGrayColor]];
    [self.view addSubview:line2View];
    
    UILabel *contactInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, line2View.frame.origin.y + 16, 120, 20)];
    [contactInfoLabel setText:@"CONTACT INFO"];
    [contactInfoLabel setFont:[UIFont phBlond:13]];
    [contactInfoLabel setTextColor:[UIColor blackColor]];
    [contactInfoLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:contactInfoLabel];
    
    self.userBox = [[UIImageView alloc] initWithFrame:CGRectMake(8, line2View.frame.origin.y + 28 + 16, self.visibleSize.width - 16, 90)];
    [self.userBox setImage:[[UIImage imageNamed:@"bg_rectangle"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    [self.view addSubview:self.userBox];
    
    self.userName = [[UILabel alloc] initWithFrame:CGRectMake(12, 14, self.visibleSize.width - 70, 18)];
    [self.userName setFont:[UIFont phBlond:13]];
    [self.userName setTextColor:[UIColor blackColor]];
    [self.userName setBackgroundColor:[UIColor clearColor]];
    [self.userBox addSubview:self.userName];
    
    self.userEmail = [[UILabel alloc] initWithFrame:CGRectMake(12, 14 + 20, self.visibleSize.width - 70, 18)];
    [self.userEmail setFont:[UIFont phBlond:13]];
    [self.userEmail setTextColor:[UIColor blackColor]];
    [self.userEmail setBackgroundColor:[UIColor clearColor]];
    [self.userBox addSubview:self.userEmail];
    
    self.userPhone = [[UILabel alloc] initWithFrame:CGRectMake(12, 14 + 40, self.visibleSize.width - 70, 18)];
    [self.userPhone setFont:[UIFont phBlond:13]];
    [self.userPhone setTextColor:[UIColor blackColor]];
    [self.userPhone setBackgroundColor:[UIColor clearColor]];
    [self.userBox addSubview:self.userPhone];
    
    self.userCaption = [[UILabel alloc] initWithFrame:CGRectMake(12, 14 + 20, self.visibleSize.width - 70, 18)];
    [self.userCaption setFont:[UIFont phBlond:13]];
    [self.userCaption setTextColor:[UIColor phBlueColor]];
    [self.userCaption setBackgroundColor:[UIColor clearColor]];
    [self.userCaption setHidden:YES];
    [self.userCaption setText:@"FILL IN YOUR CONTACT INFO"];
    [self.userBox addSubview:self.userCaption];
    
    UIImageView *accessory = [[UIImageView alloc] initWithFrame:CGRectMake(self.userBox.bounds.size.width - 28, 14 + 20, 16, 24)];
    [accessory setImage:[UIImage imageNamed:@"icon_blue_arrow"]];
    [self.userBox addSubview:accessory];
    
    self.userDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.userDetailButton setFrame:self.userBox.frame];
    [self.userDetailButton addTarget:self action:@selector(userDetailButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.userDetailButton setBackgroundColor:[UIColor clearColor]];
    [self.userDetailButton setHighlighted:YES];
    [self.view addSubview:self.userDetailButton];
    
    // LINE 3 VIEW
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 54 - 140, self.visibleSize.width, 160)];
    [bottomView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bottomView];
    
    UILabel *ticketLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 25, 120, 20)];
    [ticketLabel setText:@"TICKETS"];
    [ticketLabel setFont:[UIFont phBlond:12]];
    [ticketLabel setTextColor:[UIColor darkGrayColor]];
    [ticketLabel setBackgroundColor:[UIColor clearColor]];
    [bottomView addSubview:ticketLabel];
    
    if (self.isTicketProduct) {
        [ticketLabel setText:@"TICKETS"];
    } else {
        [ticketLabel setText:@"NUMBER OF GUEST"];
    }
    
    UIButton *plusButton = [[UIButton alloc] initWithFrame:CGRectMake(self.visibleSize.width - 34 - 16, 19, 34, 34)];
    [plusButton setImage:[UIImage imageNamed:@"icon_plus"] forState:UIControlStateNormal];
    [plusButton addTarget:self action:@selector(plusButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [plusButton setImageEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    [bottomView addSubview:plusButton];
    
    self.totalTicket = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 34 - 60, 23, 40, 24)];
    [self.totalTicket setFont:[UIFont phBlond:18]];
    [self.totalTicket setTextColor:[UIColor blackColor]];
    [self.totalTicket setBackgroundColor:[UIColor clearColor]];
    [self.totalTicket setTextAlignment:NSTextAlignmentCenter];
    [bottomView addSubview:self.totalTicket];
    
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
    
    UIButton *minusButton = [[UIButton alloc] initWithFrame:CGRectMake(self.visibleSize.width - 34 - 60 - 40, 19, 34, 34)];
    [minusButton setImage:[UIImage imageNamed:@"icon_minus"] forState:UIControlStateNormal];
    [minusButton addTarget:self action:@selector(minusButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [minusButton setImageEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    [bottomView addSubview:minusButton];
    
    UIView *line3View = [[UIView alloc] initWithFrame:CGRectMake(16, 70, self.visibleSize.width - 32, 1)];
    [line3View setBackgroundColor:[UIColor phLightGrayColor]];
    [bottomView addSubview:line3View];
    
    UILabel *estimatedLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, line3View.frame.origin.y + 25, 120, 20)];
    [estimatedLabel setFont:[UIFont phBlond:12]];
    [estimatedLabel setTextColor:[UIColor darkGrayColor]];
    [estimatedLabel setBackgroundColor:[UIColor clearColor]];
    [bottomView addSubview:estimatedLabel];
    
    if (self.isTicketProduct) {
        [estimatedLabel setText:@"ESTIMATED COST"];
    } else {
        [estimatedLabel setText:@"MINIMUM SPEND"];
    }
    
    self.totalPrice = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width - 8 - 16 - 160, line3View.frame.origin.y + 23, 160, 24)];
    [self.totalPrice setFont:[UIFont phBlond:20]];
    [self.totalPrice setTextColor:[UIColor phPurpleColor]];
    [self.totalPrice setBackgroundColor:[UIColor clearColor]];
    [self.totalPrice setTextAlignment:NSTextAlignmentRight];
    [bottomView addSubview:self.totalPrice];
    
    NSString *price = [self.productSelected objectForKey:@"price"];
    if (price && price != nil) {
        self.price = price.integerValue;
        
        if (self.price == 0) {
            [self.totalPrice setText:@"FREE"];
        } else {
            SharedData *sharedData = [SharedData sharedInstance];
            NSString *formattedPrice = [sharedData formatCurrencyString:price];
            [self.totalPrice setText:[NSString stringWithFormat:@"Rp%@", formattedPrice]];
        }
    }
    
    NSString *status = [self.productSelected objectForKey:@"status"];
    NSNumber *quantity = [self.productSelected objectForKey:@"quantity"];
    if ([status isEqualToString:@"sold out"] || quantity.integerValue == 0) {
        UIView *soldOutView = [[UIView alloc] initWithFrame:bottomView.frame];
        [soldOutView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:soldOutView];
        
        UILabel *soldOutLabel = [[UILabel alloc] initWithFrame:bottomView.bounds];
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
    [self.continueButton setFrame:CGRectMake(0, self.view.bounds.size.height - 54, self.visibleSize.width, 54)];
    [self.continueButton setBackgroundColor:[UIColor colorFromHexCode:@"B6ECFF"]];
    [self.continueButton.titleLabel setFont:[UIFont phBold:15]];
    [self.continueButton setTitle:@"CONFIRM ORDER" forState:UIControlStateNormal];
    [self.continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.continueButton setEnabled:NO];
    [self.view addSubview:self.continueButton];
    
    // Load TCView
    [self loadTCView];
    
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

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self showTCView:NO withAnimation:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View
- (void)loadTCView {
    self.tcView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.tcView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.tcView];
    
    if (([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending)) {
        UIView *tcBGView = [[UIView alloc] initWithFrame:self.view.bounds];
        [tcBGView setBackgroundColor:[UIColor blackColor]];
        [tcBGView setAlpha:0.8];
        
        [self.tcView addSubview:tcBGView];
        
    } else {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = self.view.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.tcView insertSubview:blurEffectView atIndex:0];
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.visibleSize.width, 40)];
    [titleLabel setFont:[UIFont phBlond:15]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:@"Terms and Conditions"];
    [self.tcView addSubview:titleLabel];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setFrame:CGRectMake(self.visibleSize.width - 50, 20, 40, 40)];
    [cancelButton setImage:[UIImage imageNamed:@"nav_close_blue"] forState:UIControlStateNormal];
    [cancelButton setImageEdgeInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
    [cancelButton addTarget:self action:@selector(cancelButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.tcView addSubview:cancelButton];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, self.visibleSize.width, 1)];
    [lineView setBackgroundColor:[UIColor whiteColor]];
    [self.tcView addSubview:lineView];
    
    self.tcScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, self.visibleSize.width, self.view.bounds.size.height - 60 - 54)];
    self.tcScrollView.showsVerticalScrollIndicator    = NO;
    self.tcScrollView.showsHorizontalScrollIndicator  = NO;
    self.tcScrollView.scrollEnabled                   = YES;
    self.tcScrollView.userInteractionEnabled          = YES;
    self.tcScrollView.backgroundColor                 = [UIColor clearColor];
    self.tcScrollView.contentSize                     = CGSizeMake(self.visibleSize.width, 500);
    [self.tcView addSubview:self.tcScrollView];
    
    self.tcContinueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tcContinueButton addTarget:self action:@selector(tcContinueButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.tcContinueButton setFrame:CGRectMake(0, self.view.bounds.size.height - 54, self.visibleSize.width, 54)];
    [self.tcContinueButton setBackgroundColor:[UIColor colorFromHexCode:@"B6ECFF"]];
    [self.tcContinueButton.titleLabel setFont:[UIFont phBold:15]];
    [self.tcContinueButton setTitle:@"CONTINUE" forState:UIControlStateNormal];
    [self.tcContinueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.tcContinueButton setEnabled:NO];
    [self.tcView addSubview:self.tcContinueButton];
    
    // Hide TCView
    [self showTCView:NO withAnimation:NO];
}

- (void)populateTCView {
    NSArray *viewsToRemove = [self.tcScrollView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    
    if (self.productSummary && self.productSummary != nil) {
        NSArray *product_list = [self.productSummary objectForKey:@"product_list"];
        if (product_list && product_list != nil && product_list.count > 0) {
            NSDictionary *productList = [product_list objectAtIndex:0];
            
            UILabel *agreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 16, self.visibleSize.width - 36, 20)];
            [agreeLabel setText:@"By continuing with this order, I AGREE that :"];
            [agreeLabel setFont:[UIFont phBlond:14]];
            [agreeLabel setTextColor:[UIColor whiteColor]];
            [agreeLabel setBackgroundColor:[UIColor clearColor]];
            [self.tcScrollView addSubview:agreeLabel];
            
            CGFloat listY = 44;
            NSArray *terms = [productList objectForKey:@"terms"];
            NSInteger counter = 1;
            for (NSDictionary *term in terms) {
                UILabel *termLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, listY, self.visibleSize.width - 18 - 14, 40)];
                [termLabel setText:[NSString stringWithFormat:@"%li. %@", counter, [term objectForKey:@"body"]]];
                [termLabel setFont:[UIFont phBlond:12]];
                [termLabel setTextColor:[UIColor whiteColor]];
                [termLabel setAdjustsFontSizeToFitWidth:YES];
                [termLabel setBackgroundColor:[UIColor clearColor]];
                [termLabel setNumberOfLines:2];
                [self.tcScrollView addSubview:termLabel];
                
                listY += 48;
                counter++;
            }
            
            UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [checkButton setImage:[UIImage imageNamed:@"button_checked_on"] forState:UIControlStateSelected];
            [checkButton setImage:[UIImage imageNamed:@"button_checked_off"] forState:UIControlStateNormal];
            [checkButton setFrame:CGRectMake(18, listY + 5, 30, 30)];
            [checkButton addTarget:self action:@selector(checkButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
            [self.tcScrollView addSubview:checkButton];
            
            UILabel *yesAgreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, listY + 5, self.visibleSize.width - 36, 30)];
            [yesAgreeLabel setText:@"Yes, I agree"];
            [yesAgreeLabel setFont:[UIFont phBlond:12]];
            [yesAgreeLabel setTextColor:[UIColor whiteColor]];
            [yesAgreeLabel setBackgroundColor:[UIColor clearColor]];
            [self.tcScrollView addSubview:yesAgreeLabel];
            
            self.tcScrollView.contentSize = CGSizeMake(self.visibleSize.width, CGRectGetMaxY(yesAgreeLabel.frame) + 16);
        }
    }
}

- (void)showTCView:(BOOL)isShow withAnimation:(BOOL)isAnimated {
    CGFloat animateDuration = 0.0;
    if (isAnimated) {
        animateDuration = 0.25;
    }
    
    if (isShow) {
        [UIView animateWithDuration:animateDuration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.tcView setFrame:CGRectMake(0, 0, self.tcView.bounds.size.width, self.tcView.bounds.size.height)];
        } completion:^(BOOL finished) {
            [self.tcContinueButton setBackgroundColor:[UIColor colorFromHexCode:@"B6ECFF"]];
            [self.tcContinueButton setEnabled:NO];
        }];
    } else {
        
        [UIView animateWithDuration:animateDuration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.tcView setFrame:CGRectMake(0, self.tcView.bounds.size.height, self.tcView.bounds.size.width, self.tcView.bounds.size.height)];
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark - Action
- (void)closeButtonDidTap:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)cancelButtonDidTap:(id)sender {
    [self showTCView:NO withAnimation:YES];
}

- (void)checkButtonDidTap:(id)sender {
    UIButton *checkButton = (UIButton *)sender;
    
    if ([checkButton isSelected]) {
        [checkButton setSelected:NO];
        
        [self.tcContinueButton setEnabled:NO];
        [self.tcContinueButton setBackgroundColor:[UIColor colorFromHexCode:@"B6ECFF"]];
    } else {
        [checkButton setSelected:YES];
        
        [self.tcContinueButton setEnabled:YES];
        [self.tcContinueButton setBackgroundColor:[UIColor phBlueColor]];
    }
}

- (void)continueButtonDidTap:(id)sender {
    [self postTicketSummary];
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

- (void)plusButtonDidTap:(id)sender {
    NSInteger currentAmount = self.totalTicket.text.integerValue;
    
    if (currentAmount < self.maxAmount) {
        currentAmount++;
        self.totalTicket.text = [NSString stringWithFormat:@"%li", (long)currentAmount];
    }
    
    if (self.isTicketProduct) {
        if (self.price == 0) {
            [self.totalPrice setText:@"FREE"];
        } else {
            SharedData *sharedData = [SharedData sharedInstance];
            NSString *totalPrice = [NSString stringWithFormat:@"%li", currentAmount * self.price];
            NSString *formattedPrice = [sharedData formatCurrencyString:totalPrice];
            
            self.totalPrice.text = [NSString stringWithFormat:@"Rp%@", formattedPrice];
        }
    }
}

- (void)minusButtonDidTap:(id)sender {
    NSInteger currentAmount = self.totalTicket.text.integerValue;
    
    if (currentAmount > 1) {
        currentAmount--;
        self.totalTicket.text = [NSString stringWithFormat:@"%li", (long)currentAmount];
    }
    
    if (self.isTicketProduct) {
        if (self.price == 0) {
            [self.totalPrice setText:@"FREE"];
        } else {
            SharedData *sharedData = [SharedData sharedInstance];
            NSString *totalPrice = [NSString stringWithFormat:@"%li", currentAmount * self.price];
            NSString *formattedPrice = [sharedData formatCurrencyString:totalPrice];
            
            self.totalPrice.text = [NSString stringWithFormat:@"Rp%@", formattedPrice];
        }
    }
}

- (void)userDetailButtonDidTap:(id)sender {
    [self.userDetailButton setBackgroundColor:[UIColor lightGrayColor]];
    [UIView animateWithDuration:0.15 animations:^()
     {
         [self.userDetailButton setBackgroundColor:[UIColor clearColor]];
     } completion:^(BOOL finished){
         GuestDetailViewController *guestDetailViewController = [[GuestDetailViewController alloc] init];
         UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:guestDetailViewController];
         [self presentViewController:nav animated:YES completion:nil];
     }];
}

- (void)tcContinueButtonDidTap:(id)sender {
    if (self.productSummary && self.productSummary != nil) {
        NSArray *product_list = [self.productSummary objectForKey:@"product_list"];
        if (product_list && product_list != nil && product_list.count > 0) {
            TicketConfirmationViewController *ticketConfirmationViewController = [[TicketConfirmationViewController alloc] init];
            ticketConfirmationViewController.productSummary = self.productSummary;
            ticketConfirmationViewController.productList = [product_list objectAtIndex:0];
            
            NSString *event_name = [self.productList objectForKey:@"event_name"];
            if (event_name && event_name != nil) {
                ticketConfirmationViewController.eventTitleString = [event_name uppercaseString];
            }
            
            NSString *venue_name = [self.productList objectForKey:@"venue_name"];
            if (venue_name && venue_name != nil) {
                ticketConfirmationViewController.eventVenueString = venue_name;
            }
            
            NSString *start_datetime = [self.productList objectForKey:@"start_datetime"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:PHDateFormatServer];
            [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
            [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
            NSDate *startDatetime = [formatter dateFromString:start_datetime];
            
            [formatter setDateFormat:PHDateFormatApp];
            [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
            [formatter setTimeZone:[NSTimeZone localTimeZone]];
            NSString *shortDateTime = [formatter stringFromDate:startDatetime];
            
            ticketConfirmationViewController.eventDateString = shortDateTime;
    
            [self.navigationController pushViewController:ticketConfirmationViewController animated:YES];
        }
    }
}

#pragma mark - Data
- (void)populateUserData {
    
    self.isAllowToContinue = YES;
    NSDictionary *userInfo = [UserManager loadUserTicketInfo];
    NSInteger emptyCounter = 0;
    
    if (![[userInfo objectForKey:@"name"] isEqualToString:@""]) {
        self.userName.text = [userInfo objectForKey:@"name"];
        self.userName.textColor = [UIColor blackColor];
        
        [self.userBox setImage:[[UIImage imageNamed:@"bg_rectangle"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    } else {
        self.userName.text = @"name";
        self.userName.textColor = [UIColor redColor];
        self.isAllowToContinue = NO;
        
        [self.userBox setImage:[[UIImage imageNamed:@"bg_rectangle_red"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
        emptyCounter++;
    }
    
    if (![[userInfo objectForKey:@"email"] isEqualToString:@""]) {
        self.userEmail.text = [userInfo objectForKey:@"email"];
        self.userEmail.textColor = [UIColor blackColor];
        
        [self.userBox setImage:[[UIImage imageNamed:@"bg_rectangle"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    } else {
        self.userEmail.text = @"email";
        self.userEmail.textColor = [UIColor redColor];
        self.isAllowToContinue = NO;
        
        [self.userBox setImage:[[UIImage imageNamed:@"bg_rectangle_red"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
        emptyCounter++;
    }
    
    if (![[userInfo objectForKey:@"phone"] isEqualToString:@""]) {
        self.userPhone.text = [NSString stringWithFormat:@"+%@", [userInfo objectForKey:@"phone"]];
        self.userPhone.textColor = [UIColor blackColor];
        
        [self.userBox setImage:[[UIImage imageNamed:@"bg_rectangle"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    } else {
        self.userPhone.text = @"phone number";
        self.userPhone.textColor = [UIColor redColor];
        self.isAllowToContinue = NO;
        
        [self.userBox setImage:[[UIImage imageNamed:@"bg_rectangle_red"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
        emptyCounter++;
    }
    
    if (emptyCounter == 3) {
        // check if all data is empty
        [self.userName setHidden:YES];
        [self.userEmail setHidden:YES];
        [self.userPhone setHidden:YES];
        
        [self.userCaption setHidden:NO];
    } else {
        [self.userName setHidden:NO];
        [self.userEmail setHidden:NO];
        [self.userPhone setHidden:NO];
        
        [self.userCaption setHidden:YES];
    }
    
    if (self.isAllowToContinue && !self.isSoldOut) {
        [self.continueButton setEnabled:YES];
        [self.continueButton setBackgroundColor:[UIColor phBlueColor]];
    } else {
        [self.continueButton setEnabled:NO];
        [self.continueButton setBackgroundColor:[UIColor colorFromHexCode:@"B6ECFF"]];
    }
}

- (void)postTicketSummary {
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
                                               @"phone":[userInfo objectForKey:@"phone"],
                                               @"dial_code":[userInfo objectForKey:@"dial_code"]}};
    
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
                
            } else {
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
                        self.productSummary = product_summary;
                        
                        [self populateTCView];
                        [self showTCView:YES withAnimation:YES];
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
            [self reloadLoginWithFBToken];
        } else {
            [SVProgressHUD dismiss];
            [self.continueButton setEnabled:YES];
        }
    }];
}

- (void)reloadLoginWithFBToken {
    SharedData *sharedData = [SharedData sharedInstance];
    
    [sharedData loginWithFBToken:^(AFHTTPRequestOperation *operation, id responseObject) {
        sharedData.ph_token = responseObject[@"data"][@"token"];
        [self postTicketSummary];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self reloadLoginWithFBToken];
    }];
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
