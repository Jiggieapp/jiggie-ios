//
//  BookTableAbout.h
//  PartyHost
//
//  Created by Tony Suriyathep on 7/17/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookTableAbout : UIView <UITextViewDelegate>

@property (strong, nonatomic) SharedData *sharedData;
@property (strong, nonatomic) NSMutableArray *mainArray;

@property (strong, nonatomic) UIButton *btnCancel;
@property (strong, nonatomic) UIButton *btnHelp;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *subtitle;
@property (strong, nonatomic) UIView *separator;
@property (strong, nonatomic) UIButton *btnContinue;
@property (strong, nonatomic) UITextView *txtAbout;

-(void)initClass;
-(void)exitHandler;
-(void)reset;

@end
