//
//  SetupGenderView.h
//  PartyHost
//
//  Created by Tony Suriyathep on 7/10/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetupPickViewCell.h"

@interface SetupGenderView : UIView

@property (strong, nonatomic) NSMutableArray *selectedArray;

@property (weak, nonatomic) IBOutlet SelectionButton *buttonTop;
@property (weak, nonatomic) IBOutlet SelectionButton *buttonBottom;

-(void)maleClicked:(id)sender;
-(void)femaleClicked:(id)sender;
-(void)maleSet;
-(void)femaleSet;

@end
