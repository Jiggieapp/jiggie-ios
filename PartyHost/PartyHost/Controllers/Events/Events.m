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


#define SCREENS_DEEP 4

@implementation Events

@synthesize fetchedResultsController, managedObjectContext;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor phPurpleColor];
    
    self.sharedData = [SharedData sharedInstance];
    
    self.cGuestListingIndexPath = nil;
    
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
    
    self.tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 40)];
    self.tabBar.backgroundColor = [UIColor phPurpleColor];
    [self.mainCon addSubview:self.tabBar];
    
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 40)];
    self.title.text = @"THIS WEEK";
    self.title.textColor = [UIColor whiteColor];
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.font = [UIFont phBold:18];
    [self.tabBar addSubview:self.title];
    
    //Cancel button
    self.btnCity = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnCity.frame = CGRectMake(8, 0, 80, 40);
    self.btnCity.titleLabel.font = [UIFont phBold:11];
    self.btnCity.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.btnCity setTitle:@"JKT" forState:UIControlStateNormal];
    [self.btnCity setTitleColor:[UIColor phLightGrayColor] forState:UIControlStateNormal];
    self.btnCity.userInteractionEnabled = NO;
    [self.tabBar addSubview:self.btnCity];
    
    self.btnFilter = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnFilter.frame = CGRectMake(frame.size.width - 50 + 4, 0, 40, 40);
    [self.btnFilter setImage:[UIImage imageNamed:@"filter_icon"] forState:UIControlStateNormal];
    [self.btnFilter setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    self.btnFilter.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.btnFilter addTarget:self action:@selector(showFilter) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:self.btnFilter];
    
    self.eventsA = [[NSMutableArray alloc] init];
    self.eventsList = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, frame.size.width, frame.size.height - self.tabBar.bounds.size.height - 20)];
    self.eventsList.backgroundColor = [UIColor clearColor];
    self.eventsList.delegate = self;
    self.eventsList.dataSource = self;
    self.eventsList.separatorColor = [UIColor clearColor];
    self.eventsList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.eventsList.allowsMultipleSelectionDuringEditing = NO;
    self.eventsList.showsVerticalScrollIndicator = NO;
    self.eventsList.hidden = YES;
    [self.mainCon addSubview:self.eventsList];
    
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
    
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(goToNextSection)
     name:@"EVENTS_GO_DOWN"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(goToPrevSection)
     name:@"EVENTS_GO_UP"
     object:nil];
    
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
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(eventsPreSelectHandler)
     name:@"EVENTS_PRESELECT"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(goToInitHosting)
     name:@"GO_TO_INIT_HOSTING"
     object:nil];
    
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
            if ([self.sharedData.experiences containsObject:[self.tagArray objectAtIndex:i]]) {
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

-(void)eventsPreSelectHandler
{
    [self tableView:self.eventsList didSelectRowAtIndexPath:self.sharedData.cHost_index_path];
}

-(void)eventsTappedHandler
{
    if(self.mainCon.frame.origin.x < 0) //Not on events page
    {
        [self goHome];
    }else{ //Scroll to top
        [self.eventsList setContentOffset:CGPointZero animated:YES];
    }
}

-(void)goToNextSection
{
    NSUInteger sectionNumber = [[self.eventsList indexPathForCell:[[self.eventsList visibleCells] objectAtIndex:0]] section];
    sectionNumber = (sectionNumber + 1 < [self.eventsA count])?sectionNumber + 1:sectionNumber;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:sectionNumber];
    [self.eventsList scrollToRowAtIndexPath:indexPath
                         atScrollPosition:UITableViewScrollPositionTop
                                 animated:YES];
}

