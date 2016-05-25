//
//  Dashboard.h
//  PartyHost
//
//  Created by Sunny Clark on 12/26/14.
//  Copyright (c) 2014 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Events.h"
#import "Chats.h"
#import "Messages.h"
#import "More.h"
#import "MemberProfile.h"
#import "FeedView.h"
#import "MemberReviews.h"
#import "WriteReview.h"
#import "BookTable.h"
#import "BadgeView.h"
#import "HostVenueDetail.h"
#import "SetupView.h"
#import "HostVenueDetailFromShare.h"
#import "PhoneVerify.h"
#import "CreditCard.h"
#import "EventsSummaryModal.h"
#import "FeedMatch.h"

@interface Dashboard : UIView

@property(nonatomic,strong) SharedData      *sharedData;

@property(nonatomic,strong) UIView          *tabBar;

@property(nonatomic,strong) NSMutableArray  *btnsA;
@property(nonatomic,strong) NSMutableArray  *labelsA;
@property(nonatomic,strong) NSMutableArray  *pagesA;

@property(nonatomic,strong) Events          *eventsPage;
@property(nonatomic,strong) Chats            *chatPage;
@property(nonatomic,strong) Profile         *profilePage;
@property(nonatomic,strong) More            *morePage;
@property(nonatomic,strong) Hostings        *hostingsPage;
@property(nonatomic,strong) Messages        *messagesPage;
@property(nonatomic,strong) FeedView        *feedPage;
@property(nonatomic,strong) SetupView       *walkthroughPage;
@property(nonatomic,strong) HostVenueDetail *hostVenueDetailPage; //Shows host shoutout with venue details

@property(nonatomic,strong) HostVenueDetailFromShare *hostVenueDetailFromShare;

@property(nonatomic,strong) UIView          *mainCon;

@property(nonatomic,strong) UIView          *outsideCon;

//@property(nonatomic,strong) UILabel         *unreadCount;

@property(nonatomic,strong) UIImageView     *chatIcon;
@property(nonatomic,strong) UIImageView     *eventsIcon;
@property(nonatomic,strong) UIImageView     *feedIcon;
@property(nonatomic,strong) UIImageView     *profileIcon;

@property(nonatomic,strong) UILabel         *chatLabel;
@property(nonatomic,strong) UILabel         *eventsLabel;
@property(nonatomic,strong) UILabel         *feedLabel;
@property(nonatomic,strong) UILabel         *profileLabel;

@property(nonatomic,strong) MemberProfile   *memberProfile;
@property(nonatomic,strong) MemberReviews   *memberReviews;
@property(nonatomic,strong) WriteReview     *writeReview;
@property(nonatomic,strong) BookTable       *bookTable;
@property(nonatomic,strong) PhoneVerify     *phoneVerify;
@property(nonatomic,strong) CreditCard      *creditCard;
@property(nonatomic,strong) EventsSummaryModal *eventModal;

@property(nonatomic,strong) FeedMatch *feedMatch;



@property(nonatomic,assign) int             cIndex;

@property(nonatomic,assign) BOOL            callInit;

@property(nonatomic,assign) int             didTapTwice;

//Badges for tab icons
@property(nonatomic,strong) BadgeView       *chatBadge;
@property(nonatomic,strong) BadgeView       *feedBadge;

-(void)initClass;

@end
