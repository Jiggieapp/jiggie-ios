//
//  TicketConfirmationViewController.h
//  Jiggie
//
//  Created by Setiady Wiguna on 3/9/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "BaseViewController.h"

@interface TicketConfirmationViewController : BaseViewController

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *totalPrice;
@property (nonatomic, strong) UIImageView *paymentLogoView;
@property (nonatomic, strong) UILabel *paymentTitleView;
@property (nonatomic, strong) UIButton *paymentAddButton;

@property (nonatomic, strong) NSMutableArray *agreeButtonArray;
@property (nonatomic, strong) NSDictionary *productSummary;
@property (nonatomic, strong) NSDictionary *productList;
@property (nonatomic, strong) NSString *eventTitleString;
@property (nonatomic, strong) NSString *eventDescriptionString;

@end
