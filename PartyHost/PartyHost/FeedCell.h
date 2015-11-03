//
//  FeedCell.h
//  PartyHost
//
//  Created by Tony Suriyathep on 4/24/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//
#import "Feed.h"
#import <UIKit/UIKit.h>
#import "Messages.h"
#import "NSDate+TimeAgo.h"
#import "PHImage.h"
#import "HostVenueDetail.h"

@interface FeedCell : UITableViewCell <UIAlertViewDelegate>

@property (strong, nonatomic) SharedData *sharedData;


@property (strong, nonatomic) UIView                *mainCon;


@property (strong, nonatomic) UILabel               *textLine1;
@property (strong, nonatomic) UILabel               *textLine2;
@property (strong, nonatomic) UILabel               *textTime;
@property (strong, nonatomic) UserBubble            *circle;
@property (strong, nonatomic) UIImageView           *image;
@property (strong, nonatomic) UIButton              *button1;
@property (strong, nonatomic) UIButton              *button2;
@property (strong, nonatomic) UIView                *imageTint;
@property (strong, nonatomic) NSMutableDictionary   *mainData;
@property (strong, nonatomic) NSString              *choice1;
@property (strong, nonatomic) NSString              *choice2;
@property (strong, nonatomic) NSString              *apiChoice1;
@property (strong, nonatomic) NSString              *apiChoice2;
@property (strong, nonatomic) UILabel               *title;
@property (strong, nonatomic) UILabel               *subtitle;
@property (strong, nonatomic) UILabel               *imageTimeLabel;
@property (strong, nonatomic) UIImageView           *sepImage;
@property (strong, nonatomic) UIView                *bg;




@property (strong, nonatomic) UIView                *cardOne;
@property (strong, nonatomic) UIView                *bgWhite;
@property (strong, nonatomic) PHImage               *userImage;
@property (strong, nonatomic) UIView                *greenCircle;
@property (strong, nonatomic) UILabel               *nameLabel;
@property (strong, nonatomic) UIButton              *eventLabel;
@property (strong, nonatomic) UILabel               *recLabel;
@property (strong, nonatomic) UIView                *grayLine;
@property (strong, nonatomic) UIButton              *btnDeny;
@property (strong, nonatomic) UIButton              *btnApprove;
@property (strong, nonatomic) UIButton              *btnUserImage;


@property (strong, nonatomic) UIView                *cardTwo;
@property (strong, nonatomic) UILabel               *titleLabel;
@property (strong, nonatomic) UILabel               *nameLabelTwo;
@property (strong, nonatomic) UIButton               *eventLabelTwo;
@property (strong, nonatomic) PHImage               *userImageTwo;
@property (strong, nonatomic) UIView                *greenCircleTwo;
@property (strong, nonatomic) UIButton              *btnUserImageTwo;


-(void)loadData:(NSMutableDictionary *)dict;
-(void)reset;

@end
