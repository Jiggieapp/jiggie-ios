//
//  PhoneVerifyValidate.m
//  PartyHost
//
//  Created by Tony Suriyathep on 7/24/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "More.h"
#import "PhoneVerify.h"
#import "PhoneVerifyValidate.h"

@implementation PhoneVerifyValidate
{
    NSString *placeholderText;
    UIColor *placeholderColor;
}

- (id)initWithFrame:(CGRect)frame
{
    placeholderText = @"Validation Code";
    placeholderColor = [UIColor blackColor];
    
    self = [super initWithFrame:frame];
    self.layer.masksToBounds = YES;
    self.sharedData = [SharedData sharedInstance];
    
    UIView *tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 60)];
    tabBar.backgroundColor = [UIColor phPurpleColor];
    [self addSubview:tabBar];
    
    //Cancel button
    self.btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnCancel.frame = CGRectMake(8, 15, 80, 50);
    self.btnCancel.titleLabel.font = [UIFont phBold:14];
    self.btnCancel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.btnCancel setTitle:@"CANCEL" forState:UIControlStateNormal];
    [self.btnCancel setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.btnCancel addTarget:self action:@selector(btnCancelClicked) forControlEvents:UIControlEventTouchUpInside];
    //[tabBar addSubview:self.btnCancel];
    
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, 76, self.sharedData.screenWidth, 40)];
    self.title.text = @"Enter your verification code";
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.textColor = [UIColor blackColor];
    self.title.font = [UIFont phBlond:18];
    [self addSubview:self.title];
    
    UIView *bar1 = [[UIView alloc] initWithFrame:CGRectMake(-2, self.title.frame.origin.y + self.title.frame.size.height + 24, self.sharedData.screenWidth+4, 64)];
    bar1.backgroundColor = [UIColor whiteColor];
    bar1.layer.borderColor = [UIColor phGrayColor].CGColor;
    bar1.layer.borderWidth = 1.0;
    [self addSubview:bar1];
    
    self.subtitle = [[UILabel alloc] initWithFrame:bar1.bounds];
    self.subtitle.text = @"";
    self.subtitle.textAlignment = NSTextAlignmentCenter;
    self.subtitle.textColor = [UIColor phDarkGrayColor];
    self.subtitle.font = [UIFont phBlond:19];
    [bar1 addSubview:self.subtitle];
    
    UIView *bar2 = [[UIView alloc] initWithFrame:CGRectMake(-2, bar1.frame.origin.y + bar1.frame.size.height -1, self.sharedData.screenWidth+4, 64)];
    bar2.backgroundColor = [UIColor whiteColor];
    bar2.layer.borderColor = [UIColor phGrayColor].CGColor;
    bar2.layer.borderWidth = 1.0;
    [self addSubview:bar2];
    
    self.validateField = [[UITextField alloc] initWithFrame:bar2.bounds];
    self.validateField.text = @"";
    self.validateField.delegate = self;
    self.validateField.textAlignment = NSTextAlignmentCenter;
    self.validateField.textColor = [UIColor phDarkGrayColor];
    self.validateField.font = [UIFont phBlond:19];
    self.validateField.keyboardType = UIKeyboardTypeNumberPad;
    [bar2 addSubview:self.validateField];
    
    UILabel *warning = [[UILabel alloc] initWithFrame:CGRectMake(0, bar2.frame.origin.y + bar2.frame.size.height + 32, self.sharedData.screenWidth, 16)];
    warning.text = @"Enter the 6 digit code we just sent to your number.";
    warning.textAlignment = NSTextAlignmentCenter;
    warning.textColor = [UIColor phDarkGrayColor];
    warning.font = [UIFont phBlond:12];
    [self addSubview:warning];
    
    //Create big HOST HERE button
    self.btnVerify = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.btnVerify.frame = CGRectMake(0, self.sharedData.screenHeight, self.sharedData.screenWidth, PHButtonHeight);
    self.btnVerify.titleLabel.font = [UIFont phBold:18];
    self.btnVerify.userInteractionEnabled = YES;
    [self.btnVerify setTitleEdgeInsets:UIEdgeInsetsMake(3,0,0,0)];
    [self.btnVerify setTitle:@"SUBMIT VALIDATION" forState:UIControlStateNormal];
    [self.btnVerify setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnVerify setBackgroundColor:[UIColor phBlueColor]];
    [self.btnVerify addTarget:self action:@selector(btnVerifyClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnVerify];
    
    //Resign first responder when tapped away
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAwayFromKeyboard)];
    [self addGestureRecognizer:tap];
    
    return self;
}