-(void)goToPrevSection
{
    //NSUInteger sectionNumber = [[self.eventsList indexPathForCell:[[self.eventsList visibleCells] objectAtIndex:0]] section];
    //sectionNumber = (sectionNumber - 2 > -1)?sectionNumber - 2:sectionNumber;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.eventsList scrollToRowAtIndexPath:indexPath
                           atScrollPosition:UITableViewScrollPositionTop
                                   animated:YES];
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
        self.eventsList.hidden = NO;
        [self.emptyView setMode:@"hide"];
        
        [self.eventsList reloadData];
    }
    
    return performFetchResult;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    self.eventsList.hidden = NO;
    [self.emptyView setMode:@"hide"];
    
    if ([[self.fetchedResultsController fetchedObjects] count] == 0) {
        [self.emptyView setMode:@"empty"];
    }
    
    if (self.needUpdateContents) {
        [self.eventsList reloadData];
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

    NSString *url = [Constants eventsURL:@"host" fb_id:self.sharedData.fb_id];

    //events/list/
    url = [NSString stringWithFormat:@"%@/events/list/%@",PHBaseNewURL,self.sharedData.fb_id];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *responseString = operation.responseString;
         NSError *error;
         
         NSInteger responseStatusCode = operation.response.statusCode;
         if (responseStatusCode == 204) {
             NSArray *fetchEvents = [BaseModel fetchManagedObject:self.managedObjectContext
                                                         inEntity:NSStringFromClass([Event class])
                                                     andPredicate:nil];
             for (Event *fetchEvent in fetchEvents) {
                 [self.managedObjectContext deleteObject:fetchEvent];
                 
                 NSError *error;
                 if (![self.managedObjectContext save:&error]) NSLog(@"Error: %@", [error localizedDescription]);
             }
             [self.emptyView setData:@"No events found" subtitle:@"Try to add more categories to see more events." imageNamed:@""];
             [self.emptyView setMode:@"empty"];
             
             return;
         } else if (responseStatusCode != 200) {
             NSArray *fetchEvents = [BaseModel fetchManagedObject:self.managedObjectContext
                                                         inEntity:NSStringFromClass([Event class])
                                                     andPredicate:nil];
             if (fetchEvents.count == 0) {
                 [self.emptyView setData:@"No events found" subtitle:@"Try to add more categories to see more events." imageNamed:@""];
                 [self.emptyView setMode:@"empty"];
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
//                             
//                             if (self.sharedData.experiences.count == 0) {
//                                 [self.emptyView setMode:@"empty"];
//                                 break;
//                             }
                             
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
                             
                             NSString *start_datetime_str = [eventRow objectForKey:@"start_datetime_str"];
                             if (start_datetime_str && ![start_datetime_str isEqual:[NSNull null]]) {
                                 item.startDatetimeStr = start_datetime_str;
                             } else {
                                 item.startDatetimeStr = @"";
                             }
                             
                             NSString *venue_name = [eventRow objectForKey:@"venue_name"];
                             if (venue_name && ![venue_name isEqual:[NSNull null]]) {
                                 item.venue = venue_name;
                             } else {
                                 item.venue = @"";
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
                 
                 [self.eventsList reloadData];
                 self.needUpdateContents = YES;
                 
                 [self performSelector:@selector(loadImages) withObject:nil afterDelay:1.0];
                 
             } else {
                 [self.emptyView setMode:@"empty"];
             }
         });
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
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

-(void)goToInitHosting
{
    for (int k = 0; k < [self.eventsA count]; k++)
    {
        for (int l = 0; l < [[self.eventsA objectAtIndex:k][@"events"] count]; l++)
        {
            NSDictionary *dict = [[self.eventsA objectAtIndex:k][@"events"] objectAtIndex:l];
            
            for (int m = 0; m < [[dict objectForKey:@"hostings"] count]; m++)
            {
                NSDictionary *hosting = [[dict objectForKey:@"hostings"] objectAtIndex:m];
                if([hosting[@"_id"] isEqualToString:self.sharedData.cInitHosting_id])
                {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:l inSection:k];
                    [self.eventsList scrollToRowAtIndexPath:indexPath
                                           atScrollPosition:UITableViewScrollPositionTop
                                                   animated:YES];
                    self.sharedData.cHost_index_path = indexPath;
                    self.sharedData.cHost_index = m;
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:@"EVENTS_PRESELECT"
                     object:self];
                    
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:@"YES" forKey:@"init_hosting"];
                    [defaults synchronize];
                }
            }
        }
    }
}

-(void)loadImages
{
    int count = 0;
    for (Event *event in [self.fetchedResultsController fetchedObjects]) {
        if (event.photo && event.photo!=nil) {
            NSString *picURL = [self.sharedData picURL:event.photo];
            [self.sharedData loadTimeImage:picURL withTimeOut:count * .25];
        }
        count++;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.fetchedResultsController && [[self.fetchedResultsController fetchedObjects] count]>0){
        return [[self.fetchedResultsController fetchedObjects] count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat pictureHeightRatio = 3.0 / 4.0;
    CGFloat cellHeight = pictureHeightRatio  * tableView.bounds.size.width + 98;
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"EventsRowCell";
    
    EventsRowCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[EventsRowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    [cell clearData];
    
    Event *event = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    cell.isFeaturedEvent = [event.isFeatured boolValue];
    [cell loadData:event];
    
    return cell;
}


#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    self.cGuestListingIndexPath = indexPath;
    
    Event *event = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
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

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventsRowCell *eventsRowCell = (EventsRowCell*)cell;
    [eventsRowCell wentOffscreen];
}

#pragma mark - Filter
-(void)showFilter {
    
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
         if(responseObject[@"success"]) {
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
    
    NSString *title = self.tagArray[indexPath.row];
    [cell.button.button setTitle:title forState:UIControlStateNormal];
    cell.button.button.titleLabel.font = [UIFont phBold:12];
    cell.button.onTextColor = [UIColor whiteColor];
    cell.button.onBorderColor = [UIColor clearColor];
    cell.button.offTextColor = [UIColor whiteColor];
    cell.button.offBorderColor = [UIColor clearColor];
    cell.button.offBackgroundColor = [UIColor phGrayColor];
    
    if ([title isEqualToString:@"Featured"]) {
        cell.button.onBackgroundColor = [UIColor colorFromHexCode:@"D9603E"];
    } else if ([title isEqualToString:@"Music"]) {
        cell.button.onBackgroundColor = [UIColor colorFromHexCode:@"5E3ED9"];
    } else if ([title isEqualToString:@"Nightlife"]) {
        cell.button.onBackgroundColor = [UIColor colorFromHexCode:@"4A555A"];
    } else if ([title isEqualToString:@"Food & Drink"]) {
        cell.button.onBackgroundColor = [UIColor colorFromHexCode:@"DDC54D"];
    } else if ([title isEqualToString:@"Fashion"]) {
        cell.button.onBackgroundColor = [UIColor colorFromHexCode:@"68CE49"];
    } else {
        cell.button.onBackgroundColor = [UIColor colorFromHexCode:@"ED4FC4"];
    }
    
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
    
    NSString *title = self.tagArray[indexPath.row];
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
