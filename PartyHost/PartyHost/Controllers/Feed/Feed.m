//
//  Feed.m
//  PartyHost
//
//  Created by Sunny Clark on 4/23/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "Feed.h"
#import "FeedCell.h"
#import "AnalyticManager.h"
#import "SVProgressHUD.h"


#define POLL_SECONDS 25

@implementation Feed

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    self.sharedData = [SharedData sharedInstance];
    self.sharedData.feedPage = self;
    self.isFeedLoaded = NO;
    self.startedPolling = NO;
    self.canPoll = YES;
    
    //Set up data
    self.feedData = [[NSMutableArray alloc] init];
    
    //Main container
    self.mainCon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width * 3, frame.size.height)];
    [self addSubview:self.mainCon];
    
    //Create tab bar
    UIView *tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 60)];
    tabBar.backgroundColor = [UIColor phPurpleColor];
    
    //Create title
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, frame.size.width-80, 40)];
    self.title.text = @"SOCIAL";
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.textColor = [UIColor whiteColor];
    self.title.font = [UIFont phBold:18];
    
    self.hideView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tabBar.frame) + 10, self.sharedData.screenWidth, 40)];
    self.hideView.backgroundColor = [UIColor clearColor];
    [self.mainCon addSubview:self.hideView];
    self.hideView.hidden = YES;
    
    self.hideIcon = [[UIImageView alloc] initWithFrame:CGRectMake(14, 14, 30, 20)];
    self.hideIcon.image = [UIImage imageNamed:@"discover_off.png"];
    [self.hideView addSubview:self.hideIcon];
    
    self.hideTitle = [[UILabel alloc] initWithFrame:CGRectMake(56, 14, frame.size.width-80, 20)];
    self.hideTitle.text = @"Socialize";
    self.hideTitle.textColor = [UIColor blackColor];
    self.hideTitle.font = [UIFont phBlond:17];
    [self.hideView addSubview:self.hideTitle];
    
    self.hideSubtitle = [[UILabel alloc] initWithFrame:CGRectMake(18, 50, frame.size.width-36, 20)];
    self.hideSubtitle.text = @"Turn off if you do not wish to be seen by others";
    self.hideSubtitle.textColor = [self.sharedData colorWithHexString:@"5c5c5c"];
    self.hideSubtitle.font = [UIFont phBlond:15];
    [self.hideSubtitle setAdjustsFontSizeToFitWidth:YES];
    [self.hideView addSubview:self.hideSubtitle];
    
    // hide if iphone 4 due to screen limitation
    if(self.sharedData.isIphone4)
    {
        self.hideSubtitle.hidden = YES;
    }
    
    self.hideToggle = [[UISwitch alloc] initWithFrame:CGRectZero];
    self.hideToggle.frame = CGRectMake(self.sharedData.screenWidth - self.hideToggle.bounds.size.width - 14,
                                       8,
                                       self.hideToggle.bounds.size.width,
                                       self.hideToggle.bounds.size.height);
    [self.hideToggle setOnTintColor:[UIColor phBlueColor]];
    [self.hideToggle addTarget:self action:@selector(hideToggleHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.hideView addSubview:self.hideToggle];
    
    //Create table
    self.feedTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.sharedData.screenHeight - self.sharedData.feedCellHeightLong - 60 - 3, frame.size.width, frame.size.height - 50 - self.hideView.frame.size.height)];
    self.feedTable.delegate = self;
    self.feedTable.dataSource = self;
    self.feedTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.feedTable.allowsMultipleSelectionDuringEditing = NO;
    self.feedTable.backgroundColor = [UIColor clearColor];
    self.feedTable.hidden = YES;
    self.feedTable.scrollEnabled = NO;
    [self.mainCon addSubview:self.feedTable];
    
    [tabBar addSubview:self.title];
    [self.mainCon addSubview:tabBar];
    
    //When there are no entries
    self.emptyView = [[EmptyView alloc] initWithFrame:CGRectMake(0, 60, frame.size.width, frame.size.height - 60)];
    [self.emptyView setMode:@"load"];
    [self addSubview:self.emptyView];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(feedTappedHandler)
     name:@"FEED_TAPPED"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(startPolling)
     name:@"APP_LOADED"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(stopPolling)
     name:@"APP_UNLOADED"
     object:nil];
    
    return self;
}

-(void)hideToggleHandler
{
    NSLog(@"TOUCHED!!!");
    
    if(self.sharedData.matchMe)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Turn off socialize?"
                                                        message:@"while turned off, your profile card won't be shown to other users."
                                                       delegate:self
                                              cancelButtonTitle:@"Go Invisible"
                                              otherButtonTitles:@"Cancel",nil];
        [alert show];
    }else{
        [self toggleMatch];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"C_INDEX :: %ld",(long)buttonIndex);
    if(buttonIndex==0)
    {
        [self toggleMatch];
    } else {
        [self.hideToggle setOn:self.sharedData.matchMe];
        if (self.sharedData.matchMe) {
            self.hideIcon.image = [UIImage imageNamed:@"discover_on.png"];
            self.hideSubtitle.text = @"Turn off if you do not wish to be seen by others";
        } else {
            self.hideIcon.image = [UIImage imageNamed:@"discover_off.png"];
            self.hideSubtitle.text = @"Turn on if you wish to be seen by others";
        }
    }
}


