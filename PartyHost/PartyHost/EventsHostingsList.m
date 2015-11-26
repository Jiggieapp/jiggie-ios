//
//  EventsHostingsList.m
//  PartyHost
//
//  Created by Sunny Clark on 2/14/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "Events.h"
#import "EventsHostingsList.h"


@implementation EventsHostingsList {
    NSString *lastEventId;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    
    self.sharedData = [SharedData sharedInstance];
    self.mainDict = [[NSMutableDictionary alloc] init];
    self.hasMemberToLoad = NO;
    
    lastEventId = @"";
    
    self.tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 77)];
    self.tabBar.backgroundColor = [UIColor phLightTitleColor];
    [self addSubview:self.tabBar];
    
    self.btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnBack.frame = CGRectMake(0, 20, 40, 40);
    [self.btnBack setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [self.btnBack setImageEdgeInsets:UIEdgeInsetsMake(8, 14, 8, 14)];
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
    self.hostersList = [[UITableView alloc] initWithFrame:CGRectMake(0, self.tabBar.frame.size.height + self.tabBar.frame.origin.y, self.sharedData.screenWidth, self.sharedData.screenHeight - (self.tabBar.frame.size.height + self.tabBar.frame.origin.y)-50 )];
    self.hostersList.delegate = self;
    self.hostersList.dataSource = self;
    self.hostersList.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.hostersList.separatorColor = [UIColor phDarkBodyInactiveColor];
    self.hostersList.allowsMultipleSelectionDuringEditing = NO;
    self.hostersList.allowsSelection = YES;
    self.hostersList.backgroundColor = [UIColor phDarkBodyColor];
    self.hostersList.hidden = YES;
    [self addSubview:self.hostersList];
    
    //Create empty label
    self.labelEmpty = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, self.sharedData.screenHeight)];
    self.labelEmpty.text = @"No hosts for this event yet.";
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
     name:@"REFRESH_HOST_LISTINGS"
     object:nil];
    
    return self;
}


-(void)refreshFeed
{
    [self loadData:self.event_id];
}


-(void)initClass
{
    self.hostersList.contentOffset = CGPointMake(0, 0);
    self.hasMemberToLoad = (self.sharedData.cHost_index != -1);
    self.sharedData.cHost_fb_id = @"";
}

-(void)reset
{
    if([lastEventId isEqualToString:self.event_id]) return;
    if(self.event_id!=nil) lastEventId = [NSString stringWithString:self.event_id];
    
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

-(void)loadData:(NSString*)event_id
{
    self.event_id = [NSString stringWithString:event_id];
    [self reset];
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    NSString *url = [Constants hostListingsURL:event_id fb_id:self.sharedData.fb_id];
    
    NSLog(@"EVENTS_HOSTINGS_LIST_URL :: %@",url);
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"EVENTS_HOSTINGS_LIST_RESPONSE :: %@",responseObject);
         
         [self.sharedData trackMixPanelWithDict:@"View Host Listings" withDict:self.sharedData.mixPanelCEventDict];
         
         [self populateData:responseObject];
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"EVENTS_HOSTINGS_LIST_ERROR :: %@",error);
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
     }];
}

-(void)populateData:(NSDictionary *)dict
{
    //Save event data
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
    [self.hostersA addObjectsFromArray:[dict objectForKey:@"hosters"]];
    if([self.hostersA count] == 0) {
        self.labelEmpty.hidden = NO;
        self.hostersList.hidden = YES;
    }
    else {
        self.labelEmpty.hidden = YES;
        self.hostersList.hidden = NO;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if(![defaults objectForKey:@"SHOWED_EVENTS_HOST_LIST_OVERLAY"])
        {
            [defaults setValue:@"YES" forKey:@"SHOWED_EVENTS_HOST_LIST_OVERLAY"];
            [defaults synchronize];
            
            [self.sharedData.overlayView popup:@"Find a host" subtitle: @"Tap on a hosting to get details on the offering." x:0 y:130];
        }
    }
    
    //Get hostings
    [self.hostersList reloadData];
    
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
    
    //Save this?
    [self.sharedData.eventsPage.eventsVenueDetail loadData:dict];
    self.sharedData.cVenueName = dict[@"venue_name"];
    self.sharedData.cHostVenuePicURL = [Constants eventImageURL:dict[@"_id"]]; //Need for SHARE HOSTING
    
    self.isLoaded = YES;
    
    self.spinner.hidden = YES;
    [self.spinner stopAnimating];
}

-(void)hostingLocTapHandler:(UILongPressGestureRecognizer *)sender
{
    //Not ready
    if(self.isLoaded==NO)
    {
        return;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"EVENTS_GO_VENUE_DETAIL"
     object:self];
}


-(void)goBack
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"EVENTS_GO_GUEST_SUMMARY"
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
    return 120-8;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"EventsHostingsListCell";
    
    EventsHostingsListCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[EventsHostingsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSMutableDictionary *userDict = [self.hostersA objectAtIndex:indexPath.row];
    [cell loadData:self.mainDict userDict:userDict];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    NSMutableDictionary *dict = [self.hostersA objectAtIndex:indexPath.row];
    
    //Store host dict
    [self.sharedData.selectedHost removeAllObjects];
    [self.sharedData.selectedHost addEntriesFromDictionary:dict];
    
    //Store member host fb_id
    self.sharedData.member_fb_id = self.sharedData.selectedHost[@"fb_id"];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"EVENTS_GO_HOST_DETAIL"
     object:self];
}

@end
