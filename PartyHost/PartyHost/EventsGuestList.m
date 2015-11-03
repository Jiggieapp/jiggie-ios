//
//  EventsGuestList.m
//  PartyHost
//
//  Created by Sunny Clark on 2/14/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "Events.h"
#import "EventsGuestList.h"
#import "EventsGuestListCell.h"

@implementation EventsGuestList {
    NSString *lastEventId;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    lastEventId = @"";
    
    self.sharedData = [SharedData sharedInstance];
    self.mainDict = [[NSMutableDictionary alloc] init];
    self.hasMemberToLoad = NO;
    
    self.tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 77)];
    self.tabBar.backgroundColor = [UIColor phPurpleColor];
    [self addSubview:self.tabBar];
    
    self.btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnBack.frame = CGRectMake(0, 24, 50, 50);
    [self.btnBack setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [self.btnBack addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:self.btnBack];
    
    self.btnForward = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnForward.frame = CGRectMake(self.sharedData.screenWidth - 46, 26, 50, 50);
    [self.btnForward setBackgroundImage:[UIImage imageNamed:@"nav_dots"] forState:UIControlStateNormal];
    [self.btnForward addTarget:self action:@selector(hostingLocTapHandler:) forControlEvents:UIControlEventTouchUpInside];
    //[self.tabBar addSubview:self.btnForward];
    
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(40, 32, self.sharedData.screenWidth - 80, 22)];
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.textColor = [UIColor whiteColor];
    self.title.adjustsFontSizeToFitWidth = YES;
    self.title.font = [UIFont phBold:18];
    [self.tabBar addSubview:self.title];
    
    self.subtitle = [[UILabel alloc] initWithFrame:CGRectMake(30, self.title.frame.origin.y + self.title.frame.size.height -2, self.sharedData.screenWidth - 60, 20)];
    self.subtitle.font = [UIFont phBold:9];
    self.subtitle.textAlignment = NSTextAlignmentCenter;
    self.subtitle.textColor = [UIColor colorWithWhite:1 alpha:0.75];
    self.subtitle.userInteractionEnabled = NO;
    self.subtitle.backgroundColor = [UIColor clearColor];
    [self.tabBar addSubview:self.subtitle];
    
    //Create list
    self.hostersA = [[NSMutableArray alloc] init];
    self.hostersList = [[UITableView alloc] initWithFrame:CGRectMake(0, self.tabBar.frame.size.height + self.tabBar.frame.origin.y, self.sharedData.screenWidth, self.sharedData.screenHeight - (self.tabBar.frame.size.height + self.tabBar.frame.origin.y) - 50)];
    self.hostersList.delegate = self;
    self.hostersList.dataSource = self;
    self.hostersList.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.hostersList.separatorColor = [UIColor phDarkGrayColor];
    self.hostersList.allowsMultipleSelectionDuringEditing = NO;
    self.hostersList.allowsSelection = NO;
    self.hostersList.backgroundColor = [UIColor whiteColor];
    self.hostersList.hidden = YES;
    [self addSubview:self.hostersList];
    
    //Create big HOST HERE button
    self.btnHostHere = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.btnHostHere.frame = CGRectMake(0, self.hostersList.frame.size.height + self.hostersList.frame.origin.y+1, self.sharedData.screenWidth, 44);
    self.btnHostHere.titleLabel.font = [UIFont phBold:18];
    [self.btnHostHere setTitle:@"BOOK TABLE" forState:UIControlStateNormal];
    [self.btnHostHere setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnHostHere setBackgroundColor:[UIColor phLightTitleColor]];
    [self.btnHostHere addTarget:self action:@selector(hostHereButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //[self addSubview:self.btnHostHere];
    
    //Create empty label
    self.labelEmpty = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, self.sharedData.screenHeight)];
    self.labelEmpty.text = @"No guests interested yet.";
    self.labelEmpty.textAlignment = NSTextAlignmentCenter;
    self.labelEmpty.textColor = [UIColor lightGrayColor];
    self.labelEmpty.hidden = YES;
    self.labelEmpty.font = [UIFont phBlond:16];
    [self addSubview:self.labelEmpty];
    
    //Create spinner only 1st time
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.frame = CGRectMake(0, 0, self.sharedData.screenWidth, self.sharedData.screenHeight);
    self.spinner.hidden = NO;
    [self.spinner setColor:[UIColor whiteColor]];
    [self.spinner startAnimating];
    [self addSubview:self.spinner];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(refreshFeed)
     name:@"REFRESH_GUEST_LISTINGS"
     object:nil];
    
    return self;
}

//Go to the ADD HOSTING screen
-(void)hostHereButtonClicked:(UIButton *)button
{
    self.sharedData.cEventId_toLoad = self.mainDict[@"_id"];
    
    [self.sharedData.cAddEventDict removeAllObjects];
    [self.sharedData.cAddEventDict addEntriesFromDictionary:self.mainDict];
    
    [self.sharedData trackMixPanelIncrementWithDict:@{@"host_here":@1}];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_BOOKTABLE"
     object:self];
}

-(void)initClass
{
    self.sharedData.isGuestListingsShowing = YES;
    self.hostersList.contentOffset = CGPointMake(0, 0);
    self.hasMemberToLoad = (self.sharedData.cHost_index != -1);
    self.sharedData.cHost_fb_id = @"";
}

