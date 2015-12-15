//
//  WalkthroughPage.h
//  PartyHost
//
//  Created by Tony Suriyathep on 6/20/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Walkthrough.h"

@interface WalkthroughPage : UIView

@property (weak, nonatomic) IBOutlet UIButton *buttonContinue;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@property (strong, nonatomic) SharedData *sharedData;
@property (strong, nonatomic) Walkthrough *walkthrough;

@end
