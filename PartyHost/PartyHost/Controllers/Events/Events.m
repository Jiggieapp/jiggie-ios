//
//  Events.m
//  PartyHost
//
//  Created by Sunny Clark on 12/26/14.
//  Copyright (c) 2014 Sunny Clark. All rights reserved.
//


#import "Events.h"
#import "AnalyticManager.h"
#import "Event.h"
#import "AppDelegate.h"
#import "BaseModel.h"
#import "UserManager.h"
#import "SVProgressHUD.h"
#import "JDFTooltips.h"
#import "JGTooltipHelper.h"
#import "JGKeyboardNotificationHelper.h"

#define SCREENS_DEEP 4

@interface Events()

@property (nonatomic, strong) JGKeyboardNotificationHelper *keyboardNotification;

@end

@implementation Events

@synthesize fetchedResultsController, managedObjectContext;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    
    self.sharedData = [SharedData sharedInstance];
    
    self.isEventsLoaded = NO;
    self.didLoadFromHostings = NO;
    self.didLoadFromInvite = NO;
    self.needUpdateContents = YES;
    
    UIView *tmpPurpleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 40)];
    tmpPurpleView.backgroundColor = [UIColor phPurpleColor];
    [self addSubview:tmpPurpleView];
    
    self.mainCon = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.sharedData.screenWidth * SCREENS_DEEP, self.sharedData.screenHeight - PHTabHeight)];

    self.mainCon.layer.masksToBounds = YES;
    
    self.whiteBK = [[UIView alloc] initWithFrame:CGRectMake(0, self.sharedData.screenHeight/2, self.sharedData.screenWidth, self.sharedData.screenHeight)];
    self.whiteBK.hidden = YES;
    self.whiteBK.backgroundColor = [UIColor whiteColor];
    
    [self.mainCon addSubview:self.whiteBK];
    
    [self addSubview:self.mainCon];
    
    UIView *purpleBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 40, frame.size.width, 34)];
    [purpleBackground setBackgroundColor:[UIColor colorFromHexCode:@"B238DE"]];
    [self.mainCon addSubview:purpleBackground];
    
    self.segmentationView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, frame.size.width, 34)];
    [self.segmentationView setBackgroundColor:[UIColor colorFromHexCode:@"B238DE"]];
    [self.mainCon addSubview:self.segmentationView];
    
    self.tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 40)];
    self.tabBar.backgroundColor = [UIColor phPurpleColor];
    [self.mainCon addSubview:self.tabBar];
    
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 40)];
    self.title.text = @"This Week";
    self.title.textColor = [UIColor whiteColor];
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.font = [UIFont phBlond:16];
    [self.tabBar addSubview:self.title];
    
    //Cancel button
    self.btnCity = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnCity.frame = CGRectMake(8, 0, 80, 40);
    self.btnCity.titleLabel.font = [UIFont phBold:13];
    self.btnCity.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.btnCity setTitle:@"JKT" forState:UIControlStateNormal];
    [self.btnCity setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnCity addTarget:self action:@selector(goToCityList) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:self.btnCity];
    
    self.btnFilter = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnFilter.frame = CGRectMake(frame.size.width - 50 + 4, 0, 40, 40);
    [self.btnFilter setImage:[UIImage imageNamed:@"filter_icon"] forState:UIControlStateNormal];
    [self.btnFilter setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    self.btnFilter.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.btnFilter addTarget:self action:@selector(showFilter) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:self.btnFilter];
    
    CGFloat buttonSegmentationWidth = frame.size.width/3;
    UIButton *todayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [todayButton setFrame:CGRectMake(0, 0, buttonSegmentationWidth, 32)];
    [todayButton setBackgroundColor:[UIColor clearColor]];
    [todayButton setTitle:@"Today" forState:UIControlStateNormal];
    [todayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[todayButton titleLabel] setFont:[UIFont phBlond:14]];
    [todayButton setTag:1];
    [todayButton addTarget:self action:@selector(segmentationButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.segmentationView addSubview:todayButton];
    
    UIButton *tomorrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tomorrowButton setFrame:CGRectMake(buttonSegmentationWidth, 0, buttonSegmentationWidth, 32)];
    [tomorrowButton setBackgroundColor:[UIColor clearColor]];
    [tomorrowButton setTitle:@"Tomorrow" forState:UIControlStateNormal];
    [tomorrowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[tomorrowButton titleLabel] setFont:[UIFont phBlond:14]];
    [tomorrowButton setTag:2];
    [tomorrowButton addTarget:self action:@selector(segmentationButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.segmentationView addSubview:tomorrowButton];
    
    UIButton *upcomingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [upcomingButton setFrame:CGRectMake(buttonSegmentationWidth * 2, 0, buttonSegmentationWidth, 32)];
    [upcomingButton setBackgroundColor:[UIColor clearColor]];
    [upcomingButton setTitle:@"Upcoming" forState:UIControlStateNormal];
    [upcomingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[upcomingButton titleLabel] setFont:[UIFont phBlond:14]];
    [upcomingButton setTag:3];
    [upcomingButton addTarget:self action:@selector(segmentationButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.segmentationView addSubview:upcomingButton];
    
    self.segmentationIndicator = [[UIView alloc] initWithFrame:CGRectMake(0, 32, buttonSegmentationWidth, 2)];
    [self.segmentationIndicator setBackgroundColor:[UIColor whiteColor]];
    [self.segmentationView addSubview:self.segmentationIndicator];
    
    self.currentSegmentationIndex = 1;
    
    self.eventsToday = [[NSMutableArray alloc] init];
    self.eventsTomorrow = [[NSMutableArray alloc] init];
    self.eventsUpcoming = [[NSMutableArray alloc] init];
    
    self.tableScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40 + 34, frame.size.width, frame.size.height - self.tabBar.bounds.size.height - self.segmentationView.bounds.size.height - 20)];
    [self.tableScrollView setBackgroundColor:[UIColor purpleColor]];
    [self.tableScrollView setContentSize:CGSizeMake(self.tableScrollView.bounds.size.width * 3, self.tableScrollView.bounds.size.height)];
    [self.tableScrollView setPagingEnabled:YES];
    [self.tableScrollView setShowsHorizontalScrollIndicator:NO];
    [self.tableScrollView setBounces:NO];
    [self.tableScrollView setDelegate:self];
    [self.mainCon addSubview:self.tableScrollView];
    
    self.events1List = [[UITableView alloc] initWithFrame:CGRectMake(self.tableScrollView.bounds.size.width * 0, 0, self.tableScrollView.bounds.size.width, self.tableScrollView.bounds.size.height)];
    self.events1List.backgroundColor = [UIColor whiteColor];
    self.events1List.delegate = self;
    self.events1List.dataSource = self;
    self.events1List.separatorColor = [UIColor clearColor];
    self.events1List.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.events1List.allowsMultipleSelectionDuringEditing = NO;
    self.events1List.showsVerticalScrollIndicator = NO;
    [self.tableScrollView addSubview:self.events1List];
    
    UIView *tmpPurple1View = [[UIView alloc] initWithFrame:CGRectMake(0, -300, self.sharedData.screenWidth, 300)];
    tmpPurple1View.backgroundColor = [UIColor phPurpleColor];
    [self.events1List addSubview:tmpPurple1View];
    
    UIRefreshControl *refreshControl1 = [[UIRefreshControl alloc] init];
    [refreshControl1 setTintColor:[UIColor whiteColor]];
    [refreshControl1 addTarget:self action:@selector(refreshControlDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.events1List addSubview:refreshControl1];
    
    UISearchBar *searchBar1 = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 44)];
    [searchBar1 setDelegate:self];
    [searchBar1 setBarTintColor:[UIColor colorFromHexCode:@"B238DE"]];
    [searchBar1 setPlaceholder:@"Search..."];
    [self.events1List setTableHeaderView:searchBar1];
    [self.events1List setContentOffset:CGPointMake(0, 44)];
    
    self.events2List = [[UITableView alloc] initWithFrame:CGRectMake(self.tableScrollView.bounds.size.width * 1, 0, self.tableScrollView.bounds.size.width, self.tableScrollView.bounds.size.height)];
    self.events2List.backgroundColor = [UIColor whiteColor];
    self.events2List.delegate = self;
    self.events2List.dataSource = self;
    self.events2List.separatorColor = [UIColor clearColor];
    self.events2List.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.events2List.allowsMultipleSelectionDuringEditing = NO;
    self.events2List.showsVerticalScrollIndicator = NO;
    [self.tableScrollView addSubview:self.events2List];
    
    UIView *tmpPurple2View = [[UIView alloc] initWithFrame:CGRectMake(0, -300, self.sharedData.screenWidth, 300)];
    tmpPurple2View.backgroundColor = [UIColor phPurpleColor];
    [self.events2List addSubview:tmpPurple2View];
    
    UIRefreshControl *refreshControl2 = [[UIRefreshControl alloc] init];
    [refreshControl2 setTintColor:[UIColor whiteColor]];
    [refreshControl2 addTarget:self action:@selector(refreshControlDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.events2List addSubview:refreshControl2];
    
    UISearchBar *searchBar2 = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 44)];
    [searchBar2 setDelegate:self];
    [searchBar2 setBarTintColor:[UIColor colorFromHexCode:@"B238DE"]];
    [searchBar2 setPlaceholder:@"Search..."];
    [self.events2List setTableHeaderView:searchBar2];
    [self.events2List setContentOffset:CGPointMake(0, 44)];
    
    self.events3List = [[UITableView alloc] initWithFrame:CGRectMake(self.tableScrollView.bounds.size.width * 2, 0, self.tableScrollView.bounds.size.width, self.tableScrollView.bounds.size.height)];
    self.events3List.backgroundColor = [UIColor whiteColor];
    self.events3List.delegate = self;
    self.events3List.dataSource = self;
    self.events3List.separatorColor = [UIColor clearColor];
    self.events3List.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.events3List.allowsMultipleSelectionDuringEditing = NO;
    self.events3List.showsVerticalScrollIndicator = NO;
    [self.tableScrollView addSubview:self.events3List];
    
    UIView *tmpPurple3View = [[UIView alloc] initWithFrame:CGRectMake(0, -300, self.sharedData.screenWidth, 300)];
    tmpPurple3View.backgroundColor = [UIColor phPurpleColor];
    [self.events3List addSubview:tmpPurple3View];
    
    UIRefreshControl *refreshControl3 = [[UIRefreshControl alloc] init];
    [refreshControl3 setTintColor:[UIColor whiteColor]];
    [refreshControl3 addTarget:self action:@selector(refreshControlDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.events3List addSubview:refreshControl3];
    
    UISearchBar *searchBar3 = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 44)];
    [searchBar3 setDelegate:self];
    [searchBar3 setBarTintColor:[UIColor colorFromHexCode:@"B238DE"]];
    [searchBar3 setPlaceholder:@"Search..."];
    [self.events3List setTableHeaderView:searchBar3];
    [self.events3List setContentOffset:CGPointMake(0, 44)];
    
    //When there are no entries
    self.emptyView = [[EmptyView alloc] initWithFrame:CGRectMake(0, 40, frame.size.width, frame.size.height - 60)];
    [self.emptyView setData:@"Oops there is a problem" subtitle:@"Sorry we're having some server issues, please check back in a few minutes." imageNamed:@""];
    [self.emptyView setMode:@"load"];
    self.emptyView.backgroundColor = [UIColor whiteColor];
    [self.mainCon addSubview:self.emptyView];
    
    self.filterView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, frame.size.width, frame.size.height - 40)];
    self.filterView.backgroundColor = [UIColor clearColor];
    self.filterView.alpha = 0.0;
    [self.mainCon addSubview:self.filterView];


    UIView *filterBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, self.filterView.bounds.size.width, self.filterView.bounds.size.height)];
    filterBGView.backgroundColor = [UIColor blackColor];
    filterBGView.alpha = 0.3;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showFilter)];
    [filterBGView addGestureRecognizer:tapRecognizer];
    [self.filterView addSubview:filterBGView];
    
    
    KTCenterFlowLayout *layout = [KTCenterFlowLayout new];
    layout.minimumInteritemSpacing = 8.f;
    layout.minimumLineSpacing = 8.f;
    
    UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - 40, 4, 22, 22)];
    [arrowView setImage:[UIImage imageNamed:@"arrow_icon"]];
    arrowView.backgroundColor = [UIColor clearColor];
    [self.filterView addSubview:arrowView];
    
    self.filterTagCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.filterTagCollection.frame = CGRectMake(6, 14, frame.size.width - 12, 120);
    [self.filterTagCollection registerClass:[SetupPickViewCell class] forCellWithReuseIdentifier:@"EventsSummaryTagCell"];
    self.filterTagCollection.delegate = self;
    self.filterTagCollection.dataSource = self;
    self.filterTagCollection.backgroundColor = [UIColor whiteColor];
    self.filterTagCollection.layer.masksToBounds = YES;
    self.filterTagCollection.layer.cornerRadius = 6;
    self.filterTagCollection.allowsMultipleSelection = YES;
    [self.filterView addSubview:self.filterTagCollection];
    
    //2nd screen
    self.eventsSummary = [[EventsSummary alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth, -20, self.sharedData.screenWidth, self.mainCon.frame.size.height)];
    [self.mainCon addSubview:self.eventsSummary];
    
    //3rd screen
    self.eventsHostingsList = [[EventsHostingsList alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth*2, -20, self.sharedData.screenWidth, self.mainCon.frame.size.height)];
    [self.mainCon addSubview:self.eventsHostingsList];
    
    //3rd screen
    self.eventsGuestList = [[EventsGuestList alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth*2, -20, self.sharedData.screenWidth, self.mainCon.frame.size.height)];
    [self.mainCon addSubview:self.eventsGuestList];
    
    //Gone
    self.eventsVenueDetail = [[EventsVenueDetail alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth * 2, -20, self.sharedData.screenWidth, self.mainCon.frame.size.height)];
    //[self.mainCon addSubview:self.eventsVenueDetail];
    
    //4th screen
    self.eventsHostDetail = [[EventsHostDetail alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth * 3, -20, self.sharedData.screenWidth, self.mainCon.frame.size.height)];
    [self.mainCon addSubview:self.eventsHostDetail];
    
    [self observeKeyboardNotification];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(goHomeNoLoad)
     name:@"EVENTS_GO_HOME"
     object:nil];
    
    //2nd screen
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(goToSummary)
     name:@"EVENTS_GO_HOST_SUMMARY"
     object:nil];
    
    //2nd screen
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(goToSummary)
     name:@"EVENTS_GO_GUEST_SUMMARY"
     object:nil];
    
    /*
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(goToVenueDetail)
     name:@"EVENTS_GO_VENUE_DETAIL"
     object:nil];
    */
    
    //3rd screen
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(goToHostList)
     name:@"EVENTS_GO_HOST_LIST"
     object:nil];
    
    //3rd screen
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(goToGuestList)
     name:@"EVENTS_GO_GUEST_LIST"
     object:nil];
    
    //4th screen
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(goToHostDetail)
     name:@"EVENTS_GO_HOST_DETAIL"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(resetApp)
     name:@"APP_UNLOADED"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(eventsTappedHandler)
     name:@"EVENTS_TAPPED"
     object:nil];
    
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self
//     selector:@selector(eventsPreSelectHandler)
//     name:@"EVENTS_PRESELECT"
//     object:nil];
    
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self
//     selector:@selector(goToInitHosting)
//     name:@"GO_TO_INIT_HOSTING"
//     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(initClass)
     name:@"REFRESH_EVENTS_FEED"
     object:nil];
    
    return self;
}


