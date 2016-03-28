//
//  TicketSummaryViewController.h
//  Jiggie
//
//  Created by Setiady Wiguna on 2/11/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "BaseViewController.h"
#import <MessageUI/MessageUI.h>

@interface TicketSummaryViewController : BaseViewController <MFMailComposeViewControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *summaryHeaderTitle;
@property (nonatomic, strong) UILabel *summaryHeaderDescription;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *userEmail;
@property (nonatomic, strong) UILabel *userPhone;
@property (nonatomic, strong) UIButton *userDetailButton;
@property (nonatomic, strong) UILabel *totalPrice;
@property (nonatomic, strong) UILabel *totalTicket;
@property (nonatomic, strong) UIButton *continueButton;

@property (nonatomic, strong) NSDictionary *productList;
@property (nonatomic, strong) NSDictionary *productSelected;
@property (nonatomic, assign) BOOL isTicketProduct;
@property (nonatomic, assign) NSInteger maxAmount;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) BOOL isAllowToContinue;

@end
