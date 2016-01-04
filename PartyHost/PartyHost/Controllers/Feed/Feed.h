//
//  Feed.h
//  PartyHost
//
//  Created by Sunny Clark on 4/23/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Feed : UIView<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>

@property(strong,nonatomic) SharedData *sharedData;
@property(nonatomic,strong) UIView *mainCon;
@property(nonatomic,strong) UITableView *feedTable;
@property(nonatomic,strong) UILabel *title;
@property(nonatomic,strong) NSMutableArray *feedData;
@property(nonatomic,assign) BOOL isFeedLoaded;
@property(nonatomic,assign) BOOL startedPolling;
@property(nonatomic,assign) BOOL canPoll;

@property(nonatomic,strong) UIView *hideView;
@property(nonatomic,strong) UILabel *hideTitle;
@property(nonatomic,strong) UISwitch *hideToggle;
@property(nonatomic,strong) UIImageView *hideIcon;



//When there are no entries to see
@property(nonatomic,strong) EmptyView *emptyView;

-(void)initClass;
-(void)loadData;
-(void)forceReload;

@end
