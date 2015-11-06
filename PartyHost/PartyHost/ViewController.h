//
//  ViewController.h
//  PartyHost
//
//  Created by Sunny Clark on 12/26/14.
//  Copyright (c) 2014 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <FacebookSDK/FacebookSDK.h>
#import <MessageUI/MessageUI.h>
#import "Login.h"
#import "Dashboard.h"
//#import "AsyncImageView.h"
#import "PHImage.h"
#import "SignupView.h"
#import "SetupView.h"


@interface ViewController : UIViewController<FBLoginViewDelegate,MFMailComposeViewControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) SharedData    *sharedData;

@property(nonatomic,strong) Dashboard       *dashboard;
@property(nonatomic,strong) UIView          *mainCon;
@property(nonatomic,strong) UIView          *loadingView;
@property(nonatomic,assign) BOOL            canPoll;
@property(nonatomic,strong) SignupView      *signupView;

@end