-(void)resetApp
{
    [self goHomeNoLoad];
    self.isEventsLoaded = NO;
    self.whiteBK.hidden = YES;
    self.backgroundColor = [UIColor whiteColor];
    [self.emptyView setMode:@"load"];
}

- (JGKeyboardNotificationHelper *)keyboardNotification {
    if (!_keyboardNotification) {
        _keyboardNotification = [JGKeyboardNotificationHelper new];
    }
    
    return _keyboardNotification;
}



-(void)initClass
{
    NSLog(@"EVENT_INIT_CLASS %@",(self.sharedData.isLoggedIn == YES)?@"Y":@"N");
    if(self.sharedData.isLoggedIn)
    {
        NSLog(@"EVENT_INSIDE");
        //[self.sharedData trackMixPanel:@"display_browse_events"];
        
        [[AnalyticManager sharedManager] trackMixPanelWithDict:@"View Events" withDict:@{}];
        
        if (!self.isEventsLoaded) {
            [self reloadFetch:nil];
        }
        [self removeOldEvent];
        [self loadData];
        
        NSArray *alltags = [UserManager allTags];
        if (alltags && alltags != nil) {
            self.tagArray = [NSMutableArray arrayWithArray:alltags];
        }
        [self.filterTagCollection reloadData];
        self.filterTagCollection.frame = CGRectMake(6, 14, self.sharedData.screenWidth - 12, self.filterTagCollection.collectionViewLayout.collectionViewContentSize.height);
        
        for (int i = 0; i<self.tagArray.count; i++) {
            NSString *name = [self.tagArray objectAtIndex:i];
            if ([self.sharedData.experiences containsObject:name]) {
                [self.filterTagCollection selectItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            }
        }
        
        /*
         //SHOW HOST VENUE DETAIL FROM HARE AS A TEST
        self.sharedData.cInitHosting_id = @"55d387422e351903005b8ca8";
        self.sharedData.cHostingIdFromInvite = @"55d387422e351903005b8ca8";
        self.sharedData.hasInitEventSelection = NO;
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"SHOW_HOST_VENUE_DETAIL_FROM_SHARE"
         object:self];
        */
        
        //SHOW POPUP
        if(self.sharedData.cPageIndex==0)
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if(![defaults objectForKey:@"SHOWED_EVENTS_OVERLAY"])
            {
                [defaults setValue:@"YES" forKey:@"SHOWED_EVENTS_OVERLAY"];
                [defaults synchronize];
                //[self.sharedData.overlayView popup:@"Get your night going!" subtitle: @"Tap on any event that peaks your interest." x:0 y:0];
            }
        }
    }
}

