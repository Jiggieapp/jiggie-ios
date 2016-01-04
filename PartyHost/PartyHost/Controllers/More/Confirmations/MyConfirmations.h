//
//  Hostings.h
//  PartyHost
//
//  Created by Sunny Clark on 1/1/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyConfirmationsCell.h"
#import "VenuesList.h"
#import "PHImage.h"

@interface MyConfirmations : UIView<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIAlertViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>

@property(strong,nonatomic) SharedData      *sharedData;

@property(nonatomic,strong) UIButton        *btnBack;
@property(nonatomic,strong) UILabel         *title;
@property(nonatomic,strong) UIView          *tabBar;
@property(nonatomic,strong) UIView          *mainCon;
@property(nonatomic,strong) NSMutableArray  *hostingsA;
@property(nonatomic,strong) UITableView     *hostingsList;
@property(nonatomic,assign) BOOL            isHostingsLoaded;
@property(nonatomic,assign) BOOL            isLoading;
@property(nonatomic,assign) BOOL            isVenuesListLoaded;
@property(nonatomic,assign) BOOL            hasHostings;
@property(nonatomic,assign) int             cDeleteId;
@property(nonatomic,assign) int             cEditId;

@property(nonatomic,strong) UIScrollView    *addEditCon;
@property(nonatomic,strong) PHImage         *addEditImg;
@property(nonatomic,strong) UILabel         *addEditTitle;
@property(nonatomic,strong) UILabel         *addEditSubtitle;
@property(nonatomic,strong) UIView          *addEditInivisi;
@property(nonatomic,strong) UITextField     *addEditTitleInput;
@property(nonatomic,strong) UITextField     *addEditTitleTwoInput;
@property(nonatomic,strong) UITextField     *eEditInput;
@property(nonatomic,strong) UITextView      *addEditSubtitleTextView;
@property(nonatomic,strong) UIButton        *addEditShareBtn;

@property(nonatomic,strong) NSDate          *cDate;
@property(nonatomic,strong) UILabel         *labelEmpty;

-(void)initClass;
-(void)goBack;
-(void)goQuickBack;

@end

