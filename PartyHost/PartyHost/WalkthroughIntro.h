//
//  WalkthroughIntro.h
//  PartyHost
//
//  Created by Tony Suriyathep on 6/20/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Walkthrough.h"

@interface WalkthroughIntro : UIView

@property (weak, nonatomic) IBOutlet UILabel *labelChoice;
@property (weak, nonatomic) IBOutlet UIButton *buttonGender;
@property (weak, nonatomic) IBOutlet UIButton *buttonContinue;

@property (strong, nonatomic) SharedData *sharedData;
@property (strong, nonatomic) Walkthrough *walkthrough;

-(void)updateGender:(BOOL)animated;

@end
