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

@interface Chats : UIView <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,MGSwipeTableCellDelegate,NSFetchedResultsControllerDelegate>{
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
}

@property (strong, nonatomic) SharedData    *sharedData;
@property(nonatomic,strong) UIScrollView *tableScrollView;
@property(nonatomic,strong) UITableView *conversationsList;
@property(nonatomic,strong) UITableView *friendsList;
@property(nonatomic,strong) UIView *segmentationView;
@property(nonatomic,strong) UIView *segmentationIndicator;
@property(nonatomic,assign) BOOL isConvosLoaded;
@property(nonatomic,assign) BOOL isChatFirstLoad;
@property(nonatomic,assign) BOOL isFriendFirstLoad;
@property(nonatomic,assign) BOOL needUpdateContents;

@property(nonatomic,assign) BOOL isInBlockMode;
@property(nonatomic,assign) BOOL isInDeleteMode;

@property (nonatomic, assign) NSInteger currentSegmentationIndex;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSArray *friends;

-(void)initClass;
-(void)forceReload;

@end
