//
//  Events.m
//  PartyHost
//
//  Created by Sunny Clark on 12/26/14.
//  Copyright (c) 2014 Sunny Clark. All rights reserved.
//


#import "Events.h"

#define SCREENS_DEEP 4

@implementation Events

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    
    self.sharedData = [SharedData sharedInstance];

    UIView *tmpPurpleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 40)];
    tmpPurpleView.backgroundColor = [UIColor phPurpleColor];
    [self addSubview:tmpPurpleView];
    
    self.cGuestListingIndexPath = nil;
    
    self.isLoading = NO;
    self.isEventsLoaded = NO;
    self.didLoadFromHostings = NO;
    self.didLoadFromInvite = NO;
    
    
    
    
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
    self.emptyView = [[EmptyView alloc] initWithFrame:CGRectMake(0, 60, frame.size.width, frame.size.height - 60)];
    [self.emptyView setData:@"Check back soon" subtitle:@"More exciting events are coming!" imageNamed:@"tab_events"];
    [self.emptyView setMode:@"load"];
    
    //Create second version of the tab bar (incase the list is empty)
    UIView *tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, - 60, frame.size.width, 60)];
    tabBar.backgroundColor = [UIColor phPurpleColor];
    [self.emptyView addSubview:tabBar];
    
    //Create second version of the title (incase the list is empty)
    UILabel *tabTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, 20 - 60, frame.size.width-80, 40)];
    tabTitle.text = @"THIS WEEK";
    tabTitle.textAlignment = NSTextAlignmentCenter;
    tabTitle.textColor = [UIColor whiteColor];
    tabTitle.font = [UIFont phBold:18];
    [self.emptyView addSubview:tabTitle];
    
    [self addSubview:self.emptyView];
    
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
     selector:@selector(goHome)
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
    self.isLoading = NO;
    self.whiteBK.hidden = YES;
    self.backgroundColor = [UIColor whiteColor];
    [self.eventsA removeAllObjects];
    [self.eventsList reloadData];
    
    //Show loading
    [self.emptyView setMode:@"load"];
}


-(void)initClass
{
    NSLog(@"EVENT_INIT_CLASS %@-%@",(self.isLoading == YES)?@"Y":@"N",(self.sharedData.isLoggedIn == YES)?@"Y":@"N");
    if(!self.isLoading && self.sharedData.isLoggedIn)
    {
        NSLog(@"EVENT_INSIDE");
        //[self.sharedData trackMixPanel:@"display_browse_events"];
        [self loadData];
        
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

-(void)loadData 
{
    self.isLoading = YES;
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];

    NSString *url = [Constants eventsURL:@"host" fb_id:self.sharedData.fb_id];
    
    
    //events/list/
    url = [NSString stringWithFormat:@"%@/events/list/%@/%@",PHBaseURL,self.sharedData.fb_id,self.sharedData.gender_interest];
    
    NSLog(@"EVENTS_URL :: %@", url);
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         self.isLoading = NO;
         self.isEventsLoaded = YES;
         self.backgroundColor = [UIColor phPurpleColor];
         self.whiteBK.hidden = NO;
         [self.sharedData trackMixPanelWithDict:@"View Events" withDict:@{}];
         
         NSLog(@"EVENTS_RESPONSE :: %@",responseObject);
         if([[self eventsA] isEqualToArray:responseObject] && [responseObject count] > 0)
         {
             NSLog(@"SAME_DATA :: EVENTS");
             //return;
         }
         
         [self.eventsA removeAllObjects];
         [self.eventsA addObjectsFromArray:responseObject];
         [self.eventsList reloadData];
         
         [self performSelector:@selector(loadImages) withObject:nil afterDelay:1.0];
         
         //Show empty
         if(self.eventsA.count == 0) {
             self.eventsList.hidden = YES;
             [self.emptyView setMode:@"empty"];
         }
         else {
             self.eventsList.hidden = NO;
             [self.emptyView setMode:@"hide"];
         }
          /*
         if(self.sharedData.hasInitEventSelection)
         {
             //self.sharedData.cHostingIdFromInvite = dict[@"af_sub2"];
             
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"SHOW_HOST_VENUE_DETAIL_FROM_SHARE"
              object:self];
         }
         self.sharedData.hasInitEventSelection = NO;
         
     
         if(self.didLoadFromInvite)
         {
             [self preLoadForInvite];
         }
         
         if(self.didLoadFromHostings)
         {
             [self initSelectEvent];
             self.didLoadFromHostings = NO;
         }else{
             
             self.didLoadFromInvite = NO;
         }
         */
         
         if(self.sharedData.isGuestListingsShowing)
         {
             NSLog(@"GUEST_LISTINGS_SHOWING.....");
             //[self.eventsList selectRowAtIndexPath:self.cGuestListingIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
             [self tableView:self.eventsList didSelectRowAtIndexPath:self.cGuestListingIndexPath];
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR :: %@",error);
     }];
}


