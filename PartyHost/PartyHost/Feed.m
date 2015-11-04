//
//  Feed.m
//  PartyHost
//
//  Created by Sunny Clark on 4/23/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "Feed.h"
#import "FeedCell.h"

#define POLL_SECONDS 5

@implementation Feed

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor phLightSilverColor];
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
    self.title.font = [UIFont phBold:21];
    
    
    self.btnHide = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.btnHide.frame = CGRectMake(5, 65, self.sharedData.screenWidth-10, 40);
    self.btnHide.titleLabel.font = [UIFont phBlond:18];
    [self.btnHide setTitleEdgeInsets:UIEdgeInsetsMake(3,0,0,0)];
    [self.btnHide setTitle:@"" forState:UIControlStateNormal];
    [self.btnHide setTitleColor:[UIColor phDarkGrayColor] forState:UIControlStateNormal];
    [self.btnHide setBackgroundColor:[UIColor clearColor]];
    [self.btnHide addTarget:self action:@selector(btnHideHandler) forControlEvents:UIControlEventTouchUpInside];
    self.btnHide.layer.borderWidth = 1.0;
    self.btnHide.layer.borderColor = [UIColor phDarkGrayColor].CGColor;
    self.btnHide.layer.cornerRadius = 5;
    self.btnHide.alpha = 0.8;
    self.btnHide.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.btnHide];
    //phBlond
    
    //Create table
    self.feedTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.sharedData.screenHeight - self.sharedData.feedCellHeightLong - 50 - 3, frame.size.width, frame.size.height - 60 - self.btnHide.frame.size.height)];
    self.feedTable.delegate = self;
    self.feedTable.dataSource = self;
    self.feedTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.feedTable.allowsMultipleSelectionDuringEditing = NO;
    self.feedTable.backgroundColor = [UIColor clearColor];
    self.feedTable.hidden = YES;
    self.feedTable.scrollEnabled = NO;
    [self.mainCon addSubview:self.feedTable];
    
    NSLog(@"screen : %i FEED TABLE : %@",self.sharedData.screenHeight, NSStringFromCGRect(self.feedTable.frame));
    
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

-(void)btnHideHandler
{
    NSLog(@"TOUCHED!!!");
    
    if(self.sharedData.matchMe)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Go Invisible?"
                                                        message:@"By going invisible, you will be able to browse events without showing up on the 'guest viewed' list and you won't show up in anyone's partyfeed. You can be back to visible mode using the Match Me link."
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
         if(self.sharedData.matchMe)
         {
             [self.btnHide setTitle:@"Go Invisible" forState:UIControlStateNormal];
         }else{
             [self.btnHide setTitle:@"Go Visible" forState:UIControlStateNormal];
         }
         
         self.feedTable.hidden = !(self.sharedData.matchMe);
         self.sharedData.feedBadge.hidden = !(self.sharedData.matchMe);
         self.sharedData.feedBadge.canShow = self.sharedData.matchMe;
         
         if(self.sharedData.matchMe)
         {
             self.isFeedLoaded = NO;
             [self loadData];
         }
         
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
    
    if(self.sharedData.matchMe)
    {
        [self.btnHide setTitle:@"Go Invisible" forState:UIControlStateNormal];
    }else{
        [self.btnHide setTitle:@"Go Visible" forState:UIControlStateNormal];
    }
    
    self.feedTable.hidden = !(self.sharedData.matchMe);
    self.sharedData.feedBadge.hidden = !(self.sharedData.matchMe);
    self.sharedData.feedBadge.canShow = self.sharedData.matchMe;
    /*
    self.sharedData.unreadFeedCount = 0;
    [self.sharedData.feedBadge updateValue:0];
    [self.sharedData updateBadgeIcon];
     */
    [self.sharedData trackMixPanelWithDict:@"View Party Feed" withDict:@{}];
    //[self.sharedData trackMixPanel:@"feed_tab"];
    [self loadData];
    
    //Special messages for guest and host
    if(![self.sharedData isMember]) {
        [self.emptyView setData:@"Check back soon" subtitle:@"Browse some events and your party feed will show your invites from party hosts." imageNamed:@"PickIcon"];
    }
    else {
        [self.emptyView setData:@"Check back soon" subtitle:@"Browse some events and your party feed will show members who are also interested in those same events." imageNamed:@"PickIcon"];
    }
}

-(void)loadData
{
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    NSString *url = [NSString stringWithFormat:@"%@/feed/%@/%@",PHBaseURL,self.sharedData.account_type,self.sharedData.fb_id];
    
    
    
    url = [NSString stringWithFormat:@"%@/partyfeed/list/%@/%@",PHBaseURL,self.sharedData.fb_id,self.sharedData.gender_interest];
    
    
    NSLog(@"FEED START LOAD :: %@",url);
    
    [manager GET:url parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //This checks for failure!!
         if(![responseObject isKindOfClass:[NSArray class]])
         {
             NSLog(@"FEED FAILED! >>> %@",responseObject);
             self.startedPolling = NO;
             [self performSelector:@selector(startPolling) withObject:nil afterDelay:POLL_SECONDS];
             return;
         }
         
         //Check if already equal
         if([self.feedData isEqualToArray:responseObject] && self.isFeedLoaded == YES && !self.sharedData.isInFeed)
         {
             NSLog(@"FEED_SAME_DATA");
             self.startedPolling = NO;
             [self performSelector:@selector(startPolling) withObject:nil afterDelay:POLL_SECONDS];
             return;
         }
         
         NSLog(@"FEED responseObject :: %@",responseObject);
         if(self.sharedData.isInFeed)
         {
             
             NSString *val = @"";
             if([self.sharedData.ABTestChat isEqualToString:@"YES"])
             {
                 val = @"Connect";
             }else{
                 val = @"Chat";
             }
             [self.sharedData trackMixPanelWithDict:@"View Feed Item" withDict:@{
                                                                                 @"ABTestChat":val
                                                                                 }];
         }else{
             NSLog(@"WTFWTFWTWFWT");
         }
         
         
         [self.sharedData trackMixPanelWithDict:@"New Feed Item" withDict:@{}];
         
         //Clear table
         [self.feedData removeAllObjects];
         [self.feedData addObjectsFromArray:responseObject];
         
         //Reload table view
         [self.feedTable reloadData];
         
         //Mark that its loaded
         self.isFeedLoaded = YES;
         self.sharedData.unreadFeedCount = (int)[self.feedData count];
         [self.sharedData.feedBadge updateValue:self.sharedData.unreadFeedCount];
         self.sharedData.feedBadge.hidden = !(self.sharedData.matchMe);
         self.sharedData.feedBadge.canShow = self.sharedData.matchMe;
         
         
         //Show empty
         if(self.feedData.count == 0) {
             self.feedTable.hidden = YES;
             [self.emptyView setMode:@"empty"];
         }
         else {
             self.feedTable.hidden = !(self.sharedData.matchMe);;
             [self.emptyView setMode:@"hide"];
         }
         
         self.btnHide.hidden = self.feedTable.hidden;
         
         /*
         //If we are on the page then clear out badge
         if(self.sharedData.cPageIndex==2)
         {
            self.sharedData.unreadFeedCount = 0;
            [self.sharedData.feedBadge updateValue:0];
         }
         */
         
         [self.sharedData updateBadgeIcon];
         
         //Hide spinner
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
         self.startedPolling = NO;
         [self performSelector:@selector(startPolling) withObject:nil afterDelay:POLL_SECONDS];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR :: %@",error);
         
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(FeedCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

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

@end
