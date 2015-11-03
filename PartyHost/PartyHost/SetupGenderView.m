//
//  SetupGenderView.m
//  PartyHost
//
//  Created by Tony Suriyathep on 7/10/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "SetupGenderView.h"

@implementation SetupGenderView

-(void)awakeFromNib {
    [self.buttonTop.button setTitle:@"MALE" forState:UIControlStateNormal];
    [self.buttonTop.button addTarget:self action:@selector(maleClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.buttonTop.onBorderColor = [UIColor whiteColor];
    self.buttonBottom.onBorderColor = [UIColor whiteColor];
    self.buttonBottom.offTextColor = [UIColor whiteColor];
    self.buttonTop.offTextColor = [UIColor whiteColor];
    
    
    [self.buttonBottom.button setTitle:@"FEMALE" forState:UIControlStateNormal];
    [self.buttonBottom.button addTarget:self action:@selector(femaleClicked:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)maleClicked:(id)sender {
    if(!self.buttonTop.isSelected) {
        SharedData *sharedData = [SharedData sharedInstance];
        sharedData.gender = @"male";
        
        [self.buttonTop buttonSelect:YES animated:YES];
        [self.buttonBottom buttonSelect:NO animated:YES];
    }
}

-(void)femaleClicked:(id)sender {
    if(!self.buttonBottom.isSelected) {
        SharedData *sharedData = [SharedData sharedInstance];
        sharedData.gender = @"female";
        
        [self.buttonTop buttonSelect:NO animated:YES];
        [self.buttonBottom buttonSelect:YES animated:YES];
    }
}

-(void)maleSet {
    [self.buttonTop buttonSelect:YES animated:YES];
    [self.buttonBottom buttonSelect:NO animated:YES];
}

-(void)femaleSet {
    [self.buttonTop buttonSelect:NO animated:NO];
    [self.buttonBottom buttonSelect:YES animated:NO];
}


@end
