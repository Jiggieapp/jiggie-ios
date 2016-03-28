//
//  GuestDetailViewController.m
//  Jiggie
//
//  Created by Setiady Wiguna on 3/4/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "GuestDetailViewController.h"
#import "UserManager.h"
#import "UserBubble.h"

@interface GuestDetailViewController ()

@end

@implementation GuestDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 28, 200, 24)];
    [titleLabel setText:@"GUEST DETAIL"];
    [titleLabel setTextColor:[UIColor phPurpleColor]];
    [titleLabel setFont:[UIFont phBlond:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:titleLabel];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setFrame:CGRectMake(self.visibleSize.width - 80, 28, 60, 26)];
    [cancelButton setTitle:@"CANCEL" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [[cancelButton titleLabel] setFont:[UIFont phBlond:12]];
    [cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:cancelButton];
    
    UIView *line1View = [[UIView alloc] initWithFrame:CGRectMake(0, 70, self.visibleSize.width, 1)];
    [line1View setBackgroundColor:[UIColor phLightGrayColor]];
    [self.view addSubview:line1View];
    
    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(line1View.frame) + 10, self.visibleSize.width - 32, 30)];
    [self.nameTextField setBackgroundColor:[UIColor clearColor]];
    [self.nameTextField setPlaceholder:@"Guest name"];
    [self.nameTextField setFont:[UIFont phBlond:13]];
    [self.nameTextField setReturnKeyType:UIReturnKeyNext];
    [self.nameTextField setDelegate:self];
    [self.view addSubview:self.nameTextField];
    
    UIView *line2View = [[UIView alloc] initWithFrame:CGRectMake(0, 70 + 50, self.visibleSize.width, 1)];
    [line2View setBackgroundColor:[UIColor phLightGrayColor]];
    [self.view addSubview:line2View];
    
    self.emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(line2View.frame) + 10, self.visibleSize.width - 32, 30)];
    [self.emailTextField setBackgroundColor:[UIColor clearColor]];
    [self.emailTextField setPlaceholder:@"Email"];
    [self.emailTextField setFont:[UIFont phBlond:13]];
    [self.emailTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    [self.emailTextField setReturnKeyType:UIReturnKeyNext];
    [self.emailTextField setDelegate:self];
    [self.view addSubview:self.emailTextField];
    
    self.emailAlert = [[UIImageView alloc] initWithFrame:CGRectMake(self.visibleSize.width - 36, CGRectGetMaxY(line2View.frame) + 14, 20, 20)];
    [self.emailAlert setImage:[UIImage imageNamed:@"icon_alert"]];
    [self.emailAlert setBackgroundColor:[UIColor clearColor]];
    [self.emailAlert setHidden:YES];
    [self.view addSubview:self.emailAlert];
    
    UIView *line3View = [[UIView alloc] initWithFrame:CGRectMake(0, 70 + 50 + 50, self.visibleSize.width, 1)];
    [line3View setBackgroundColor:[UIColor phLightGrayColor]];
    [self.view addSubview:line3View];
    
    self.phoneCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(line3View.frame) + 10, 40 , 30)];
    [self.phoneCodeTextField setBackgroundColor:[UIColor clearColor]];
    [self.phoneCodeTextField setFont:[UIFont phBlond:13]];
    [self.phoneCodeTextField setKeyboardType:UIKeyboardTypePhonePad];
    [self.phoneCodeTextField setReturnKeyType:UIReturnKeyDone];
    [self.phoneCodeTextField setDelegate:self];
    [self.phoneCodeTextField setEnabled:NO];
    [self.phoneCodeTextField setText:@"+62"];
    [self.view addSubview:self.phoneCodeTextField];
    
    UIView *lineVertical = [[UIView alloc] initWithFrame:CGRectMake(16 + 40, CGRectGetMaxY(line3View.frame) , 1, 50)];
    [lineVertical setBackgroundColor:[UIColor phLightGrayColor]];
    [self.view addSubview:lineVertical];
    
    self.phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(16 + 40 + 16, CGRectGetMaxY(line3View.frame) + 10, self.visibleSize.width - 32 - 40 - 16, 30)];
    [self.phoneTextField setBackgroundColor:[UIColor clearColor]];
    [self.phoneTextField setPlaceholder:@"Phone number"];
    [self.phoneTextField setFont:[UIFont phBlond:13]];
    [self.phoneTextField setKeyboardType:UIKeyboardTypePhonePad];
    [self.phoneTextField setReturnKeyType:UIReturnKeyDone];
    [self.phoneTextField setDelegate:self];
    [self.view addSubview:self.phoneTextField];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.visibleSize.width, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    self.phoneTextField.inputAccessoryView = numberToolbar;
    
    UIView *line4View = [[UIView alloc] initWithFrame:CGRectMake(0, 70 + 50 + 50 + 50, self.visibleSize.width, 1)];
    [line4View setBackgroundColor:[UIColor phLightGrayColor]];
    [self.view addSubview:line4View];
    
    UILabel *tncLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(line4View.frame) + 10, self.visibleSize.width - 30 - 16, 40)];
    [tncLabel setText:@"Please verify your information is correct so we can keep you updated on your order"];
    [tncLabel setNumberOfLines:2];
    [tncLabel setFont:[UIFont phBlond:13]];
    [tncLabel setTextColor:[UIColor lightGrayColor]];
    [tncLabel setBackgroundColor:[UIColor clearColor]];
    [tncLabel sizeToFit];
    [self.view addSubview:tncLabel];
    
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveButton addTarget:self action:@selector(saveButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton setFrame:CGRectMake(0, self.visibleSize.height - 44 + 20, self.visibleSize.width, 44)];
    [self.saveButton setBackgroundColor:[UIColor colorFromHexCode:@"B6ECFF"]];
    [self.saveButton.titleLabel setFont:[UIFont phBold:15]];
    [self.saveButton setTitle:@"SAVE" forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.saveButton setEnabled:NO];
    [self.view addSubview:self.saveButton];
 
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Validate 
- (void)checkButtonActivate {
    if (self.emailTextField.text.length > 0 && self.phoneTextField.text.length > 0 && self.nameTextField.text.length > 0) {
        [self.saveButton setEnabled:YES];
        [self.saveButton setBackgroundColor:[UIColor phBlueColor]];
    } else {
        [self.saveButton setEnabled:NO];
        [self.saveButton setBackgroundColor:[UIColor colorFromHexCode:@"B6ECFF"]];
    }
}

