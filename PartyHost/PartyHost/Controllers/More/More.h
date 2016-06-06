//
//  More.h
//  PartyHost
//
//  Created by Sunny Clark on 2/16/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Privacy.h"
#import "Settings.h"
#import "MyHostings.h"
#import "MyPurchases.h"
#import "MyConfirmations.h"
#import "AppDelegate.h"

@interface More : UIView<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) SharedData    *sharedData;

@property(nonatomic,strong) UIButton        *btnBack;
@property(nonatomic,strong) UIButton        *btnPTBack;
@property(nonatomic,strong) UIView          *mainCon;
@property(nonatomic,strong) Profile         *profilePage;
@property(nonatomic,strong) Settings        *settingsPage;
@property(nonatomic,strong) Privacy         *privacyPage;
@property(nonatomic,strong) Privacy         *termsPage;
@property(nonatomic,strong) MyHostings      *hostingsPage;
@property(nonatomic,strong) MyPurchases     *purchasesPage;
@property(nonatomic,strong) MyConfirmations *confirmationsPage;
@property(nonatomic,strong) NSMutableArray  *dataA;
@property(nonatomic,strong) UserBubble      *userProfilePicture;
@property(nonatomic,strong) UIButton        *editProfileButton;
@property(nonatomic,strong) UILabel         *userProfileName;
@property(nonatomic,strong) UIButton        *userProfilePhone;
@property(nonatomic,strong) UITableView     *moreList;
@property(nonatomic,assign) BOOL            isLoaded;
@property(nonatomic,strong) EmptyView *emptyView;
@property(nonatomic, copy) NSString *creditAmount;

-(void)initClass;
-(void)goPrivacy;
-(void)goTerms;
-(void)goToHosting;

@end
