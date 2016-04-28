//
//  TicketConfirmationViewController.h
//  Jiggie
//
//  Created by Setiady Wiguna on 3/9/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "BaseViewController.h"
#import <MessageUI/MessageUI.h>

@interface TicketConfirmationViewController : BaseViewController <UIWebViewDelegate, MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *totalPrice;
@property (nonatomic, strong) UILabel *requiredPrice;
@property (nonatomic, strong) UILabel *balancePrice;
@property (nonatomic, strong) UIImageView *paymentLogoView;
@property (nonatomic, strong) UILabel *paymentTitleView;
@property (nonatomic, strong) UILabel *selectPaymentLabel;
@property (nonatomic, strong) UIImageView *paymentBox;
@property (nonatomic, strong) UIButton *paymentAddButton;
@property (nonatomic, strong) UIButton *continueButton;
@property (nonatomic, strong) UIImageView *iconArrow1;
@property (nonatomic, strong) UIImageView *iconArrow2;
@property (nonatomic, strong) UIScrollView *swipeScrollView;

@property (nonatomic, strong) NSMutableArray *agreeButtonArray;
@property (nonatomic, strong) NSDictionary *productSummary;
@property (nonatomic, strong) NSDictionary *productList;
@property (nonatomic, strong) NSDictionary *paymentDetail;
@property (nonatomic, strong) NSDictionary *paymentNew;
@property (nonatomic, strong) NSString *eventTitleString;
@property (nonatomic, strong) NSString *eventVenueString;
@property (nonatomic, strong) NSString *eventDateString;
@property (nonatomic, strong) NSString *ticketType;
@property (nonatomic, assign) NSInteger maxPrice;
@property (nonatomic, assign) NSInteger minPrice;
@property (nonatomic, assign) NSInteger currentPrice;
@property (nonatomic, strong) NSString *errorType;
@property (nonatomic, assign) BOOL isPaymentMethodShow;

@end