- (void)dealloc {
    [self.keyboardNotification removeObserser:self];
}

-(void)eventsTappedHandler
{
    if(self.mainCon.frame.origin.x < 0) //Not on events page
    {
        [self goHome];
    }else{ //Scroll to top
        if (self.currentSegmentationIndex == 1) {
            [self.events1List setContentOffset:CGPointMake(0, 44) animated:YES];
        } else if (self.currentSegmentationIndex == 2) {
            [self.events2List setContentOffset:CGPointMake(0, 44) animated:YES];
        } else if (self.currentSegmentationIndex == 3) {
            [self.events3List setContentOffset:CGPointMake(0, 44) animated:YES];
        }
    }
}

- (void)refreshControlDidChange:(UIRefreshControl *)refreshControl {
    self.isReloadMode = YES;
    self.refreshControl = refreshControl;
    [self loadData];
}

#pragma mark - Fetch
- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *globalManagedObjectContext = [appDelegate managedObjectContext];
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDescription =
    [NSEntityDescription entityForName:NSStringFromClass([Event class])
                inManagedObjectContext:globalManagedObjectContext];
    NSSortDescriptor *sortDescriptor =
    [NSSortDescriptor sortDescriptorWithKey:@"modified"
                                  ascending:YES];
    NSPredicate *eventPredicate = [NSPredicate predicateWithFormat:@"endDatetime > %@", [NSDate date]];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setPredicate:eventPredicate];
    
    fetchedResultsController = nil;
    fetchedResultsController = [[NSFetchedResultsController alloc]
                                initWithFetchRequest:fetchRequest
                                managedObjectContext:globalManagedObjectContext
                                sectionNameKeyPath:nil
                                cacheName:@"eventListCache"];
    [fetchedResultsController setDelegate:self];
    
    return fetchedResultsController;
}

