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
#import "SVProgressHUD.h"
#import "AnalyticManager.h"
#import "SharedData.h"
#import "DialCodeListViewController.h"

@interface GuestDetailViewController ()

@end

@implementation GuestDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController setNavigationBarHidden:YES];   //it hides
    
    self.navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.visibleSize.width, 60)];
    [self.navBar setBackgroundColor:[UIColor phPurpleColor]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, self.visibleSize.width - 80, 40)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:@"Contact Detail"];
    [titleLabel setFont:[UIFont phBlond:16]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.navBar addSubview:titleLabel];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setFrame:CGRectMake(self.visibleSize.width - 50, 20.0f, 40.0f, 40.0f)];
    [cancelButton setImageEdgeInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
    [cancelButton setImage:[UIImage imageNamed:@"nav_close"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:cancelButton];
    
    [self.view addSubview:self.navBar];
    
    UIView *line1View = [[UIView alloc] initWithFrame:CGRectMake(0, 60, self.visibleSize.width, 1)];
    [line1View setBackgroundColor:[UIColor phLightGrayColor]];
    [self.view addSubview:line1View];
    
    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(line1View.frame) + 10, self.visibleSize.width - 32, 30)];
    [self.nameTextField setBackgroundColor:[UIColor clearColor]];
    [self.nameTextField setPlaceholder:@"Guest name"];
    [self.nameTextField setFont:[UIFont phBlond:13]];
    [self.nameTextField setReturnKeyType:UIReturnKeyNext];
    [self.nameTextField setDelegate:self];
    [self.view addSubview:self.nameTextField];
    
    UIView *line2View = [[UIView alloc] initWithFrame:CGRectMake(0, 60 + 50, self.visibleSize.width, 1)];
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
    
    UIView *line3View = [[UIView alloc] initWithFrame:CGRectMake(0, 60 + 50 + 50, self.visibleSize.width, 1)];
    [line3View setBackgroundColor:[UIColor phLightGrayColor]];
    [self.view addSubview:line3View];
    
    self.phoneCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(line3View.frame) + 10, 50 , 30)];
    [self.phoneCodeTextField setBackgroundColor:[UIColor clearColor]];
    [self.phoneCodeTextField setFont:[UIFont phBlond:13]];
    [self.phoneCodeTextField setKeyboardType:UIKeyboardTypePhonePad];
    [self.phoneCodeTextField setReturnKeyType:UIReturnKeyDone];
    [self.phoneCodeTextField setDelegate:self];
    [self.phoneCodeTextField setEnabled:YES];
    [self.phoneCodeTextField setText:@"+62"];
    [self.view addSubview:self.phoneCodeTextField];
    
    UIView *lineVertical = [[UIView alloc] initWithFrame:CGRectMake(16 + 50, CGRectGetMaxY(line3View.frame) , 1, 50)];
    [lineVertical setBackgroundColor:[UIColor phLightGrayColor]];
    [self.view addSubview:lineVertical];
    
    self.phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(16 + 50 + 16, CGRectGetMaxY(line3View.frame) + 10, self.visibleSize.width - 32 - 50 - 16, 30)];
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
    
    UIView *line4View = [[UIView alloc] initWithFrame:CGRectMake(0, 60 + 50 + 50 + 50, self.visibleSize.width, 1)];
    [line4View setBackgroundColor:[UIColor phLightGrayColor]];
    [self.view addSubview:line4View];
    
    UILabel *starLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(line4View.frame) + 10, 8, 20)];
    [starLabel setText:@"*"];
    [starLabel setNumberOfLines:2];
    [starLabel setTextColor:[UIColor purpleColor]];
    [starLabel setFont:[UIFont phBlond:15]];
    [starLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:starLabel];
    
    UILabel *tncLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(line4View.frame) + 10, self.visibleSize.width - 30 - 16, 40)];
    [tncLabel setText:@"Please verify your information is correct so we can keep you updated on your order"];
    [tncLabel setNumberOfLines:2];
    [tncLabel setFont:[UIFont phBlond:13]];
    [tncLabel setTextColor:[UIColor phPurpleColor]];
    [tncLabel setBackgroundColor:[UIColor clearColor]];
    [tncLabel sizeToFit];
    [self.view addSubview:tncLabel];
    
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveButton addTarget:self action:@selector(saveButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton setFrame:CGRectMake(0, self.view.bounds.size.height - 54, self.visibleSize.width, 54)];
    [self.saveButton setBackgroundColor:[UIColor colorFromHexCode:@"B6ECFF"]];
    [self.saveButton.titleLabel setFont:[UIFont phBold:15]];
    [self.saveButton setTitle:@"SAVE" forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.saveButton setEnabled:NO];
    [self.view addSubview:self.saveButton];
 
    [self loadData];
    
    // MixPanel
    SharedData *sharedData = [SharedData sharedInstance];
    [[AnalyticManager sharedManager] trackMixPanelWithDict:@"Guest Info" withDict:sharedData.mixPanelCTicketDict];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dialCodeSelectionHandler:)
                                                 name:@"DialCodeSelected"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Validate 
