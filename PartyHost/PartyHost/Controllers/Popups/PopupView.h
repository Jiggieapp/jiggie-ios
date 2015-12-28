//
//  PopupView.h
//  PartyHost
//
//  Created by Tony Suriyathep on 7/7/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupView : UIView

@property (strong, nonatomic) SharedData *sharedData;
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIView *popupView;

-(void)popup:(NSString*)nib animated:(BOOL)animated;
-(void)popout:(BOOL)animated;
-(void)resetFrame;

@end