- (BOOL)reloadFetch:(NSError **)error {
    //    NSLog(@"--- reloadAndPerformFetch");
    // delete cache
    [NSFetchedResultsController deleteCacheWithName:@"eventListCache"];
    if(fetchedResultsController){
        [fetchedResultsController setDelegate:nil];
        fetchedResultsController = nil;
    }
    
    BOOL performFetchResult = [[self fetchedResultsController] performFetch:error];
    
    if ([[self.fetchedResultsController fetchedObjects] count]>0) {
//        self.eventsList.hidden = NO;
        [self.emptyView setMode:@"hide"];
        
        [self reloadTables];
    }
    
    return performFetchResult;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
//    self.eventsList.hidden = NO;
    [self.emptyView setMode:@"hide"];
    
    if ([[self.fetchedResultsController fetchedObjects] count] == 0) {
        [self.emptyView setMode:@"empty"];
    }
    
    if (self.needUpdateContents) {
        [self reloadTables];
    }
}

- (void)removeOldEvent {
    NSPredicate *eventPredicate = [NSPredicate predicateWithFormat:@"endDatetime < %@", [NSDate date]];
    NSArray *oldEvents = [BaseModel fetchManagedObject:self.managedObjectContext
                                              inEntity:NSStringFromClass([Event class])
                                          andPredicate:eventPredicate];
    
    for (Event *oldEvent in oldEvents) {
        [self.managedObjectContext deleteObject:oldEvent];
    }
}

#pragma mark - API
-(void)loadData
{
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    //events/list/
    NSString *url = [NSString stringWithFormat:@"%@/events/list/%@",PHBaseNewURL,self.sharedData.fb_id];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *responseString = operation.responseString;
         NSError *error;
         
         NSInteger responseStatusCode = operation.response.statusCode;
         if (responseStatusCode == 204) {
             NSArray *fetchEvents = [BaseModel fetchManagedObject:self.managedObjectContext
                                                         inEntity:NSStringFromClass([Event class])
                                                     andPredicate:nil];
             self.needUpdateContents = NO;
             for (Event *fetchEvent in fetchEvents) {
                 [self.managedObjectContext deleteObject:fetchEvent];
                 
                 NSError *error;
                 if (![self.managedObjectContext save:&error]) NSLog(@"Error: %@", [error localizedDescription]);
             }
             self.needUpdateContents = YES;
             [self.emptyView setData:@"No events found" subtitle:@"Try to add more categories to see more events." imageNamed:@""];
             [self.emptyView setMode:@"empty"];
             
             if (self.isReloadMode) {
                 // Do your job, when done:
                 [self.refreshControl endRefreshing];
                 self.isReloadMode = NO;
             }
             
             return;
         } else if (responseStatusCode != 200) {
             NSArray *fetchEvents = [BaseModel fetchManagedObject:self.managedObjectContext
                                                         inEntity:NSStringFromClass([Event class])
                                                     andPredicate:nil];
             if (fetchEvents.count == 0) {
                 [self.emptyView setData:@"No events found" subtitle:@"Try to add more categories to see more events." imageNamed:@""];
                 [self.emptyView setMode:@"empty"];
             }
             
             if (self.isReloadMode) {
                 // Do your job, when done:
                 [self.refreshControl endRefreshing];
                 self.isReloadMode = NO;
             }
             
             return;
         }
         
         
         NSDictionary *json = (NSDictionary *)[NSJSONSerialization
                                               JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]
                                                            options:kNilOptions
                                                            error:&error];
         dispatch_async(dispatch_get_main_queue(), ^{
             
             if (json && json != nil) {
                 self.isEventsLoaded = YES;
                 self.whiteBK.hidden = NO;
                 self.needUpdateContents = NO;
                 
                 @try {
                     NSArray *fetchEvents = [BaseModel fetchManagedObject:self.managedObjectContext
                                                                 inEntity:NSStringFromClass([Event class])
                                                             andPredicate:nil];
                     for (Event *fetchEvent in fetchEvents) {
                         [self.managedObjectContext deleteObject:fetchEvent];
                         
                         NSError *error;
                         if (![self.managedObjectContext save:&error]) NSLog(@"Error: %@", [error localizedDescription]);
                     }
                     
                     NSDictionary *data = [json objectForKey:@"data"];
                     if (data && data != nil) {
                         NSArray *events = [data objectForKey:@"events"];
                         
                         if (!events || events.count == 0) {
                             [self.emptyView setMode:@"empty"];
                         }
                         
                         for (NSDictionary *eventRow in events) {
                             
                             BOOL isFeatured = NO;
                             if ([[eventRow objectForKey:@"date_day"] isEqualToString:@"Featured Events"]) {
                                 isFeatured = YES;
                             }
                             
                             Event *item = (Event *)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Event class])
                                                                                  inManagedObjectContext:self.managedObjectContext];
                             
                             NSString *title = [eventRow objectForKey:@"title"];
                             if (title && ![title isEqual:[NSNull null]]) {
                                 item.title = title;
                             } else {
                                 item.title = @"";
                             }
                             
                             NSString *_id = [eventRow objectForKey:@"_id"];
                             if (_id && ![_id isEqual:[NSNull null]]) {
                                 item.eventID = _id;
                             } else {
                                 item.eventID = @"";
                             }
                             
                             NSString *venue_name = [eventRow objectForKey:@"venue_name"];
                             if (venue_name && ![venue_name isEqual:[NSNull null]]) {
                                 item.venue = venue_name;
                             } else {
                                 item.venue = @"";
                             }
                             
                             NSString *start_datetime_str = [eventRow objectForKey:@"start_datetime_str"];
                             if (start_datetime_str && ![start_datetime_str isEqual:[NSNull null]]) {
                                 item.startDatetimeStr = start_datetime_str;
                             } else {
                                 item.startDatetimeStr = @"";
                             }
                             
                             NSString *fullfillment_type = [eventRow objectForKey:@"fullfillment_type"];
                             if (fullfillment_type && ![fullfillment_type isEqual:[NSNull null]]) {
                                 item.fullfillmentType = fullfillment_type;
                             } else {
                                 item.fullfillmentType = @"";
                             }
                            
                             NSNumber *likes = [eventRow objectForKey:@"likes"];
                             if (likes && ![likes isEqual:[NSNull null]]) {
                                 item.likes = likes;
                             } else {
                                 item.likes = [NSNumber numberWithInteger:0];
                             }
                             
                             NSNumber *lowest_price = [eventRow objectForKey:@"lowest_price"];
                             if (lowest_price && ![lowest_price isEqual:[NSNull null]]) {
                                 item.lowestPrice = lowest_price;
                             } else {
                                 item.lowestPrice = [NSNumber numberWithInteger:0];
                             }
                             
                             NSArray *tags = [eventRow objectForKey:@"tags"];
                             if (tags && ![tags isEqual:[NSNull null]]) {
                                 item.tags = [NSKeyedArchiver archivedDataWithRootObject:tags];
                             }
                             
                             NSArray *photos = [eventRow objectForKey:@"photos"];
                             if (photos && ![photos isEqual:[NSNull null]] && photos.count > 0) {
                                 item.photo = [photos objectAtIndex:0];
                             }
                             
                             item.isFeatured = [NSNumber numberWithBool:isFeatured];
                             
                             NSString *start_datetime = [eventRow objectForKey:@"start_datetime"];
                             NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                             [formatter setDateFormat:PHDateFormatServer];
                             [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
                             [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
                             NSDate *startDatetime = [formatter dateFromString:start_datetime];
                             if (startDatetime != nil) {
                                 item.startDatetime = startDatetime;
                             }
                             
                             NSString *end_datetime = [eventRow objectForKey:@"end_datetime"];
                             NSDate *endDatetime = [formatter dateFromString:end_datetime];
                             if (endDatetime != nil) {
                                 item.endDatetime = endDatetime;
                             }
                             
                             item.modified = [NSDate date];
                             
                             NSError *error;
                             if (![self.managedObjectContext save:&error]) NSLog(@"Error: %@", [error localizedDescription]);
                             
                         }
                     }

                 }
                 @catch (NSException *exception) {

                 }
                 @finally {
                     
                 }
                 
                 [self reloadTables];
                 
                 self.needUpdateContents = YES;
                 
             } else {
                 [self.emptyView setMode:@"empty"];
             }
         });
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if (self.isReloadMode) {
             // Do your job, when done:
             [self.refreshControl endRefreshing];
             self.isReloadMode = NO;
         }
         
         if (error.code == -1009 || error.code == -1005) {
             [SVProgressHUD showInfoWithStatus:@"Please check your internet connection"];
             return;
         }
         
         NSInteger responseStatusCode = operation.response.statusCode;
         if (responseStatusCode != 200) {
             NSArray *fetchEvents = [BaseModel fetchManagedObject:self.managedObjectContext
                                                         inEntity:NSStringFromClass([Event class])
                                                     andPredicate:nil];
             if (fetchEvents.count == 0) {
                 [self.emptyView setData:@"Oops there is a problem" subtitle:@"Sorry we're having some server issues, please check back in a few minutes." imageNamed:@""];
                 [self.emptyView setMode:@"empty"];
             }
             return;
         }
     }];
}