- (void)loadData {
    NSDictionary *userInfo = [UserManager loadUserTicketInfo];
    
    if (![[userInfo objectForKey:@"name"] isEqualToString:@""]) {
        self.nameTextField.text = [userInfo objectForKey:@"name"];
    }
    
    if (![[userInfo objectForKey:@"email"] isEqualToString:@""]) {
        self.emailTextField.text = [userInfo objectForKey:@"email"];
    } 
    
    if (![[userInfo objectForKey:@"phone"] isEqualToString:@""]) {
        self.phoneTextField.text = [userInfo objectForKey:@"phone"];
    }
}

#pragma mark - Action
- (void)cancelButtonDidTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveButtonDidTap:(id)sender {
    SharedData *sharedData = [SharedData sharedInstance];
    if (![sharedData validateEmailWithString:self.emailTextField.text]) {
        [self.emailTextField setTextColor:[UIColor redColor]];
        [self.emailAlert setHidden:NO];
        return;
    }
    
    NSDictionary *userInfo = @{@"name":self.nameTextField.text,
                               @"email":self.emailTextField.text,
                               @"idd_code":@"+62",
                               @"phone":self.phoneTextField.text};
    [UserManager saveUserTicketInfo:userInfo];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)doneWithNumberPad {
    [self.phoneTextField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.nameTextField]) {
        [self.emailTextField becomeFirstResponder];
    } else if ([textField isEqual:self.emailTextField]) {
        [self.phoneTextField becomeFirstResponder];
    } else if ([textField isEqual:self.phoneTextField]) {
        [self.phoneTextField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self checkButtonActivate];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    [self checkButtonActivate];
    
    if (textField == self.emailTextField) {
        [self.emailTextField setTextColor:[UIColor blackColor]];
        [self.emailAlert setHidden:YES];
    }
    
    return YES;
}

@end