-(void)initSelectEvent
{
    for (int i = 0; i < [self.eventsA count]; i++)
    {
        NSMutableArray *dictSection = [self.eventsA objectAtIndex:i][@"events"];
        for (int j = 0; j < [dictSection count]; j++)
        {
            NSMutableDictionary *dict = [dictSection objectAtIndex:j];
            if([dict[@"_id"] isEqualToString:self.sharedData.mostRecentEventSelectedId])
            {
                self.sharedData.cHostingIdFromInvite =  dict[@"hosting_id"];
            }
        }
    }
    self.didLoadFromInvite = YES;
    //self.sharedData.cHostingIdFromInvite
    //[self preInvite];
    [self performSelector:@selector(preInvite) withObject:nil afterDelay:1.0];
}


-(void)preLoadForInvite
{
    int section = 0;
    int row = 0;
    for (int i = 0; i < [self.eventsA count]; i++)
    {
        NSMutableArray *dictSection = [self.eventsA objectAtIndex:i][@"events"];
        for (int j = 0; j < [dictSection count]; j++)
        {
            NSMutableDictionary *dict = [dictSection objectAtIndex:j];
            if([dict[@"_id"] isEqualToString:self.sharedData.mostRecentEventSelectedId])
            {
                section = i;
                row = j;
            }
        }
    }
    
    NSIndexPath *path =[NSIndexPath indexPathForRow:row inSection:section];
    [self tableView:self.eventsList didSelectRowAtIndexPath:path];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"HIDE_LOADING"
     object:self];
    
    NSString *name = [NSString stringWithFormat:@"You have invited %@ to your hosting.",[self.sharedData.cInviteName capitalizedString]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invite Sent" message:name delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

-(void)preInvite
{
    NSLog(@"PRE_INVITE");
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];

    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    NSLog(@"self.sharedData.cHostingIdFromInvite :: %@",self.sharedData.cHostingIdFromInvite);
    
    NSDictionary *params = @{
                             @"from_fb_id": self.sharedData.fb_id,
                             @"event_id": self.sharedData.cEventId
                             };
    
    NSLog(@"PREINVITE_PARAMS :: %@",params);
    
    NSString *url = [NSString stringWithFormat:@"%@/user/hostings/invited/%@/%@",PHBaseURL,self.sharedData.cGuestId,self.sharedData.cHostingIdFromInvite];
    NSLog(@"PREINVITE_URL :: %@",url);
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         self.didLoadFromInvite = YES;
         //[self loadData];
         //[self performSelector:@selector(loadData) withObject:nil afterDelay:2.0];
         [self.sharedData trackMixPanelWithDict:@"Sent Event Invite" withDict:@{@"origin":@"guestlisting"}];
         
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"REFRESH_GUEST_LISTINGS"
          object:self];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR_INVITING_GUEST :: %@",operation.response);
         NSLog(@"error: %@",  operation.responseString);
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
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
    for (int i = 0; i < [self.eventsA count]; i++)
    {
        for (int j = 0; j < [[self.eventsA objectAtIndex:i][@"events"] count]; j++)
        {
            NSDictionary *dict = [[self.eventsA objectAtIndex:i][@"events"] objectAtIndex:j];
            NSString *picURL = [Constants eventImageURL:dict[@"_id"]];
            NSLog(@"EVENT_IMG_URL :: %@ - %@",picURL, dict[@"venue_name"]);
            
            @try {
                picURL = [self.sharedData picURL:dict[@"photos"][0]];
            }
            @catch (NSException *exception) {
                NSLog(@"CRASH EVENT_IMG_URL :: %@ - %@",picURL, dict[@"venue_name"]);
            }
            @finally {
                
            }
            
            
            //[self.sharedData loadImageCue:picURL];
            [self.sharedData loadTimeImage:picURL withTimeOut:count * .25];
            count++;
        }
    }
}