- (void)reloadTables {
    [self.eventsToday removeAllObjects];
    [self.eventsTomorrow removeAllObjects];
    [self.eventsUpcoming removeAllObjects];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    
    components.day = components.day + 1;
    NSDate *tomorrow = [cal dateFromComponents:components];
    
    for (Event *event in [self.fetchedResultsController fetchedObjects]) {
        components = [cal components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:event.startDatetime];
        NSDate *otherDate = [cal dateFromComponents:components];
        
        if([today isEqualToDate:otherDate]) {
            [self.eventsToday addObject:event];
        } else if([tomorrow isEqualToDate:otherDate]) {
            [self.eventsTomorrow addObject:event];
        } else {
            [self.eventsUpcoming addObject:event];
        }
    }
    
    [self.events1List reloadData];
    [self.events2List reloadData];
    [self.events3List reloadData];
    
    if (self.isReloadMode) {
        // Do your job, when done:
        [self.refreshControl endRefreshing];
        self.isReloadMode = NO;
        
        if (self.currentSegmentationIndex == 1) {
            [self.events1List setContentOffset:CGPointMake(0, 44) animated:YES];
        } else if (self.currentSegmentationIndex == 2) {
            [self.events2List setContentOffset:CGPointMake(0, 44) animated:YES];
        } else if (self.currentSegmentationIndex == 3) {
            [self.events3List setContentOffset:CGPointMake(0, 44) animated:YES];
        }
    }

    if ([[self.fetchedResultsController fetchedObjects] count] > 0) {
        [self showTooltip];
    }
}

#pragma mark - Observer
- (void)observeKeyboardNotification {
    [self.keyboardNotification handleKeyboardNotificationWithCompletion:^(UIViewAnimationOptions animation, NSTimeInterval duration, CGRect frame) {
        [UIView animateWithDuration:duration
                              delay:.4f
                            options:animation
                         animations:^{
                             
                             UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, frame.size.height, 0.0);
                             if (self.currentSegmentationIndex == 1) {
                                 self.events1List.contentInset = contentInsets;
                                 self.events1List.scrollIndicatorInsets = contentInsets;
                             } else if (self.currentSegmentationIndex == 2) {
                                 self.events2List.contentInset = contentInsets;
                                 self.events2List.scrollIndicatorInsets = contentInsets;
                             } else if (self.currentSegmentationIndex == 3) {
                                 self.events3List.contentInset = contentInsets;
                                 self.events3List.scrollIndicatorInsets = contentInsets;
                             }
    
                         } completion:nil];
    }];
    
    [self.keyboardNotification addObserser];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self endEditing:YES];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    [self changeSearchMode:YES];
    
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length > 2) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(title CONTAINS[cd] %@) or (venue CONTAINS[cd] %@)",
                                  searchText, searchText];
        NSArray *searchArray = [BaseModel fetchManagedObject:self.managedObjectContext
                                                    inEntity:NSStringFromClass([Event class])
                                                andPredicate:predicate];
        if (self.currentSegmentationIndex == 1) {
            [self.eventsToday removeAllObjects];
            if (searchArray.count > 0) {
                [self.eventsToday addObjectsFromArray:searchArray];
            }
            [self.events1List reloadData];
        } else if (self.currentSegmentationIndex == 2) {
            [self.eventsTomorrow removeAllObjects];
            if (searchArray.count > 0) {
                [self.eventsTomorrow addObjectsFromArray:searchArray];
            }
            [self.events2List reloadData];
        } else if (self.currentSegmentationIndex == 3) {
            [self.eventsUpcoming removeAllObjects];
            if (searchArray.count > 0) {
                [self.eventsUpcoming addObjectsFromArray:searchArray];
            }
            [self.events3List reloadData];
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self changeSearchMode:NO];
}

