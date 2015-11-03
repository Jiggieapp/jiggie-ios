//
//  Login.h
//  PartyHost
//
//  Created by Sunny Clark on 12/26/14.
//  Copyright (c) 2014 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AFNetworking.h"
#import "Profile.h"
#import "UpgradeScreen.h"

@interface Login : UIView<FBLoginViewDelegate,UIScrollViewDelegate>

@property(nonatomic, strong)    SharedData      *sharedData;
@property(nonatomic,strong)     UIView          *landingView;
@property(nonatomic, strong)    FBLoginView     *loginView;


@property(nonatomic, strong)    UIButton        *btnLogin;

@property(nonatomic, assign)    BOOL             didLogin;

@property(nonatomic, assign)    BOOL             didFBLogin;
@property(nonatomic, assign)    BOOL             didFBInitInfo;
@property(nonatomic, assign)    BOOL             didRubyLogin;
@property(nonatomic, assign)    BOOL             didTryRubyLogin;
@property(nonatomic, assign)    BOOL             didHerokuLogin;

@property(nonatomic, assign)    BOOL             didAPNUpdate;

@property(nonatomic, strong)    UIPageControl    *pControl;
@property(nonatomic, strong)   id<FBGraphUser>  currentUser;

-(void)initClass;

@end
