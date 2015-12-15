//
//  SignupView.h
//  PartyHost
//
//  Created by Tony Suriyathep on 6/30/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetupGenderView.h"
#import "SetupPickView.h"
#import "SetupLocationView.h"
#import "SetupNotificationView.h"

@interface SetupView : UIView <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@property (strong, nonatomic) SharedData *sharedData;
@property (strong, nonatomic) SetupPickView *pickView;
@property (strong, nonatomic) SetupGenderView *genderView;
@property (strong, nonatomic) SetupNotificationView *notificationView;
@property (strong, nonatomic) SetupLocationView *locationView;
@property (strong, nonatomic) NSTimer* locationTimer;

@property (assign, nonatomic) BOOL isAnimating;


- (void)initClass;
-(void)apnAskingDoneHandler;
@end