- (void)changeSearchMode:(BOOL)isSearchMode {
    self.isSearchMode = isSearchMode;
    [self.tableScrollView setScrollEnabled:!isSearchMode];
    
    if (isSearchMode) {
        [UIView animateWithDuration:0.3 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^()
         {
             self.segmentationView.frame = CGRectMake(0,
                                                      0,
                                                      self.segmentationView.bounds.size.width,
                                                      self.segmentationView.bounds.size.height);
             
             [self.tableScrollView setFrame:CGRectMake(0, 40, self.frame.size.width, self.frame.size.height - self.tabBar.bounds.size.height - 20)];
             
             [self.events1List setFrame:CGRectMake(self.tableScrollView.bounds.size.width * 0, 0, self.tableScrollView.bounds.size.width, self.tableScrollView.bounds.size.height)];
             [self.events2List setFrame:CGRectMake(self.tableScrollView.bounds.size.width * 1, 0, self.tableScrollView.bounds.size.width, self.tableScrollView.bounds.size.height)];
             [self.events3List setFrame:CGRectMake(self.tableScrollView.bounds.size.width * 2, 0, self.tableScrollView.bounds.size.width, self.tableScrollView.bounds.size.height)];
             
         } completion:^(BOOL finished){
             
         }];
    } else {
        [self endEditing:YES];
        [self reloadTables];
        
        [UIView animateWithDuration:0.3 animations:^()
         {
             if (self.currentSegmentationIndex == 1) {
                 [self.events1List setContentOffset:CGPointMake(0, 44) animated:YES];
             } else if (self.currentSegmentationIndex == 2) {
                 [self.events2List setContentOffset:CGPointMake(0, 44) animated:YES];
             } else if (self.currentSegmentationIndex == 3) {
                 [self.events3List setContentOffset:CGPointMake(0, 44) animated:YES];
             }
             
             self.segmentationView.frame = CGRectMake(0,
                                                      40,
                                                      self.segmentationView.bounds.size.width,
                                                      self.segmentationView.bounds.size.height);
             
             [self.tableScrollView setFrame:CGRectMake(0, 40 + 34, self.frame.size.width, self.frame.size.height - self.tabBar.bounds.size.height - 34 - 20)];
             
             [self.events1List setFrame:CGRectMake(self.tableScrollView.bounds.size.width * 0, 0, self.tableScrollView.bounds.size.width, self.tableScrollView.bounds.size.height)];
             [self.events2List setFrame:CGRectMake(self.tableScrollView.bounds.size.width * 1, 0, self.tableScrollView.bounds.size.width, self.tableScrollView.bounds.size.height)];
             [self.events3List setFrame:CGRectMake(self.tableScrollView.bounds.size.width * 2, 0, self.tableScrollView.bounds.size.width, self.tableScrollView.bounds.size.height)];
             
         } completion:^(BOOL finished){
             
         }];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.events1List]) {
        if (self.eventsToday.count == 0) {
            return 1;
        }
        return self.eventsToday.count;
    } else if ([tableView isEqual:self.events2List]) {
        if (self.eventsTomorrow.count == 0) {
            return 1;
        }
        return self.eventsTomorrow.count;
    } else if ([tableView isEqual:self.events3List]) {
        if (self.eventsUpcoming.count == 0) {
            return 1;
        }
        return self.eventsUpcoming.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.events1List] && self.eventsToday.count == 0) {
        return tableView.bounds.size.height;
    } else if ([tableView isEqual:self.events2List] && self.eventsTomorrow.count == 0) {
        return tableView.bounds.size.height;
    } else if ([tableView isEqual:self.events3List] && self.eventsUpcoming.count == 0) {
        return tableView.bounds.size.height;
    }
    
    CGFloat pictureHeightRatio = 3.0 / 4.0;
    CGFloat cellHeight = pictureHeightRatio * tableView.bounds.size.width + 100;
    
    
    Event *event = nil;
    if ([tableView isEqual:self.events1List]) {
        if (self.eventsToday != nil && indexPath.row < self.eventsToday.count) {
            event = [self.eventsToday objectAtIndex:indexPath.row];
        }
    } else if ([tableView isEqual:self.events2List]) {
        if (self.eventsTomorrow != nil && indexPath.row < self.eventsTomorrow.count) {
            event = [self.eventsTomorrow objectAtIndex:indexPath.row];
        }
    } else if ([tableView isEqual:self.events3List]) {
        if (self.eventsUpcoming != nil && indexPath.row < self.eventsUpcoming.count) {
            event = [self.eventsUpcoming objectAtIndex:indexPath.row];
        }
    }
    
    if (event != nil) {
        NSString *eventTitle = [event.title uppercaseString];
        
        CGRect eventTitleFrame = [eventTitle boundingRectWithSize:CGSizeMake(self.sharedData.screenWidth - 20 - 70, 70)
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{NSFontAttributeName:[UIFont phBlond:16]}
                                                         context:nil];
        
        cellHeight += eventTitleFrame.size.height;
    }
    
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.events1List] && self.eventsToday.count > 0) {
    
        static NSString *simpleTableIdentifier = @"EventsRow1Cell";
        
        EventsRowCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil)
        {
            cell = [[EventsRowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        [cell clearData];
        
        Event *event = [self.eventsToday objectAtIndex:indexPath.row];
        cell.isFeaturedEvent = [event.isFeatured boolValue];
        [cell loadData:event];
        
        return cell;
    } else if ([tableView isEqual:self.events2List] && self.eventsTomorrow.count > 0) {
        
        static NSString *simpleTableIdentifier = @"EventsRow2Cell";
        
        EventsRowCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil)
        {
            cell = [[EventsRowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        [cell clearData];
        
        Event *event = [self.eventsTomorrow objectAtIndex:indexPath.row];
        cell.isFeaturedEvent = [event.isFeatured boolValue];
        [cell loadData:event];
        
        return cell;
    } else if ([tableView isEqual:self.events3List] && self.eventsUpcoming.count > 0) {
        
        static NSString *simpleTableIdentifier = @"EventsRow3Cell";
        
        EventsRowCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil)
        {
            cell = [[EventsRowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        [cell clearData];
        
        Event *event = [self.eventsUpcoming objectAtIndex:indexPath.row];
        cell.isFeaturedEvent = [event.isFeatured boolValue];
        [cell loadData:event];
        
        return cell;
    }
    
    static NSString *emptyTableIdentifier = @"EmptyCell";
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:emptyTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:emptyTableIdentifier];
    }
    
    [[cell textLabel] setText:@"No Events Found"];
    [[cell textLabel] setFont:[UIFont phBlond:20]];
    [[cell textLabel] setTextAlignment:NSTextAlignmentCenter];
    
    return cell;
    
}


#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    [self endEditing:YES];
    
    @try {
        Event *event = nil;
        
        if ([tableView isEqual:self.events1List]) {
            if (self.eventsToday != nil && indexPath.row < self.eventsToday.count) {
                event = [self.eventsToday objectAtIndex:indexPath.row];
            }
        } else if ([tableView isEqual:self.events2List]) {
            if (self.eventsTomorrow != nil && indexPath.row < self.eventsTomorrow.count) {
                event = [self.eventsTomorrow objectAtIndex:indexPath.row];
            }
        } else if ([tableView isEqual:self.events3List]) {
            if (self.eventsUpcoming != nil && indexPath.row < self.eventsUpcoming.count) {
                event = [self.eventsUpcoming objectAtIndex:indexPath.row];
            }
        }
        
        if (event != nil) {
            [self.sharedData.selectedEvent removeAllObjects];
            self.sharedData.selectedEvent[@"_id"] = event.eventID;
            self.sharedData.selectedEvent[@"venue_name"] = event.venue;
            
            self.sharedData.cEventId = event.eventID;
            self.sharedData.mostRecentEventSelectedId = event.eventID;
            self.sharedData.cVenueName = event.venue;
            
            if([self.sharedData isGuest] && ![self.sharedData isMember])
            {
                [self.eventsSummary initClassWithEvent:event];
                
                self.eventsSummary.hidden = NO;
                self.eventsGuestList.hidden = YES;
                self.eventsHostingsList.hidden = NO;
            }
            else if([self.sharedData isHost] || [self.sharedData isMember])
            {
                [self.eventsSummary initClassWithEvent:event];
                
                self.eventsSummary.hidden = NO;
                self.eventsGuestList.hidden = NO;
                self.eventsHostingsList.hidden = YES;
            }
            
            [self goToSummary];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

#pragma mark - Segmentation
-(void)segmentationButtonDidTap:(id)sender {
    NSInteger senderTag = (NSInteger)[sender tag];
    
    if (senderTag == self.currentSegmentationIndex) {
        return;
    }
    
    self.currentSegmentationIndex = senderTag;
    
    CGFloat buttonSegmentationWidth = self.frame.size.width/3;
    
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.segmentationIndicator.frame = CGRectMake((senderTag - 1) * buttonSegmentationWidth,
                                                       self.segmentationIndicator.frame.origin.y,
                                                       self.segmentationIndicator.bounds.size.width,
                                                       self.segmentationIndicator.bounds.size.height);
         
     } completion:^(BOOL finished){
         
     }];
    
    [UIView animateWithDuration:0.5 animations:^()
     {
         [self.tableScrollView setContentOffset:CGPointMake((senderTag - 1) * self.tableScrollView.bounds.size.width, 0)];
         
     } completion:^(BOOL finished){
         
     }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.tableScrollView]) {
        CGPoint offset = scrollView.contentOffset;
        NSInteger currentPage = offset.x / scrollView.bounds.size.width;
        CGFloat buttonSegmentationWidth = self.frame.size.width/3;
        
        self.currentSegmentationIndex = currentPage + 1;
        
        [UIView animateWithDuration:0.25 animations:^()
         {
             self.segmentationIndicator.frame = CGRectMake(currentPage * buttonSegmentationWidth,
                                                           self.segmentationIndicator.frame.origin.y,
                                                           self.segmentationIndicator.bounds.size.width,
                                                           self.segmentationIndicator.bounds.size.height);
         } completion:^(BOOL finished) {
             
         }];
    }
}

#pragma mark - Tooltip
- (void)showTooltip {
    
    if (self.tooltip == nil) {
        self.tooltip = [[JDFSequentialTooltipManager alloc] initWithHostView:self];
    }
   
    if ([JGTooltipHelper isLoadEventTooltipValid]) {
        [self.tooltip addTooltipWithTargetPoint:CGPointMake(80, 200)
                                    tooltipText:@"Explore more! Tap an event to see more info and booking options."
                                 arrowDirection:JDFTooltipViewArrowDirectionUp
                                       hostView:self
                                          width:self.sharedData.screenWidth - 20];
        [self.tooltip setBackgroundColourForAllTooltips:[UIColor phBlueColor]];
        [self.tooltip setFontForAllTooltips:[UIFont phBlond:14]];
        self.tooltip.showsBackdropView = YES;
        self.tooltip.backdropTapActionEnabled = YES;
        [self.tooltip showNextTooltip];
        
        [JGTooltipHelper setLastDateShowed:@"Tooltip_LoadEvent_LastDateShowed"];
        
    } else if ([JGTooltipHelper isSocialTabTooltipValidAfter:@"Tooltip_LoadEvent_isShowed"]) {
        if (self.tooltip != nil) {
            self.tooltip = nil;
            self.tooltip = [[JDFSequentialTooltipManager alloc] initWithHostView:self];
        }
        
        [self.tooltip addTooltipWithTargetPoint:CGPointMake(self.bounds.size.width * 3/8, self.bounds.size.height)
                                    tooltipText:@"Lucky you, we found other guests who also like this event. Connect now!"
                                 arrowDirection:JDFTooltipViewArrowDirectionDown
                                       hostView:self
                                          width:self.sharedData.screenWidth - 20];
        [self.tooltip setBackgroundColourForAllTooltips:[UIColor phBlueColor]];
        [self.tooltip setFontForAllTooltips:[UIFont phBlond:14]];
        self.tooltip.showsBackdropView = YES;
        self.tooltip.backdropTapActionEnabled = YES;
        [self.tooltip showNextTooltip];
        
        [JGTooltipHelper setLastDateShowed:@"Tooltip_SocialTab_LastDateShowed"];
    }
}

#pragma mark - Filter
-(void)showFilter {
    
    if (self.isSearchMode) {
        [self changeSearchMode:NO];
    }
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        if (self.filterView.alpha == 1.0) {
            self.filterView.alpha = 0.0;
        } else {
            self.filterView.alpha = 1.0;
        }
    } completion:^(BOOL finished) {
        
    }];
}

