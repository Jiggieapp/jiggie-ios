//
//  Events.h
//  PartyHost
//
//  Created by Sunny Clark on 12/26/14.
//  Copyright (c) 2014 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventsHeader.h"
#import "EventsRowCell.h"
#import "EventsHostingsList.h"
#import "EventsGuestList.h"
#import "EventsVenueDetail.h"
#import "EventsHostDetail.h"
#import "EventsSummary.h"
#import "EventsTheme.h"
#import "PHImage.h"

@class EventsGuestList;

@class JDFSequentialTooltipManager;
@interface Events : UIView
<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIAlertViewDelegate,NSFetchedResultsControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UISearchBarDelegate> {
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
}

@property (strong, nonatomic) SharedData    *sharedData;

@property(nonatomic,strong) UIView              *tabBar;
@property(nonatomic,strong) UILabel             *title;
@property(nonatomic,strong) UIView              *mainCon;
@property(nonatomic,strong) NSMutableArray      *themeToday;
@property(nonatomic,strong) NSMutableArray      *themeTomorrow;
@property(nonatomic,strong) NSMutableArray      *themeUpcoming;
@property(nonatomic,strong) NSMutableArray      *eventsToday;
@property(nonatomic,strong) NSMutableArray      *eventsTomorrow;
@property(nonatomic,strong) NSMutableArray      *eventsUpcoming;
@property(nonatomic,strong) UIView              *segmentationView;
@property(nonatomic,strong) UIView              *segmentationIndicator;
@property(nonatomic,strong) UIScrollView        *tableScrollView;
@property(nonatomic,strong) UITableView         *events1List;
@property(nonatomic,strong) UITableView         *events2List;
@property(nonatomic,strong) UITableView         *events3List;
@property(nonatomic,strong) UIRefreshControl    *refreshControl;
@property(nonatomic,assign) BOOL                needUpdateContents;
@property(nonatomic,assign) BOOL                isEventsLoaded;
@property(nonatomic,assign) BOOL                didLoadFromHostings;
@property(nonatomic,assign) BOOL                didLoadFromInvite;
@property(nonatomic,assign) BOOL                isSearchMode;
@property(nonatomic,assign) BOOL                isReloadMode;
@property(nonatomic,strong) EventsSummary       *eventsSummary;
@property(nonatomic,strong) EventsTheme         *eventsTheme;
@property(nonatomic,strong) EventsHostingsList  *eventsHostingsList;
@property(nonatomic,strong) EventsGuestList     *eventsGuestList;
@property(nonatomic,strong) EventsVenueDetail   *eventsVenueDetail;
@property(nonatomic,strong) EventsHostDetail    *eventsHostDetail;
@property(nonatomic,copy) NSString            *cName;

@property(nonatomic,strong) JDFSequentialTooltipManager   *tooltip;

@property(nonatomic,strong) UIView              *whiteBK;

//When there are no entries to see
@property(nonatomic,strong) EmptyView *emptyView;

@property (strong, nonatomic) UIButton *btnCity;
@property (strong, nonatomic) UIButton *btnFilter;

@property (strong, nonatomic) UIView   *filterView;
@property (strong, nonatomic) UIView   *filterPopUpView;
@property (nonatomic, strong) UICollectionView *filterTagCollection;
@property (nonatomic, strong) NSMutableArray *tagArray;

@property (nonatomic, assign) NSInteger         currentSegmentationIndex;

@property (nonatomic, assign) NSInteger         nodeToHome;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, assign) BOOL hasLoadEventOnce;

-(void)initClass;
-(void)resetApp;
-(void)goToSummaryModal;

@end
