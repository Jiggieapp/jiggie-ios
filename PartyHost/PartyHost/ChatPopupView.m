//
//  ChatPopupView.m
//  PartyHost
//
//  Created by Tony Suriyathep on 7/6/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "ChatPopupView.h"

@implementation ChatPopupView

- (IBAction)buttonClicked:(id)sender {
    SharedData *s = [SharedData sharedInstance];
    [s.popupView popout:YES];
}

@end