-(void)updateFilterSetting {
    //Save settings
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    //Save settings URL
    NSString *url = [Constants memberSettingsURL];
    NSDictionary *params = [self.sharedData createSaveSettingsParams];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if(responseObject[@"response"]) {
            [self loadData];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR :: %@",error);
     }];
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.tagArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"EventsSummaryTagCell";
    SetupPickViewCell *cell = (SetupPickViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSString *title = [self.tagArray[indexPath.row] objectForKey:@"name"];
    [cell.button.button setTitle:title forState:UIControlStateNormal];
    cell.button.button.titleLabel.font = [UIFont phBold:12];
    cell.button.onTextColor = [UIColor whiteColor];
    cell.button.onBorderColor = [UIColor clearColor];
    cell.button.offTextColor = [UIColor whiteColor];
    cell.button.offBorderColor = [UIColor clearColor];
    cell.button.offBackgroundColor = [UIColor phGrayColor];
    NSString *hexColor = [self.tagArray[indexPath.row] objectForKey:@"color"];
    cell.button.onBackgroundColor = [UIColor colorFromHexCode:hexColor];
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    //Get select state now
    if ([self.sharedData.experiences containsObject:title])
    {
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        [cell.button buttonSelect:YES checkmark:YES animated:NO];
    }
    else
    {
        [cell.button buttonSelect:NO checkmark:NO animated:NO];
    }
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *title = [self.tagArray[indexPath.row] objectForKey:@"name"];
    NSDictionary *fontDict = @{NSFontAttributeName:[UIFont phBold:12]};
    CGSize stringSize = [title sizeWithAttributes:fontDict];
    
    return CGSizeMake(stringSize.width + 50,32);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SetupPickViewCell *cell = (SetupPickViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    if (![self.sharedData.experiences containsObject:cell.button.button.titleLabel.text])
        [self.sharedData.experiences addObject:cell.button.button.titleLabel.text];
    [cell.button buttonSelect:YES checkmark:YES animated:YES];
    [self updateFilterSetting];
}

- (BOOL)collectionView:(UICollectionView *)collectionView
shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.sharedData.experiences.count > 1) {
        return YES;
    }
    return NO;
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SetupPickViewCell *cell = (SetupPickViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [self.sharedData.experiences removeObject:cell.button.button.titleLabel.text];
    [cell.button buttonSelect:NO checkmark:NO animated:YES];
    [self updateFilterSetting];
}

