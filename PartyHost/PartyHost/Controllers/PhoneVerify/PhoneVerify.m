//
//  PhoneVerify.m
//  PartyHost
//
//  Created by Tony Suriyathep on 7/24/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "PhoneVerify.h"

#define SCREEN_LEVELS 3

@implementation PhoneVerify
{
    NSString *placeholderText;
    UIColor *placeholderColor;
}

- (id)initWithFrame:(CGRect)frame
{
    placeholderText = @"Phone Number";
    placeholderColor = [UIColor grayColor];
    
    self.pickerA = [[NSMutableArray alloc] init];
    
    [self.pickerA addObject:@"US - United States"];
    [self.pickerA addObject:@"+ International"];
    
    self = [super initWithFrame:frame];
    self.layer.masksToBounds = YES;
    self.sharedData = [SharedData sharedInstance];
    
    self.mainCon = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.sharedData.screenWidth*SCREEN_LEVELS, self.sharedData.screenHeight)];
    self.mainCon.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.mainCon];
    
    //Add validation screen
    self.phoneVerifyValidate = [[PhoneVerifyValidate alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth*1,0,self.sharedData.screenWidth,self.sharedData.screenHeight)];
    [self.mainCon addSubview:self.phoneVerifyValidate];
    
    //Add complete screen
    self.phoneVerifyComplete = [[PhoneVerifyComplete alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth*2,0,self.sharedData.screenWidth,self.sharedData.screenHeight)];
    [self.mainCon addSubview:self.phoneVerifyComplete];
    
    self.tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 60)];
    self.tabBar.backgroundColor = [UIColor phPurpleColor];
    [self.mainCon addSubview:self.tabBar];
    
    //Cancel button
    self.btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnCancel.frame = CGRectMake(8, 15, 80, 50);
    self.btnCancel.titleLabel.font = [UIFont phBold:14];
    self.btnCancel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.btnCancel setTitle:@"CANCEL" forState:UIControlStateNormal];
    [self.btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnCancel addTarget:self action:@selector(btnCancelClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:self.btnCancel];
    
    self.sharedData.btnPhoneVerifyCancel = self.btnCancel;
    
    
    self.mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.tabBar.frame.size.height + self.tabBar.frame.origin.y, self.sharedData.screenWidth,self.sharedData.screenHeight - self.tabBar.frame.size.height - PHTabHeight)];
    self.mainScroll.showsVerticalScrollIndicator    = NO;
    self.mainScroll.showsHorizontalScrollIndicator  = NO;
    self.mainScroll.scrollEnabled                   = YES;
    //self.mainScroll.userInteractionEnabled          = YES;
    self.mainScroll.delegate                        = nil;
    self.mainScroll.backgroundColor                 = [UIColor whiteColor];
    self.mainScroll.contentSize                     = CGSizeMake(self.sharedData.screenWidth, 1200);
    self.mainScroll.layer.masksToBounds             = YES;
    [self.mainCon addSubview:self.mainScroll];
    
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, 72 - self.tabBar.frame.size.height, self.sharedData.screenWidth, 21)];
    self.title.text = @"Verify your phone number";
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.textColor = [UIColor blackColor];
    self.title.font = [UIFont phBlond:16];
    [self.mainScroll addSubview:self.title];
    
    UILabel *warning = [[UILabel alloc] initWithFrame:CGRectMake(0, self.title.frame.origin.y + self.title.frame.size.height + 4, self.sharedData.screenWidth, 16)];
    warning.text = @"No one will see your phone number on Jiggie";
    warning.textAlignment = NSTextAlignmentCenter;
    warning.textColor = [UIColor phDarkGrayColor];
    warning.font = [UIFont phBlond:12];
    [self.mainScroll addSubview:warning];
    
    UIView *bar1 = [[UIView alloc] initWithFrame:CGRectMake(-2, warning.frame.origin.y + warning.frame.size.height + 24, self.sharedData.screenWidth+4, 64)];
    bar1.backgroundColor = [UIColor clearColor];
    bar1.layer.borderColor = [UIColor phGrayColor].CGColor;
    bar1.layer.borderWidth = 1.0;
    [self.mainScroll addSubview:bar1];
    
    
    NSLog(@"RECT_ :: %@",NSStringFromCGRect(bar1.frame));
    self.subtitle = [[UILabel alloc] initWithFrame:bar1.bounds];
    self.subtitle.text = @"International";
    
    
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    self.subtitle.attributedText = [[NSAttributedString alloc] initWithString:@"International"
                                                                   attributes:underlineAttribute];
    
    self.subtitle.textAlignment = NSTextAlignmentCenter;
    self.subtitle.textColor = [UIColor blackColor];
    self.subtitle.font = [UIFont phBlond:17];
    self.subtitle.layer.borderColor = [UIColor phGrayColor].CGColor;
    self.subtitle.layer.borderWidth = 1.0;
    
    
    UIView *bar2 = [[UIView alloc] initWithFrame:CGRectMake(-2, bar1.frame.origin.y + bar1.frame.size.height -1, self.sharedData.screenWidth+4, 64)];
    bar2.backgroundColor = [UIColor clearColor];
    bar2.layer.borderColor = [UIColor phGrayColor].CGColor;
    bar2.layer.borderWidth = 1.0;
    [self.mainScroll addSubview:bar2];
    
    self.phoneField = [[UITextField alloc] initWithFrame:bar2.bounds];
    self.phoneField.text = placeholderText;
    self.phoneField.delegate = self;
    self.phoneField.textAlignment = NSTextAlignmentCenter;
    self.phoneField.textColor = [UIColor blackColor];
    self.phoneField.font = [UIFont phBlond:19];
    self.phoneField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneField.text = @"+";
    [bar2 addSubview:self.phoneField];
    
    //Resign first responder when tapped away
    UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clickAwayFromKeyboard:)];
    tap.minimumPressDuration = 0.01;
    [self.mainScroll addGestureRecognizer:tap];
    
    //Create big HOST HERE button
    self.btnVerify = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.btnVerify.frame = CGRectMake(0, self.sharedData.screenHeight, self.sharedData.screenWidth, PHButtonHeight);
    self.btnVerify.titleLabel.font = [UIFont phBold:18];
    self.btnVerify.userInteractionEnabled = YES;
    [self.btnVerify setTitleEdgeInsets:UIEdgeInsetsMake(3,0,0,0)];
    [self.btnVerify setTitle:@"VERIFY PHONE NUMBER" forState:UIControlStateNormal];
    [self.btnVerify setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnVerify setBackgroundColor:[UIColor phBlueColor]];
    [self.btnVerify addTarget:self action:@selector(btnVerifyClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.mainCon addSubview:self.btnVerify];
    
    [bar1 addSubview:self.subtitle];
    self.isLocal = NO;
    
    //Details screen
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(goToPhoneVerifyValidate)
     name:@"GO_PHONE_VERIFY_VALIDATE"
     object:nil];
    
    //Confirm screen
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(goToPhoneVerifyComplete)
     name:@"GO_PHONE_VERIFY_COMPLETE"
     object:nil];
    
    return self;
}


