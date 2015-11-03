//
//  WalkthroughController.h
//  PartyHost
//
//  Created by Tony Suriyathep on 6/21/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Walkthrough.h"

@interface WalkthroughController : UIView

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *buttonContinue;
@property (weak, nonatomic) IBOutlet UIButton *buttonForward;
@property (weak, nonatomic) IBOutlet UIButton *buttonBackward;

@property (strong, nonatomic) SharedData *sharedData;
@property (strong, nonatomic) Walkthrough *walkthrough;

@end
