//
//  EventsHostDetail.h
//  PartyHost
//
//  Created by Sunny Clark on 2/14/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "PHImage.h"
#import "RatingView.h"
#import "Messages.h"


@interface EventsHostDetail : UIView<UIScrollViewDelegate,UIActionSheetDelegate>

@property(strong,nonatomic) SharedData *sharedData;
@property(strong,nonatomic) NSMutableDictionary *memberProfileDict;
@property(assign,nonatomic) BOOL isSelf;
@property(assign,nonatomic) BOOL isAccepted;

//Nav top
@property(nonatomic,strong) UILabel *title;
@property(nonatomic,strong) UILabel *subtitle;
@property(nonatomic,strong) UIView *tabBar;
@property(nonatomic,strong) UIButton *btnBack;
@property(nonatomic,strong) UIButton *btnForward;

//Nav bottom
@property(nonatomic,strong) UIButton *button1;
@property(nonatomic,strong) UIButton *button2;
@property(nonatomic,strong) UIView *buttonSeparator;

//Content
@property(nonatomic,strong) UIScrollView *mainScroll;
@property(nonatomic,strong) PHImage *userImage;
@property(nonatomic,strong) UILabel *memberName;
@property(nonatomic,strong) UILabel *interestCount;
@property(nonatomic,strong) UIView *separator1;
@property(nonatomic,strong) UIView *reviewContainer;
@property(nonatomic,strong) RatingView *reviewRatingView;
@property(nonatomic,strong) UILabel *reviewLabel;
@property(nonatomic,strong) UIView *separator2;
@property(nonatomic,strong) UITextView *descriptionText;
@property(nonatomic,strong) UIView *separator3;
@property(nonatomic,strong) UIView *offeringsContainer;
@property(nonatomic,strong) UIView *backgroundView;

-(void)initClass;
//-(void)forceReload;
-(void)populateMemberProfile:(NSDictionary*)data;

@end