-(void)toggleMatch
{
    self.sharedData.matchMe = !self.sharedData.matchMe;
    NSString *matchMe = (self.sharedData.matchMe == YES)?@"yes":@"no";
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    NSString *url = [NSString stringWithFormat:@"%@/partyfeed/settings/%@/%@",PHBaseURL,self.sharedData.fb_id,matchMe];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    NSLog(@"Match_URL :: %@",url);
    
    [manager GET:url parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Match_responseObject :: %@",responseObject);
         
         [self.hideToggle setOn:self.sharedData.matchMe];
         if (self.sharedData.matchMe) {
             self.hideIcon.image = [UIImage imageNamed:@"discover_on.png"];
             self.hideSubtitle.text = @"Turn off if you do not wish to be seen by others";
         } else {
             self.hideIcon.image = [UIImage imageNamed:@"discover_off.png"];
             self.hideSubtitle.text = @"Turn on if you wish to be seen by others";
         }
         
         self.feedTable.hidden = !(self.sharedData.matchMe);
         self.sharedData.feedBadge.hidden = !(self.sharedData.matchMe);
         self.sharedData.feedBadge.canShow = self.sharedData.matchMe;
         
         if(self.sharedData.matchMe)
         {
             self.isFeedLoaded = NO;
             [self loadData];
         }
         
         [[AnalyticManager sharedManager] trackMixPanelWithDict:@"Socialize Toggle" withDict:@{@"toggle":matchMe}];
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Match_FAIL_responseObject :: %@",operation.responseString);
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
     }];
}

-(void)feedTappedHandler
{
    [self.feedTable setContentOffset:CGPointZero animated:YES];
}

//This brings the spinner back and forces reload of everything
-(void)forceReload
{
    self.isFeedLoaded = NO;
    
    //Clear table
    [self.feedData removeAllObjects];
    [self.feedTable setContentOffset:CGPointZero animated:YES];
    [self.feedTable reloadData];
    
    //Show loading
    [self.emptyView setMode:@"load"];
}

-(void)startPolling
{
    if(self.canPoll && self.startedPolling == NO)
    {
        self.startedPolling = YES;
        if(!self.sharedData.isInFeed)
        {
            [self loadData];
        }
        [self performSelector:@selector(startPolling) withObject:nil afterDelay:POLL_SECONDS];
    }
}

-(void)stopPolling
{
    self.canPoll = NO;
    [self forceReload];
}

-(void)initClass
{
    
    [self.hideToggle setOn:self.sharedData.matchMe];
    if (self.sharedData.matchMe) {
        self.hideIcon.image = [UIImage imageNamed:@"discover_on.png"];
        self.hideSubtitle.text = @"Turn off if you do not wish to be seen by others";
    } else {
        self.hideIcon.image = [UIImage imageNamed:@"discover_off.png"];
        self.hideSubtitle.text = @"Turn on if you wish to be seen by others";
    }
    
    self.feedTable.hidden = !(self.sharedData.matchMe);
    self.sharedData.feedBadge.hidden = !(self.sharedData.matchMe);
    self.sharedData.feedBadge.canShow = self.sharedData.matchMe;
    /*
    self.sharedData.unreadFeedCount = 0;
    [self.sharedData.feedBadge updateValue:0];
    [self.sharedData updateBadgeIcon];
     */
    
    //[self.sharedData trackMixPanel:@"feed_tab"];
    [self loadData];
    
    //Special messages for guest and host
    [self.emptyView setData:@"Check back soon" subtitle:@"Browse some events and your social feed will show members who like the same events." imageNamed:@"PickIcon"];
}

