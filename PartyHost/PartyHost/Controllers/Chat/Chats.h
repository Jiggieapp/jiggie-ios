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

@interface Chats : UIView <UITableViewDelegate,UITableViewDataSource,MGSwipeTableCellDelegate,NSFetchedResultsControllerDelegate>{
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
}

@property (strong, nonatomic) SharedData    *sharedData;
@property(nonatomic,strong) UITableView *conversationsList;
@property(nonatomic,strong) UIView *segmentationView;
@property(nonatomic,strong) UIView *segmentationIndicator;
@property(nonatomic,assign) BOOL isConvosLoaded;
@property(nonatomic,assign) BOOL isLoading;
@property(nonatomic,assign) BOOL needUpdateContents;

@property(nonatomic,assign) BOOL isInBlockMode;
@property(nonatomic,assign) BOOL isInDeleteMode;

@property (nonatomic, assign) NSInteger currentSegmentationIndex;

//When there are no entries to see
@property(nonatomic,strong) EmptyView *emptyView;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

-(void)initClass;
-(void)forceReload;

@end
