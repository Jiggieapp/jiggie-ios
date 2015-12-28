//
//  PhoneVerifyValidate.h
//  PartyHost
//
//  Created by Tony Suriyathep on 7/24/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneVerifyValidate : UIView <UITextFieldDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) SharedData *sharedData;

@property (strong, nonatomic) UIButton *btnCancel;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *subtitle;
@property (strong, nonatomic) UITextField *validateField;
@property (strong, nonatomic) UIButton *btnVerify;

-(void)initClass;
-(void)exitHandler;
-(void)keyboardOn;
-(void)keyboardOff;

@end
