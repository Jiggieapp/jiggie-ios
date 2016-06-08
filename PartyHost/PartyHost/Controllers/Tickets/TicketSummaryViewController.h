//
//  TicketSummaryViewController.h
//  Jiggie
//
//  Created by Setiady Wiguna on 2/11/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "BaseViewController.h"
#import <MessageUI/MessageUI.h>

@interface TicketSummaryViewController : BaseViewController <MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *userBox;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *userEmail;
@property (nonatomic, strong) UILabel *userPhone;
@property (nonatomic, strong) UILabel *userCaption;
@property (nonatomic, strong) UIButton *userDetailButton;
@property (nonatomic, strong) UILabel *totalPrice;
@property (nonatomic, strong) UILabel *totalTicket;
@property (nonatomic, strong) UIButton *continueButton;
@property (nonatomic, strong) UIView *tcView;
@property (nonatomic, strong) UIScrollView *tcScrollView;
@property (nonatomic, strong) UIButton *tcContinueButton;

@property (nonatomic, strong) NSDictionary *productList;
@property (nonatomic, strong) NSDictionary *productSelected;
@property (nonatomic, strong) NSDictionary *productSummary;
@property (nonatomic, assign) BOOL isTicketProduct;
@property (nonatomic, assign) NSInteger maxAmount;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) BOOL isAllowToContinue;
@property (nonatomic, assign) BOOL isSoldOut;
@property (nonatomic, assign) NSInteger bookTableExtraCharge;
@property (nonatomic, copy) NSString *saleType;
@property (nonatomic, copy) NSString *errorType;

@end
