//
//  EventsRowCell.h
//  PartyHost
//
//  Created by Sunny Clark on 2/12/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPopTipView.h"
#import "Event.h"

@interface EventsRowCell : UITableViewCell <CMPopTipViewDelegate>

@property (strong, nonatomic) SharedData    *sharedData;


@property(nonatomic,strong) UILabel         *title;
@property(nonatomic,strong) UILabel         *subtitle;
@property(nonatomic,strong) UILabel         *date;

@property(nonatomic,strong) UIButton         *likeButton;
@property(nonatomic,strong) UILabel         *likeCount;

@property(nonatomic,strong) UIImageView     *mainImg;
@property(nonatomic,strong) NSString        *picURL;

@property(nonatomic,strong) UIView          *infoView;
@property(nonatomic,strong) UILabel         *startFromLabel;
@property(nonatomic,strong) UILabel         *minimumPrice;

@property(nonatomic, strong) UIView         *dimView;

@property(nonatomic,strong) UIView          *tagsView;

@property(nonatomic,strong) UIView          *tmpWhiteView;

@property(nonatomic,strong) UITextView      *infoBody;
@property(nonatomic,strong) UIView          *infoTri;

@property(nonatomic,strong) NSMutableArray  *infoA;
@property(nonatomic,strong) NSMutableArray  *btnsA;
@property(nonatomic,strong) NSMutableArray  *cancelImagesA;

@property(nonatomic,assign) int             cPicIndex;

@property(nonatomic,strong) UIActivityIndicatorView *spinner;


@property (nonatomic, strong)	NSMutableArray	*visiblePopTipViews;
@property (nonatomic, strong)	id				currentPopTipViewTarget;

@property (nonatomic, assign) BOOL isFeaturedEvent;

-(void)clearData;
-(void)loadData:(Event *)event;
-(void)showLoading;
-(void)hideLoading;
-(void)goPreselect;

@end