#pragma mark - Navigations

- (void)goToCityList {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_CITY_LIST"
                                                        object:nil];
}

-(void)goHome
{
    self.sharedData.isGuestListingsShowing = NO;
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.mainCon.frame = CGRectMake(0, 20, self.sharedData.screenWidth * SCREENS_DEEP, self.sharedData.screenHeight - 20);
     } completion:^(BOOL finished)
     {
         [self loadData];
     }];
}

-(void)goHomeNoLoad
{
    self.sharedData.isGuestListingsShowing = NO;
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.mainCon.frame = CGRectMake(0, 20, self.sharedData.screenWidth * SCREENS_DEEP, self.sharedData.screenHeight - 20);
     } completion:^(BOOL finished)
     {
         
     }];
}

//2nd Screen (VENUE+LIST)
-(void)goToSummary
{
    [UIView animateWithDuration:0.25 animations:^()
    {
        self.mainCon.frame = CGRectMake(-self.sharedData.screenWidth, 20, self.sharedData.screenWidth * SCREENS_DEEP, self.sharedData.screenHeight - 20);
    } completion:^(BOOL finished)
    {
        [JGTooltipHelper setShowed:@"Tooltip_LoadEvent_isShowed"];
    }];
}


//2nd Screen (VENUE+LIST)
-(void)goToSummaryModal
{
    [UIView animateWithDuration:0 animations:^()
     {
         self.mainCon.frame = CGRectMake(-self.sharedData.screenWidth, 20, self.sharedData.screenWidth * SCREENS_DEEP, self.sharedData.screenHeight - 20);
     } completion:^(BOOL finished)
     {
     }];
}

//3rd Screen (HOST LIST)
-(void)goToHostList
{
    self.eventsGuestList.hidden = YES;
    self.eventsHostingsList.hidden = NO;
    [self.eventsHostingsList initClass];
    [self.self.eventsHostingsList loadData:self.sharedData.cEventId_Summary];
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.mainCon.frame = CGRectMake(-self.sharedData.screenWidth * 2, 20, self.sharedData.screenWidth * SCREENS_DEEP, self.sharedData.screenHeight - 20);
     } completion:^(BOOL finished)
     {
     }];
}

//3rd Screen (GUEST LIST)
-(void)goToGuestList
{
    self.eventsHostingsList.hidden = YES;
    self.eventsGuestList.hidden = NO;
    [self.eventsGuestList initClass];
    self.eventsGuestList.mainDict = [NSMutableDictionary dictionaryWithDictionary:self.sharedData.eventDict];
    [self.eventsGuestList loadData:self.sharedData.cEventId_Summary];
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.mainCon.frame = CGRectMake(-self.sharedData.screenWidth * 2, 20, self.sharedData.screenWidth * SCREENS_DEEP, self.sharedData.screenHeight - 20);
     } completion:^(BOOL finished)
     {
     }];
}

//4th Screen (HOST DETAILS)
-(void)goToHostDetail
{
    [self.eventsHostDetail initClass];
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.mainCon.frame = CGRectMake(-self.sharedData.screenWidth * 3, 20, self.sharedData.screenWidth * SCREENS_DEEP, self.sharedData.screenHeight - 20);
     } completion:^(BOOL finished)
     {
     }];
}

@end
