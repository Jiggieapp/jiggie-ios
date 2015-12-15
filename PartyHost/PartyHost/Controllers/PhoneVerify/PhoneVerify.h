//
//  PhoneVerify.h
//  PartyHost
//
//  Created by Tony Suriyathep on 7/24/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhoneVerifyValidate.h"
#import "PhoneVerifyComplete.h"

@interface PhoneVerify : UIView <UITextFieldDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) SharedData *sharedData;

@property (strong, nonatomic) UIButton *btnCancel;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *subtitle;
@property (strong, nonatomic) UITextField *phoneField;
@property (strong, nonatomic) UIButton *btnVerify;
@property (strong, nonatomic) UIScrollView *mainScroll;
@property (strong, nonatomic) UIView *tabBar;
@property (strong, nonatomic) NSMutableArray  *pickerA;



@property (assign, nonatomic) BOOL isLocal;

//Screens
@property (strong, nonatomic) UIView *mainCon;
@property (strong, nonatomic) PhoneVerifyValidate *phoneVerifyValidate;
@property (strong, nonatomic) PhoneVerifyComplete *phoneVerifyComplete;

//Extra data
@property (strong, nonatomic) NSString *cleanPhone;
@property (strong, nonatomic) NSString *phone;

-(void)initClass;
-(void)exitHandler;

@end
