//
//  ReviewScreen.h
//  PartyHost
//
//  Created by Tony Suriyathep on 5/12/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChampagneScreen : UIView

@property (strong, nonatomic) SharedData *sharedData;
@property (strong, nonatomic) UIView *mainCon;
@property (strong, nonatomic) UIButton *btnCancel;
@property (strong, nonatomic) UILabel *title;

-(void)initClass;
-(void)exitHandler;

@end
