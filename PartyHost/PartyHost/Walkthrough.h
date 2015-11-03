//
//  Walkthrough.h
//  PartyHost
//
//  Created by Tony Suriyathep on 6/20/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Walkthrough : UIView <UIScrollViewDelegate>

@property (strong, nonatomic) SharedData *sharedData;

- (void)initClass;
- (void)loadHelpImages;
- (void)buttonClick;
- (void)buttonBackward;

@end
