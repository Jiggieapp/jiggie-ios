//
//  CreditCardComplete.h
//  PartyHost
//
//  Created by Tony Suriyathep on 7/30/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreditCardComplete : UIView

@property (strong, nonatomic) SharedData *sharedData;

@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *subtitle;
@property (strong, nonatomic) UILabel *ccNumber;
@property (strong, nonatomic) UIButton *btnContinue;
@property (strong, nonatomic) SelectionCheckmark *check1;

-(void)initClass;

@end