-(void)loadData
{
    if (self.sharedData.fb_id == nil || [self.sharedData.fb_id isEqualToString:@""]) {
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    NSString *url = [NSString stringWithFormat:@"%@/partyfeed/list/%@/%@",PHBaseNewURL,self.sharedData.fb_id,self.sharedData.gender_interest];
    
    
    NSLog(@"FEED START LOAD :: %@",url);
    
    [manager GET:url parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         NSInteger responseStatusCode = operation.response.statusCode;
         if (responseStatusCode == 204) {
             self.startedPolling = NO;
             [self performSelector:@selector(startPolling) withObject:nil afterDelay:POLL_SECONDS];
             return;
             
         } else if (responseStatusCode != 200) {
             self.startedPolling = NO;
             [self performSelector:@selector(startPolling) withObject:nil afterDelay:POLL_SECONDS];
             return;
         }
         
         @try {
             
             NSDictionary *data = [responseObject objectForKey:@"data"];
             if (data && data != nil) {
                 NSArray *social_feeds = [data objectForKey:@"social_feeds"];
                 
                 if (!social_feeds || social_feeds == 0) {
                     NSLog(@"FEED FAILED! >>> %@",responseObject);
                     self.startedPolling = NO;
                     [self performSelector:@selector(startPolling) withObject:nil afterDelay:POLL_SECONDS];
                     return;
                 }
                 
                 //Check if already equal
                 if([self.feedData isEqualToArray:social_feeds] && self.isFeedLoaded == YES && !self.sharedData.isInFeed)
                 {
                     NSLog(@"FEED_SAME_DATA");
                     self.startedPolling = NO;
                     [self performSelector:@selector(startPolling) withObject:nil afterDelay:POLL_SECONDS];
                     return;
                 }
                 
                 if(self.sharedData.isInFeed)
                 {
                     
                     NSString *val = @"";
                     if([self.sharedData.ABTestChat isEqualToString:@"YES"])
                     {
                         val = @"Connect";
                     }else{
                         val = @"Chat";
                     }
                     
                     NSMutableDictionary *paramsToSend = [[NSMutableDictionary alloc] init];
                     [paramsToSend setObject:val forKey:@"ABTestChat"];
                     
                     if([self.feedData count] > 0)
                     {
                         [paramsToSend setObject:[self.feedData objectAtIndex:0][@"type"] forKey:@"feed_item_type"];
                         [[AnalyticManager sharedManager] trackMixPanelWithDict:@"View Feed Item" withDict:paramsToSend];
                     }
                 }
                 
                 //Clear table
                 [self.feedData removeAllObjects];
                 [self.feedData addObjectsFromArray:social_feeds];
                 
                 //Reload table view
                 [self.feedTable reloadData];
                 
                 int count = 0;
                 for (NSDictionary *feed in self.feedData) {
                     if ([[feed objectForKey:@"type"] isEqualToString:@"approved"]) {
                         count++;
                     }
                 }
                 
                 //Mark that its loaded
                 self.isFeedLoaded = YES;
                 self.sharedData.unreadFeedCount = count;
                 [self.sharedData.feedBadge updateValue:self.sharedData.unreadFeedCount];
                 self.sharedData.feedBadge.hidden = !(self.sharedData.matchMe);
                 self.sharedData.feedBadge.canShow = self.sharedData.matchMe;
                 
                 
                 //Show empty
                 if(self.feedData.count == 0) {
                     self.hideView.hidden = YES;
                     self.feedTable.hidden = YES;
                     [self.emptyView setMode:@"empty"];
                 } else {
                     [[AnalyticManager sharedManager] trackMixPanelWithDict:@"New Feed Item" withDict:@{}];
                     
                     self.hideView.hidden = NO;
                     self.feedTable.hidden = !(self.sharedData.matchMe);;
                     [self.emptyView setMode:@"hide"];
                 }
                 
                 /*
                  //If we are on the page then clear out badge
                  if(self.sharedData.cPageIndex==2)
                  {
                  self.sharedData.unreadFeedCount = 0;
                  [self.sharedData.feedBadge updateValue:0];
                  }
                  */
                 
                 [self.sharedData updateBadgeIcon];
             }
         }
         @catch (NSException *exception) {
             
         }
         @finally {
             
         }
         
         //Hide spinner
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
         self.startedPolling = NO;
         [self performSelector:@selector(startPolling) withObject:nil afterDelay:POLL_SECONDS];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR :: %@",error);
         
         if (self.sharedData.isInFeed && (error.code == -1009 || error.code == - 1005)) {
             [SVProgressHUD showInfoWithStatus:@"Please check your internet connection"];
         }
         
         self.startedPolling = NO;
         //[self performSelector:@selector(startPolling) withObject:nil afterDelay:POLL_SECONDS];
         //Show no connection label
         //self.labelEmpty.hidden = NO;
         //self.labelEmpty.text = @"No Connection";
         
         /*
         //Alert error!
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Connection"
                                                         message:@"Feed could not be loaded."
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
         [alert show];
          */
     }];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([self.feedData count] > 0)?1:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data = [self.feedData objectAtIndex:indexPath.row];
    NSString* typeCell = data[@"type"];
    
    if([typeCell isEqualToString:@"login"] || [typeCell isEqualToString:@"signedup"]) {return self.sharedData.feedCellHeightShort;}
    
    return self.sharedData.feedCellHeightLong;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableDictionary *data = [self.feedData objectAtIndex:indexPath.row];
    NSString* typeCell = data[@"type"];
    NSString* reuse = [NSString stringWithFormat:@"FeedCell/%@",typeCell];
    
    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (cell == nil)
    {
        cell = [[FeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    
    [cell reset];
    
    if(self.isFeedLoaded)
    {
        [cell loadData:data];
    }
    
    return cell;
}

#pragma mark - Match Screen

- (void)showMatchScreen {
    
}

@end
