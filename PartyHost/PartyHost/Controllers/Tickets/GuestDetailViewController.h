//
//  GuestDetailViewController.h
//  Jiggie
//
//  Created by Setiady Wiguna on 3/4/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "BaseViewController.h"

@interface GuestDetailViewController : BaseViewController <UITextFieldDelegate>

@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *idNumberTextField;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UITextField *phoneCodeTextField;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic, strong) UIImageView *emailAlert;

@end
