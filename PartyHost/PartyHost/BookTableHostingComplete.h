//
//  BookTableHostingComplete.h
//  PartyHost
//
//  Created by Tony Suriyathep on 7/27/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookTableHostingComplete : UIView

@property (strong, nonatomic) SharedData *sharedData;

@property (strong, nonatomic) UIButton *btnHelp;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *subtitle;
@property (strong, nonatomic) UIButton *btnContinue;
@property (strong, nonatomic) SelectionCheckmark *check1;

-(void)initClass;

@end
