//
//  SetupLocationView.h
//  PartyHost
//
//  Created by Tony Suriyathep on 8/6/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetupLocationView : UIView

@property (weak, nonatomic) IBOutlet UISwitch *locationSwitch;

-(BOOL)commitChanges;

@end