-(void)recalculateHostHere:(BOOL)on
{
    //If not hosting then show big "HOST HERE" button
    if(on==NO) //Host here!
    {
        self.btnHostHere.userInteractionEnabled = YES;
        self.btnHostHere.backgroundColor = [UIColor phPurpleColor];
        [self.btnHostHere setTitle:@"BOOK TABLE" forState:UIControlStateNormal];
    }
    else
    {
        self.btnHostHere.userInteractionEnabled = NO;
        self.btnHostHere.backgroundColor = [UIColor phLightTitleColor];
        [self.btnHostHere setTitle:@"YOU ARE HOSTING HERE" forState:UIControlStateNormal];
    }
}

-(void)hostingLocTapHandler:(UILongPressGestureRecognizer *)sender
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"EVENTS_GO_VENUE_DETAIL"
     object:self];
}

-(void)goBack
{
    self.sharedData.isGuestListingsShowing = NO;
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"EVENTS_GO_HOST_SUMMARY"
     object:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.hostersA count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"EventsGuestListCell";
    
    EventsGuestListCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[EventsGuestListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] initWithDictionary:[self.hostersA objectAtIndex:indexPath.row]];
    [cell loadData:self.mainDict userDict:userDict];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

-(void)reset
{
    NSLog(@"RESET CALLED %@ %@",lastEventId,self.event_id);
    
    if([lastEventId isEqualToString:self.event_id]) return;
    if(self.event_id!=nil) lastEventId = [NSString stringWithString:self.event_id];
    
    NSLog(@"RESET DONE");
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    self.isLoaded = NO;
    self.title.text = self.subtitle.text = @"";
    self.hostersList.hidden = YES;
    [self.hostersA removeAllObjects];
    [self.hostersList reloadData];
    
    //Start over
    self.labelEmpty.hidden = YES;
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
}

-(void)refreshFeed
{
    [self loadData:self.event_id];
}

-(void)loadData:(NSString*)event_id
{
    self.event_id = [NSString stringWithString:event_id];
    [self reset];
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    NSString *url = [Constants guestListingsURL:event_id fb_id:self.sharedData.fb_id];
    url = [NSString stringWithFormat:@"%@/event/details/%@/%@/%@",PHBaseURL,event_id,self.sharedData.fb_id,self.sharedData.gender_interest];
    
    NSLog(@"EVENTS_GUEST_LIST_URL :: %@",url);
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"EVENTS_GUEST_LIST_RESPONSE :: %@",responseObject);
         [self.sharedData trackMixPanelWithDict:@"View Guest Listings" withDict:self.sharedData.mixPanelCEventDict];
         [self populateData:responseObject];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"EVENTS_GUEST_LIST_ERROR :: %@",error);
     }];
}

-(void)populateData:(NSMutableDictionary *)dict
{
    //Store this for later use
    [self.mainDict removeAllObjects];
    [self.mainDict addEntriesFromDictionary:dict];
    
    //Set current ID
    self.event_id = [NSString stringWithString:dict[@"_id"]];
    
    //Title
    self.title.text = [dict[@"title"] uppercaseString];
    
    //Date
    //self.subtitle.text = [[Constants toTitleDate:dict[@"start_datetime_str"]] uppercaseString];
    self.subtitle.text = [[Constants toTitleDateRange:dict[@"start_datetime_str"] dbEndDateString:dict[@"end_datetime_str"]] uppercaseString];
    
    //Save list
    [self.hostersA removeAllObjects];
    [self.hostersA addObjectsFromArray:[dict objectForKey:@"guests_viewed"]];
    if([self.hostersA count] == 0) {
        self.labelEmpty.hidden = NO;
        self.hostersList.hidden = YES;
    }
    else {
        self.labelEmpty.hidden = YES;
        self.hostersList.hidden = NO;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if(![defaults objectForKey:@"SHOWED_EVENTS_GUEST_LIST_OVERLAY"])
        {
            [defaults setValue:@"YES" forKey:@"SHOWED_EVENTS_GUEST_LIST_OVERLAY"];
            [defaults synchronize];
            [self.sharedData.overlayView popup:@"Meet people" subtitle: @"Connect with guests to start chatting!" x:0 y:self.sharedData.screenHeight - 100];
        }
    }
    
    //If not hosting then show big "HOST HERE" button
    //[self recalculateHostHere:[dict[@"has_hostings"] boolValue]];
    [self recalculateHostHere:NO];
    
    [self.hostersList reloadData];
    
    //Load member
    if(self.hasMemberToLoad)
    {
        self.hasMemberToLoad = NO;
        
        dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.5);
        dispatch_after(delay, dispatch_get_main_queue(), ^(void){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.sharedData.cHost_index inSection:0];
            [self tableView:self.hostersList didSelectRowAtIndexPath:indexPath];
            self.sharedData.cHost_index = -1;
        });
    }
    
    //Prepare venue data
    [self.sharedData.eventsPage.eventsVenueDetail loadData:dict];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"HIDE_LOADING"
     object:self];
    
    self.spinner.hidden = YES;
    [self.spinner stopAnimating];
}

@end
