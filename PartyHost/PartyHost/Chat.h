//
//  Chat.h
//  PartyHost
//
//  Created by Sunny Clark on 12/26/14.
//  Copyright (c) 2014 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "ConvoCell.h"
#import "Messages.h"
#import "MGSwipeButton.h"
#import "MGSwipeTableCell.h"
#import "PHImage.h"

@interface Chat : UIView <UITableViewDelegate,UITableViewDataSource,MGSwipeTableCellDelegate>

@property (strong, nonatomic) SharedData    *sharedData;
@property(nonatomic,strong) NSMutableArray *conversationsA;
@property(nonatomic,strong) UITableView *conversationsList;
@property(nonatomic,assign) BOOL isConvosLoaded;
@property(nonatomic,assign) BOOL isLoading;

@property(nonatomic,assign) BOOL isInBlockMode;
@property(nonatomic,assign) BOOL isInDeleteMode;

//When there are no entries to see
@property(nonatomic,strong) EmptyView *emptyView;

-(void)initClass;
-(void)forceReload;

@end
