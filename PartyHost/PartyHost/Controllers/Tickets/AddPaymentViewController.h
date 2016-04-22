//
//  AddPaymentViewController.h
//  Jiggie
//
//  Created by Setiady Wiguna on 3/10/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "BaseViewController.h"

@interface AddPaymentViewController : BaseViewController <UITextFieldDelegate, UIWebViewDelegate>

@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *cardNumberTextField;
@property (nonatomic, strong) UITextField *dateTextField;
@property (nonatomic, strong) UITextField *cvvTextField;
@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic, strong) UIImageView *cardNumberAlert;
@property (nonatomic, strong) UIImageView *cvvAlert;

@property (nonatomic, strong) NSDictionary *productList;
@property (nonatomic, assign) BOOL disableKeyboardNotification;

@end