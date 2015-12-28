//
//  MemberProfile.h
//  PartyHost
//
//  Created by Sunny Clark on 2/18/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Messages.h"
#import "PHImage.h"
#import "RatingView.h"

@interface MemberProfile : UIView<UIScrollViewDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) SharedData    *sharedData;

@property(nonatomic,strong) UIScrollView    *picScroll;
@property(nonatomic,strong) UIScrollView    *mainScroll;
@property(nonatomic,strong) UIView          *tabBar;
@property(nonatomic,strong) UILabel         *toLabel;
@property(nonatomic,strong) UIView          *aboutPanel;
@property(nonatomic,strong) UIView          *bgView;
@property(nonatomic,strong) UILabel         *nameLabel;
@property(nonatomic,strong) UILabel         *cityLabel;
@property(nonatomic,strong) UILabel         *aboutLabel;
@property(nonatomic,strong) UITextView      *aboutBody;
@property(nonatomic,strong) UIPageControl   *pControl;

@property(nonatomic,strong) UIButton        *btnBack;

@property(nonatomic,strong) UIView          *reviewContainer;
@property(nonatomic,strong) RatingView      *reviewRatingView;
@property(nonatomic,strong) UILabel         *reviewLabel;

@property(nonatomic,strong) UILabel         *hostingsLabel;
@property(nonatomic,strong) UITextView      *hostingsBody;

@property(nonatomic,strong) UILabel         *mutualFriendsLabel;
@property(nonatomic,strong) UIScrollView    *mutualFriendsCon;
@property(nonatomic,strong) NSMutableArray  *mutualFriends;

@property(nonatomic,strong) UIView          *separator1;
@property(nonatomic,strong) UIView          *separator2;
@property(nonatomic,strong) UIView          *separator3;
@property(nonatomic,strong) UIView          *separator4;

-(void)initClass;
-(void)reset;
-(void)loadData;
-(void)exit;
//-(void)forceReload;

@end