-(void)clickAwayFromKeyboard
{
    [self endEditing:YES];
}

-(void)btnCancelClicked
{
    [self keyboardOff];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"EXIT_PHONE_VERIFY"
     object:self];
}

-(void)btnVerifyClicked
{
    if([self.validateField.text length]!=6)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Validation Incorrect" message:@"Please double check the number and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self requestValidation];
}

-(void)requestValidation
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    NSString *url = [Constants phoneVerifyValidateURL:self.sharedData.fb_id token:self.validateField.text];
    
    NSLog(@"PHONE_VALIDATE_SEND_URL :: %@",url);
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"PHONE_VALIDATE_SEND_RESPONSE :: %@",responseObject);
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
         if(![responseObject[@"success"] boolValue]) {
             
             [self.sharedData trackMixPanelWithDict:@"Phone Verification Fail" withDict:@{}];
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Validation Incorrect" message:@"Please check the number and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             alert.tag = 1;
             [alert show];
             
             return;
         }
         else {
             [self.sharedData trackMixPanelWithDict:@"Phone Verification Success" withDict:@{}];
             //Set phone now
             self.sharedData.phone = self.sharedData.phoneVerify.phone;
             
             //Reload more
             [self.sharedData.morePage.moreList reloadData];
             
             [self keyboardOff];
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"GO_PHONE_VERIFY_COMPLETE"
              object:self];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self.sharedData trackMixPanelWithDict:@"Phone Verification Fail" withDict:@{}];
         NSLog(@"PHONE_VERIFY_SEND_ERROR :: %@",error);
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
     }];
    
}

-(void)initClass
{
    self.btnVerify.frame = CGRectMake(0, self.sharedData.screenHeight - PHButtonHeight, self.sharedData.screenWidth, PHButtonHeight);
    self.subtitle.text = self.sharedData.phoneVerify.phone;
    self.validateField.text = placeholderText;
    self.validateField.textColor = [UIColor phDarkGrayColor];
    [self keyboardOn];
}

-(void)exitHandler
{
    [self keyboardOff];
}

-(void)keyboardOn
{
    //Remove keyboard observer
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillShowNotification
     object:nil];
    
    //Remove keyboard observer
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillHideNotification
     object:nil];
    
    //Add keyboard observer
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(onKeyboardShow:)
     name:UIKeyboardWillShowNotification
     object:nil];
    
    //Add keyboard observer
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(onKeyboardHide:)
     name:UIKeyboardWillHideNotification
     object:nil];
    
    [self.validateField becomeFirstResponder];
}

-(void)keyboardOff
{
    //Remove keyboard observer
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillShowNotification
     object:nil];
    
    //Remove keyboard observer
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillHideNotification
     object:nil];
    
    [self.validateField resignFirstResponder];
}

-(void)onKeyboardShow:(NSNotification *)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [keyboardFrameBegin CGRectValue];
    self.btnVerify.frame = CGRectMake(0, keyboardFrame.origin.y - PHButtonHeight, self.sharedData.screenWidth, PHButtonHeight);
}

-(void)onKeyboardHide:(NSNotification *)notification
{
    self.btnVerify.frame = CGRectMake(0, self.sharedData.screenHeight - PHButtonHeight, self.sharedData.screenWidth, PHButtonHeight);
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if([textField.text isEqualToString:placeholderText])
    {
        textField.text = @"";
        textField.textColor = [UIColor phDarkGrayColor];
    }
}

-(void) textFieldDidEndEditing:(UITextField *)textField
{
    if([textField.text length]==0)
    {
        textField.text = placeholderText;
        textField.textColor = placeholderColor;
    }
}

@end