-(void)USTapHandler:(UILongPressGestureRecognizer *)sender
{
    
}

-(void)clickAwayFromKeyboard:(UILongPressGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:self];
    
    
    NSLog(@"POINT :: %@",NSStringFromCGPoint(point));
    NSLog(@"RECT :: %@",NSStringFromCGRect(self.subtitle.frame));
    if (CGRectContainsPoint(CGRectMake(-2, 77 + 72, 324, 64), point))
    {
        NSLog(@"INSIDE!!!");
        if(sender.state == UIGestureRecognizerStateBegan)
        {
            self.subtitle.textColor = placeholderColor;
        }
        
        if(sender.state == UIGestureRecognizerStateEnded)
        {
            self.subtitle.textColor = [UIColor blackColor];
            self.subtitle.text = ([self.subtitle.text isEqualToString:@"International"])?@"US - United States":@"International";
            self.isLocal = ![self.subtitle.text isEqualToString:@"International"];
            
            NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
            self.subtitle.attributedText = [[NSAttributedString alloc] initWithString:self.subtitle.text
                                                                           attributes:underlineAttribute];
            
            if(self.isLocal)
            {
                self.phoneField.text = @"+1-";
            }else{
                self.phoneField.text = @"+";
            }
            
        }
    }else{
        if(sender.state == UIGestureRecognizerStateEnded)
        {
            //[self endEditing:YES];
        }
    }
    
    
}

