//
//  CreditCard.h
//  PartyHost
//
//  Created by Tony Suriyathep on 7/29/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreditCardComplete.h"

@interface CreditCard : UIView <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (strong, nonatomic) SharedData *sharedData;

@property (strong, nonatomic) UIButton *btnCancel;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *subtitle;
@property (strong, nonatomic) UIButton *btnContinue;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UITextField *fieldNumber;
@property (strong, nonatomic) UITextField *fieldName;
@property (strong, nonatomic) UITextField *fieldExpiry;
@property (strong, nonatomic) UITextField *fieldCVV;
@property (strong, nonatomic) UITextField *currentFirstResponder;

//Screens
@property (strong, nonatomic) UIView *mainCon;
@property (strong, nonatomic) CreditCardComplete *creditCardComplete;

-(void)initClass;
-(void)exitHandler;

@end
