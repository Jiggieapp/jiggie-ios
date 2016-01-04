//
//  EventOverlay.m
//  PartyHost
//
//  Created by Tony Suriyathep on 8/8/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "GenericOverlayView.h"

@implementation GenericOverlayView

- (IBAction)buttonClicked:(id)sender {
    SharedData *s = [SharedData sharedInstance];
    [s.overlayView popout];
}

@end
