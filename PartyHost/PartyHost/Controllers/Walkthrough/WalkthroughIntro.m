//
//  WalkthroughIntro.m
//  PartyHost
//
//  Created by Tony Suriyathep on 6/20/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "WalkthroughIntro.h"

@implementation WalkthroughIntro


- (void)awakeFromNib
{
    self.sharedData = [SharedData sharedInstance];
    [self updateGender:NO];
}

-(void)updateGender:(BOOL)animated
{
    //Animate in
    if(animated)
    {
        CGRect fr = self.labelChoice.frame;
        
        //Animate gender slightly
        self.labelChoice.alpha = 0.00;
        self.labelChoice.frame = CGRectMake(fr.origin.x-12,fr.origin.y,fr.size.width,fr.size.height);
        [UIView animateWithDuration:0.50 delay:0.0 options: UIViewAnimationOptionCurveEaseOut animations:^
         {
             self.labelChoice.alpha = 1.00;
             self.labelChoice.frame = fr;
         }
        completion:^(BOOL finished) {}];
    }
    
    //Set gender choice from shared data
    if([self.sharedData.gender isEqualToString:@"male"]) {self.labelChoice.text = @"Male";}
    else {self.labelChoice.text = @"Female";}
    
    //Load help images
    [self.walkthrough loadHelpImages];
}

- (IBAction)buttonGenderClicked:(id)sender
{
    //Animate button slightly
    self.buttonGender.alpha = 0.75;
    [UIView animateWithDuration:0.50 delay:0.0 options: UIViewAnimationOptionCurveEaseOut animations:^
     {
         self.buttonGender.alpha = 1.00;
     }
    completion:^(BOOL finished) {}];
    
    //Toggle gender
    if([self.sharedData.gender isEqualToString:@"male"]) {self.sharedData.gender = @"female";}
    else {self.sharedData.gender = @"male";}
    [self.sharedData calculateDefaultGenderSettings];
    
    //Update graphics
    [self updateGender:YES];
    [self.walkthrough loadHelpImages];
}

- (IBAction)buttonClicked:(id)sender
{
}

@end
