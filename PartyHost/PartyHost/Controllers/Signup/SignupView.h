//
//  SignupView.h
//  PartyHost
//
//  Created by Tony Suriyathep on 6/30/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <FacebookSDK/FacebookSDK.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "UpgradeScreen.h"



@interface SignupView : UIView <UIScrollViewDelegate>

@property (strong, nonatomic) SharedData    *sharedData;

@property (weak, nonatomic) IBOutlet UIButton *buttonFacebook;
@property (weak, nonatomic) IBOutlet UIButton *buttonNext;
@property (weak, nonatomic) IBOutlet UIButton *buttonHelp;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage1;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage2;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage3;


@property(nonatomic,assign)     int             pageIndex;
@property(nonatomic,assign)     BOOL            pageControlUsed;
@property(nonatomic,strong)     NSMutableArray  *pageViews;
@property(nonatomic,strong)     NSMutableArray  *backgroundImages;
@property(nonatomic,assign)     int             totalPages;

@property(nonatomic, assign)    BOOL             didLogin;

@property(nonatomic, assign)    BOOL             didFBLogin;
@property(nonatomic, assign)    BOOL             didHerokuLogin;
@property(nonatomic, assign)    BOOL             didAPNUpdate;

@property(nonatomic, assign)    BOOL             isAutoLoginMode;

@property(nonatomic,assign)     BOOL             didFBInitInfo;

@property(nonatomic, strong)   NSMutableDictionary  *currentUser;
//@property (strong, nonatomic)   FBLoginView     *loginView;
@property (strong, nonatomic)   FBSDKLoginButton        *btnLoginFB;


@property (strong, nonatomic)   NSString           *cAlbumId;

-(void)initClass;


@end
