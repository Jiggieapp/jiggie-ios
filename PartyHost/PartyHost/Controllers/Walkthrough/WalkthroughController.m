//
//  WalkthroughController.m
//  PartyHost
//
//  Created by Tony Suriyathep on 6/21/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "WalkthroughController.h"
#import "Walkthrough.h"

@implementation WalkthroughController

- (void)awakeFromNib
{
    self.sharedData = [SharedData sharedInstance];
}

- (IBAction)buttonContinueClicked:(id)sender
{
    [self.walkthrough buttonClick];
}

- (IBAction)buttonForwardClicked:(id)sender {
    [self.walkthrough buttonClick];
}

- (IBAction)buttonBackwardClicked:(id)sender {
    [self.walkthrough buttonBackward];
}

@end