-(void)goToPhoneVerifyValidate
{
    [self.phoneVerifyValidate initClass];
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.mainCon.frame = CGRectMake(-self.sharedData.screenWidth * 1, 0, self.sharedData.screenWidth * SCREEN_LEVELS, self.sharedData.screenHeight);
     } completion:^(BOOL finished)
     {
         [self.phoneVerifyValidate keyboardOn];
     }];
}

-(void)goToPhoneVerifyComplete
{
    [self.phoneVerifyComplete initClass];
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.mainCon.frame = CGRectMake(-self.sharedData.screenWidth * 2, 0, self.sharedData.screenWidth * SCREEN_LEVELS, self.sharedData.screenHeight);
     } completion:^(BOOL finished)
     {
         [self.phoneVerifyComplete.check1 buttonSelect:YES animated:YES];
     }];
}

-(void)btnCancelClicked
{
    [self exitHandler];
}

-(void)btnVerifyClicked
{
    /*
    if([self.phoneField.text length]<14)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Phone Number" message:@"Please check the phone number and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    */
   
    
    
    
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"We will send a verification code to the phone number:"
                                                     message:self.phoneField.text
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles: nil];
    alert.tag = 0;
    [alert addButtonWithTitle:@"Send Code"];
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==0)
    {
        if(buttonIndex==1)
        {
           self.sharedData.phoneCountry =self.subtitle.text;
            [self requestVerification];
        }
    }
}

-(void)requestVerification
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    self.phone = self.phoneField.text;
    
    self.cleanPhone = self.phone;
    self.cleanPhone = [self.cleanPhone stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.cleanPhone = [self.cleanPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    self.cleanPhone = [self.cleanPhone stringByReplacingOccurrencesOfString:@"+" withString:@""];
    self.cleanPhone = [self.cleanPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    self.cleanPhone = [self.cleanPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    
    self.cleanPhone = [[self.cleanPhone componentsSeparatedByCharactersInSet:
                     [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                    componentsJoinedByString:@""];
    
    
    
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    NSString *url = [Constants phoneVerifySendURL:self.sharedData.fb_id phone:self.cleanPhone];
    
    NSLog(@"PHONE_VERIFY_SEND_URL :: %@",url);
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"PHONE_VERIFY_SEND_RESPONSE :: %@",responseObject);
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
         if(![responseObject[@"success"] boolValue])
         {
             
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could Not Verify" message:responseObject[@"reason"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             alert.tag = 1;
             [alert show];
             return;
         }
         else {
             [self keyboardOff];
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"GO_PHONE_VERIFY_VALIDATE"
              object:self];
             
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"PHONE_VERIFY_SEND_ERROR :: %@",error);
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
     }];

}

-(void)initClass
{
    self.hidden = NO;
    //self.phoneField.text = placeholderText;
    //self.phoneField.textColor = placeholderColor;
    self.isLocal = NO;
    self.phoneField.text = @"+";
    self.subtitle.text = @"International";
    
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    self.subtitle.attributedText = [[NSAttributedString alloc] initWithString:self.subtitle.text
                                                                   attributes:underlineAttribute];
    
    self.mainCon.frame = CGRectMake(0, self.sharedData.screenHeight, self.sharedData.screenWidth * SCREEN_LEVELS, self.sharedData.screenHeight);
    self.btnVerify.frame = CGRectMake(0, self.sharedData.screenHeight - PHButtonHeight, self.sharedData.screenWidth, PHButtonHeight);
    
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^
     {
         self.mainCon.frame = CGRectMake(0, 0, self.sharedData.screenWidth * SCREEN_LEVELS, self.sharedData.screenHeight);
     }
                     completion:^(BOOL finished)
     {
         [self keyboardOn];
     }];
    
    
    [self.sharedData trackMixPanelWithDict:@"View Phone Verification" withDict:@{}];
}

//Special scroll up for iPhone4 short screens
-(void)scrollForIPhone4 {
    [self.mainScroll setContentOffset:CGPointMake(0,72) animated:YES];
}

