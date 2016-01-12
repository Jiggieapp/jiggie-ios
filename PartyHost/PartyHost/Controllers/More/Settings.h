//
//  Settings.h
//  PartyHost
//
//  Created by Tony Suriyathep on 4/14/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "More.h"
#import "Events.h"

@interface Settings : UIView<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property(strong,nonatomic) SharedData *sharedData;
@property(nonatomic,strong) UIView *mainCon;
@property(nonatomic,strong) UITableView *settingsList;
@property(nonatomic,assign) BOOL isLoaded;
@property(strong,nonatomic) UIActivityIndicatorView *spinner;

-(void)initClass;

@end