- (void)checkButtonActivate {
    if (self.emailTextField.text.length > 0 && self.phoneTextField.text.length > 0 && self.nameTextField.text.length > 0 && self.phoneCodeTextField.text.length > 0) {
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
    
    if (![[userInfo objectForKey:@"dial_code"] isEqualToString:@""]) {
        self.phoneCodeTextField.text = [NSString stringWithFormat:@"+%@", [userInfo objectForKey:@"dial_code"]];
    }
    
    if (![[userInfo objectForKey:@"phone"] isEqualToString:@""]) {
        NSString *dial_code =  [userInfo objectForKey:@"dial_code"];
        NSString *phone =  [userInfo objectForKey:@"phone"];
        
        self.phoneTextField.text = [phone substringFromIndex:dial_code.length];
    }
}

#pragma mark - Action
- (void)cancelButtonDidTap:(id)sender {
    [self.view endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveButtonDidTap:(id)sender {
    [self.view endEditing:YES];
    
    SharedData *sharedData = [SharedData sharedInstance];
    if (![sharedData validateEmailWithString:self.emailTextField.text]) {
        [self.emailTextField setTextColor:[UIColor redColor]];
        [self.emailAlert setHidden:NO];
        
        [SVProgressHUD showErrorWithStatus:@"Invalid Email Format"];
        return;
    }
    
    NSString *dialCode = self.phoneCodeTextField.text;
    if (dialCode && dialCode.length > 0) {
        dialCode = [dialCode substringFromIndex:1];
    }
    
    NSString *phone = [NSString stringWithFormat:@"%@%@", dialCode, self.phoneTextField.text];
    
    NSDictionary *userInfo = @{@"name":self.nameTextField.text,
                               @"email":self.emailTextField.text,
                               @"dial_code":dialCode,
                               @"phone":phone};
    [UserManager saveUserTicketInfo:userInfo];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)doneWithNumberPad {
    [self.phoneTextField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.phoneCodeTextField) {
        DialCodeListViewController * dialCodeListViewController = [[DialCodeListViewController alloc] init];
        [self.navigationController pushViewController:dialCodeListViewController animated:YES];
        
        return NO;
    }
    
    return YES;
}

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
    [self performSelector:@selector(checkButtonActivate) withObject:nil afterDelay:0.1];
    
    if (textField == self.emailTextField) {
        [self.emailTextField setTextColor:[UIColor blackColor]];
        [self.emailAlert setHidden:YES];
    }
    
    return YES;
}

#pragma mark - UIKeyboardNotification
// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWillShow:(NSNotification*)aNotification {
    SharedData *sharedData = [SharedData sharedInstance];
    if (sharedData.isIphone4) {
        return;
    }
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.saveButton setFrame:CGRectMake(0, self.view.bounds.size.height - kbSize.height - self.saveButton.bounds.size.height, self.saveButton.bounds.size.width, self.saveButton.bounds.size.height)];
    }];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    SharedData *sharedData = [SharedData sharedInstance];
    if (sharedData.isIphone4) {
        return;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.saveButton setFrame:CGRectMake(0, self.view.bounds.size.height - self.saveButton.bounds.size.height, self.saveButton.bounds.size.width, self.saveButton.bounds.size.height)];
    }];
}

#pragma mark - Notification Handlers
- (void)dialCodeSelectionHandler:(NSNotification *)notification {
    NSString *dialCode = (NSString *)[notification object];
    [self.phoneCodeTextField setText:dialCode];
}


@end