-(void)successSelector
{
    
}

-(void)failureSelector
{
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.isEventsLoaded == YES) return [self.eventsA count];
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.isEventsLoaded == YES) return [[self.eventsA objectAtIndex:section][@"events"] count];
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat pictureHeightRatio = 3.0 / 4.0;
    CGFloat cellHeight = pictureHeightRatio  * tableView.bounds.size.width + 98;
    return cellHeight;
}

/*
 //TONY:  I'm trying to preload images here, but prob not right
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *dictSection = [self.eventsA objectAtIndex:indexPath.section][@"events"];
    NSDictionary *dict = [dictSection objectAtIndex:indexPath.row];
    
    [self.sharedData loadImageCue:[Constants eventImageURL:dict[@"_id"]]];
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"EventsRowCell";
    
    EventsRowCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[EventsRowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSMutableArray *dictSection = [self.eventsA objectAtIndex:indexPath.section][@"events"];
    NSDictionary *dict = [dictSection objectAtIndex:indexPath.row];
    
    [cell clearData];
    
    if ([[self.eventsA objectAtIndex:indexPath.section][@"date_day"] isEqualToString:@"Featured Events"])
    {
        cell.isFeaturedEvent = YES;
    } else
    {
        cell.isFeaturedEvent = NO;
    }
    
    [cell loadData:dict];
    
    return cell;
}


#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    if(!self.isEventsLoaded || [self.eventsA count] == 0)
    {
        return;
    }
    
    self.cGuestListingIndexPath = indexPath;
    
    NSMutableArray *dictSection = [self.eventsA objectAtIndex:indexPath.section][@"events"];
    NSDictionary *dict = [dictSection objectAtIndex:indexPath.row];
    
    [self.sharedData.selectedEvent removeAllObjects];
    [self.sharedData.selectedEvent addEntriesFromDictionary:dict];
    
    self.sharedData.cEventsDatesStrg = self.eventsA[indexPath.section][@"date_full"];
    self.sharedData.cEventId = dict[@"_id"];
    self.sharedData.mostRecentEventSelectedId = dict[@"_id"];;
    self.sharedData.cVenueName = dict[@"venue_name"];
    if([self.sharedData isGuest] && ![self.sharedData isMember])
    {
        [self.eventsSummary initClass];
        [self.eventsSummary loadData:dict[@"_id"]];
        
        self.eventsSummary.hidden = NO;
        self.eventsGuestList.hidden = YES;
        self.eventsHostingsList.hidden = NO;
    }
    else if([self.sharedData isHost] || [self.sharedData isMember])
    {
        NSLog(@"eventsSummary_eventsSummary");
        [self.eventsSummary initClass];
        [self.eventsSummary loadData:dict[@"_id"]];
        
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

#pragma mark - Navigations

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
    [self.self.eventsHostingsList loadData:self.sharedData.eventDict[@"_id"]];
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
    [self.eventsGuestList loadData:self.sharedData.eventDict[@"_id"]];
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

-(void)askAboutInvite
{
    //[self preInvite];
    //self.didLoadFromHostings = YES;
    [self performSelector:@selector(preInvite) withObject:nil afterDelay:1.0];
    NSLog(@"ASK_ABOUTPRE_INVITE");
}

@end
