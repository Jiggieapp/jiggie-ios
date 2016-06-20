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
#import "AnalyticManager.h"
#import "UIView+Animation.h"

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
    
    self.tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 60)];
    self.tabBar.backgroundColor = [UIColor phPurpleColor];
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
    
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, self.sharedData.screenWidth - 80, 40)];
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.textColor = [UIColor whiteColor];
    self.title.adjustsFontSizeToFitWidth = YES;
    self.title.font = [UIFont phBlond:16];
    self.title.text = @"Guests Interested";
    [self.tabBar addSubview:self.title];
    
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
//    self.hostersList.hidden = YES;
    self.hostersList.tableFooterView = [UIView new];
    [self addSubview:self.hostersList];
    
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

-(void)initClass
{
    self.sharedData.isGuestListingsShowing = YES;
    self.hostersList.contentOffset = CGPointMake(0, 0);
    self.hasMemberToLoad = (self.sharedData.cHost_index != -1);
    self.sharedData.cHost_fb_id = @"";
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
    
    if (self.isModal) {
        [self dismissViewAnimated:YES completion:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"EVENTS_GO_BACK"
                                                            object:self];
    }
    
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
//    return 110;
    return 80;
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
    
//    [[NSNotificationCenter defaultCenter]
//     postNotificationName:@"SHOW_LOADING"
//     object:self];
    
    self.isLoaded = NO;
//    self.hostersList.hidden = YES;
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
    if (!event_id || event_id == nil) {
        return;
    }
    
    self.event_id = [NSString stringWithString:event_id];
    [self reset];
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    NSString *url = [Constants guestListingsURL:event_id fb_id:self.sharedData.fb_id];
    url = [NSString stringWithFormat:@"%@/event/interest/%@/%@/%@",PHBaseNewURL,event_id,self.sharedData.fb_id,self.sharedData.gender_interest];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSInteger responseStatusCode = operation.response.statusCode;
         if (responseStatusCode != 200) {
             return;
         }
         
         [[AnalyticManager sharedManager] trackMixPanelWithDict:@"View Guest Listings" withDict:self.sharedData.mixPanelCEventDict];
         NSDictionary *data = [responseObject objectForKey:@"data"];
         if (data && data != nil) {
             NSMutableArray *guestsInterests = [data objectForKey:@"guest_interests"];
             if (guestsInterests && guestsInterests.count > 0) {
                 [self populateData:guestsInterests];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
     }];
}

- (void)loadModalData:(NSString *)event_id {
    [self loadData:event_id];
    self.isModal = YES;
    
    self.hostersList.frame = CGRectMake(0,
                                        self.tabBar.frame.size.height,
                                        CGRectGetWidth([UIScreen mainScreen].bounds),
                                        CGRectGetHeight([UIScreen mainScreen].bounds) - self.tabBar.frame.size.height);
}

-(void)populateData:(NSMutableArray *)array
{
    
    @try {
        //Save list
        [self.hostersA removeAllObjects];
        [self.hostersA addObjectsFromArray:array];
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
                //[self.sharedData.overlayView popup:@"Meet people" subtitle: @"Connect with guests to start chatting!" x:0 y:self.sharedData.screenHeight - 100];
            }
        }
        
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
        
        self.spinner.hidden = YES;
        [self.spinner stopAnimating];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

@end
