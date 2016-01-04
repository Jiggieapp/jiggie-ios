//
//  EventsHostingsList.h
//  PartyHost
//
//  Created by Sunny Clark on 2/14/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventsHostingsListCell.h"
#import "AsyncImageView.h"
#import "PHImage.h"

@interface EventsHostingsList : UIView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) SharedData *sharedData;

//Nav top
@property(nonatomic,strong) UILabel *title;
@property(nonatomic,strong) UILabel *subtitle;
@property(nonatomic,strong) UIView *tabBar;
@property(nonatomic,strong) UIButton *btnBack;
@property(nonatomic,strong) UIButton *btnForward;

//Should only be seen once
@property(nonatomic,strong) UILabel *labelEmpty;
@property(nonatomic,strong) UIActivityIndicatorView *spinner;

@property(nonatomic,strong) NSMutableArray *hostersA;
@property(nonatomic,strong) UITableView *hostersList;
@property(nonatomic,strong) NSMutableDictionary *mainDict;
@property(nonatomic,assign) BOOL hasMemberToLoad;
@property(nonatomic,assign) BOOL isLoaded;
@property(nonatomic,strong) NSString *dateStrg;
@property(nonatomic,strong) NSString *event_id;

-(void)initClass;
-(void)reset;
-(void)loadData:(NSString*)event_id;
-(void)populateData:(NSDictionary*)dict;

@end