-(void)exitHandler
{
    [self keyboardOff];
    
    [UIView animateWithDuration:0.15
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^
     {
         self.mainCon.frame = CGRectMake(self.mainCon.frame.origin.x, self.sharedData.screenHeight, self.sharedData.screenWidth * SCREEN_LEVELS, self.sharedData.screenHeight);
     }
                     completion:^(BOOL finished)
     {
         self.hidden = YES;
     }];
}

-(void)onKeyboardShow:(NSNotification *)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [keyboardFrameBegin CGRectValue];
    
    self.btnVerify.frame = CGRectMake(0, keyboardFrame.origin.y - PHButtonHeight, self.sharedData.screenWidth, PHButtonHeight);
    
    //Special scroll up for iPhone4 short screens
    if(self.sharedData.isIphone4)
    {
        [self performSelector:@selector(scrollForIPhone4) withObject:nil afterDelay:0.15];
    }
}

-(void)onKeyboardHide:(NSNotification *)notification
{
    self.btnVerify.frame = CGRectMake(0, self.sharedData.screenHeight - PHButtonHeight, self.sharedData.screenWidth, PHButtonHeight);
    
    [self.mainScroll setContentOffset:CGPointZero animated:YES];
}

#pragma mark - UITextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString* totalString = [NSString stringWithFormat:@"%@%@",textField.text,string];
    
    // if it's the phone number textfield format it.
    if (range.length == 1) {
        // Delete button was hit.. so tell the method to delete the last char.
        textField.text = [self formatPhoneNumber:totalString deleteLastChar:YES];
    } else {
        textField.text = [self formatPhoneNumber:totalString deleteLastChar:NO ];
    }
    return false;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if([textField.text isEqualToString:placeholderText])
    {
        textField.text = @"";
        textField.textColor = [UIColor whiteColor];
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

-(NSString*)formatPhoneNumber:(NSString*) simpleNumber deleteLastChar:(BOOL)deleteLastChar {
    if(simpleNumber.length==0) return @"";
    // use regex to remove non-digits(including spaces) so we are left with just the numbers
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\s-\\(\\)]" options:NSRegularExpressionCaseInsensitive error:&error];
    simpleNumber = [regex stringByReplacingMatchesInString:simpleNumber options:0 range:NSMakeRange(0, [simpleNumber length]) withTemplate:@""];
    
    
    simpleNumber = [simpleNumber stringByReplacingOccurrencesOfString:@"+1" withString:@""];
    simpleNumber = [simpleNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    /*
    simpleNumber = [[simpleNumber componentsSeparatedByCharactersInSet:
                     [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                    componentsJoinedByString:@""];
    */
    // check if the number is to long
    if(simpleNumber.length>10 && self.isLocal) {
        // remove last extra chars.
        simpleNumber = [simpleNumber substringToIndex:10];
    }
    
    if(deleteLastChar) {
        // should we delete the last digit?
        if([simpleNumber length] > 0)
        {
            simpleNumber = [simpleNumber substringToIndex:[simpleNumber length] - 1];
        }
    }
    
    NSString *begin;
    if(self.isLocal)
    {
        begin = @"+1-";
    }else
    {
        begin = @"+";
    }
    
    // 123 456 7890
    // format the number.. if it's less then 7 digits.. then use this regex.
    
    if(simpleNumber.length<4 || !self.isLocal)
    {
        simpleNumber = [NSString stringWithFormat:@"%@%@",begin,simpleNumber];
    }else if(simpleNumber.length<7)
    {
        
        simpleNumber = [simpleNumber stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d+)"
                                                               withString:[NSString stringWithFormat:@"%@ $1-$2",begin]

                                                                  options:NSRegularExpressionSearch
                                                                    range:NSMakeRange(0, [simpleNumber length])];
    
    }else{  // else do this one..
        simpleNumber = [simpleNumber stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d{3})(\\d+)"
                                                               withString:[NSString stringWithFormat:@"%@ $1-$2-$3",begin]
                                                                  options:NSRegularExpressionSearch
                                                                    range:NSMakeRange(0, [simpleNumber length])];
    }
    return simpleNumber;
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
    
    [self.phoneField becomeFirstResponder];
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
    
    [self.phoneField resignFirstResponder];
}

@end
