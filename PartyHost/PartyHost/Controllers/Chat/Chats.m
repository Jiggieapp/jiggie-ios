//
//  Chat.m
//  PartyHost
//
//  Created by Sunny Clark on 12/26/14.
//  Copyright (c) 2014 Sunny Clark. All rights reserved.
//

#import "Chats.h"
#import "AnalyticManager.h"
#import "AppDelegate.h"
#import "BaseModel.h"
#import "Chat.h"
#import "SVProgressHUD.h"
#import "Friend.h"
#import "EmptyCell.h"


@implementation Chats

@synthesize fetchedResultsController, managedObjectContext;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    self.sharedData = [SharedData sharedInstance];
    
    self.isConvosLoaded = NO;
    self.isFriendFirstLoad = YES;
    self.isChatFirstLoad = YES;
    self.isInDeleteMode = NO;
    self.isInBlockMode = NO;
    self.needUpdateContents = YES;
    
    UIView *tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 60)];
    tabBar.backgroundColor = [UIColor phPurpleColor];
    [self addSubview:tabBar];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.sharedData.screenWidth, 40)];
    title.text = @"Chat";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont phBlond:16];
    [tabBar addSubview:title];
    
    UIButton *inviteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [inviteButton setFrame:CGRectMake(self.sharedData.screenWidth - 56, 20.0f, 40.0f, 40.0f)];
//    [inviteButton setImageEdgeInsets:UIEdgeInsetsMake(11, 9, 11, 9)];
//    [inviteButton setImage:[UIImage imageNamed:@"icon_invite"] forState:UIControlStateNormal];
//    [[inviteButton imageView] setTintColor:[UIColor whiteColor]];
    [inviteButton setTitle:@"Invite" forState:UIControlStateNormal];
    [[inviteButton titleLabel] setFont:[UIFont phBlond:14.0]];
    [inviteButton addTarget:self action:@selector(inviteButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [tabBar addSubview:inviteButton];
    
    self.segmentationView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, frame.size.width, 34)];
    [self.segmentationView setBackgroundColor:[UIColor colorFromHexCode:@"B238DE"]];
    [self addSubview:self.segmentationView];
    
    CGFloat buttonSegmentationWidth = frame.size.width/2;
    UIButton *activeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [activeButton setFrame:CGRectMake(0, 0, buttonSegmentationWidth, 32)];
    [activeButton setBackgroundColor:[UIColor clearColor]];
    [activeButton setTitle:@"Active" forState:UIControlStateNormal];
    [activeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[activeButton titleLabel] setFont:[UIFont phBlond:14]];
    [activeButton setTag:1];
    [activeButton addTarget:self action:@selector(segmentationButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.segmentationView addSubview:activeButton];
    
    UIButton *friendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [friendButton setFrame:CGRectMake(buttonSegmentationWidth, 0, buttonSegmentationWidth, 32)];
    [friendButton setBackgroundColor:[UIColor clearColor]];
    [friendButton setTitle:@"Friends" forState:UIControlStateNormal];
    [friendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[friendButton titleLabel] setFont:[UIFont phBlond:14]];
    [friendButton setTag:2];
    [friendButton addTarget:self action:@selector(segmentationButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.segmentationView addSubview:friendButton];
    
    self.segmentationIndicator = [[UIView alloc] initWithFrame:CGRectMake(0, 32, buttonSegmentationWidth, 2)];
    [self.segmentationIndicator setBackgroundColor:[UIColor whiteColor]];
    [self.segmentationView addSubview:self.segmentationIndicator];
    
    self.currentSegmentationIndex = 1;
    
    self.tableScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60 + 34, frame.size.width, self.sharedData.screenHeight - 60 - 50 - 34)];
    [self.tableScrollView setBackgroundColor:[UIColor purpleColor]];
    [self.tableScrollView setContentSize:CGSizeMake(self.tableScrollView.bounds.size.width * 2, self.tableScrollView.bounds.size.height)];
    [self.tableScrollView setPagingEnabled:YES];
    [self.tableScrollView setShowsHorizontalScrollIndicator:NO];
    [self.tableScrollView setBounces:NO];
    [self.tableScrollView setDelegate:self];
    [self.tableScrollView setScrollEnabled:NO];
    [self addSubview:self.tableScrollView];
    
    self.conversationsList = [[UITableView alloc] initWithFrame:CGRectMake(self.tableScrollView.bounds.size.width * 0, 0, self.sharedData.screenWidth, self.tableScrollView.bounds.size.height)];
    self.conversationsList.delegate = self;
    self.conversationsList.dataSource = self;
    self.conversationsList.allowsMultipleSelectionDuringEditing = NO;
    self.conversationsList.backgroundColor = [UIColor whiteColor];
    self.conversationsList.separatorColor = [UIColor lightGrayColor];
    [self.conversationsList registerNib:[EmptyCell nib] forCellReuseIdentifier:EmptyTableViewCellIdentifier];

    [self.tableScrollView addSubview:self.conversationsList];
    
    
    self.friendsList = [[UITableView alloc] initWithFrame:CGRectMake(self.tableScrollView.bounds.size.width * 1, 0, self.sharedData.screenWidth, self.tableScrollView.bounds.size.height)];
    self.friendsList.delegate = self;
    self.friendsList.dataSource = self;
    self.friendsList.allowsMultipleSelectionDuringEditing = NO;
    self.friendsList.backgroundColor = [UIColor whiteColor];
    self.friendsList.separatorColor = [UIColor lightGrayColor];
    [self.friendsList registerNib:[EmptyCell nib] forCellReuseIdentifier:EmptyTableViewCellIdentifier];
    [self.tableScrollView addSubview:self.friendsList];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(chatTappedHandler)
     name:@"CHAT_TAPPED"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(updateConversation)
     name:@"UPDATE_CONVERSATION_LIST"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(updateConversation)
     name:@"EXIT_MESSAGES"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(forceReload)
     name:@"APP_UNLOADED"
     object:nil];
    
    [self.conversationsList beginUpdates];
    [self.conversationsList endUpdates];
    return self;
}


-(void)initClass {
    [self reloadFetch:nil];
    [self loadConvos];
    
    // Load friend list from file if available
    NSArray *friends = [Friend unarchiveObject];
    if (friends) {
        self.friends = [NSMutableArray arrayWithArray:friends];
        if (friends.count > 0) {
            [self.friendsList reloadData];
        }
    }
    [self loadFriends];
}

-(void)updateConversation {
    [self loadConvos];
}

#pragma mark - Button Action
-(void)chatTappedHandler
{
    [self.conversationsList setContentOffset:CGPointZero animated:YES];
}

-(void)forceReload
{
    self.isConvosLoaded = NO;
    
    //Clear table
    [self.conversationsList setContentOffset:CGPointZero animated:YES];
    [self.conversationsList reloadData];
}

-(void)exitConvoHandler
{
    if(self.sharedData.cPageIndex == 1)
    {
        [self initClass];
    }
}

- (void)inviteButtonDidTap:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_INVITE_CONTACT_FRIENDS"
                                                        object:nil];
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
    [NSEntityDescription entityForName:NSStringFromClass([Chat class])
                inManagedObjectContext:globalManagedObjectContext];
    NSSortDescriptor *sortDescriptor =
    [NSSortDescriptor sortDescriptorWithKey:@"lastUpdated"
                                  ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setPredicate:nil];
    
    fetchedResultsController = nil;
    fetchedResultsController = [[NSFetchedResultsController alloc]
                                initWithFetchRequest:fetchRequest
                                managedObjectContext:globalManagedObjectContext
                                sectionNameKeyPath:nil
                                cacheName:@"chatListCache"];
    [fetchedResultsController setDelegate:self];
    
    return fetchedResultsController;
}

- (BOOL)reloadFetch:(NSError **)error {
    //    NSLog(@"--- reloadAndPerformFetch");
    // delete cache
    [NSFetchedResultsController deleteCacheWithName:@"chatListCache"];
    if(fetchedResultsController){
        [fetchedResultsController setDelegate:nil];
        fetchedResultsController = nil;
    }
    
    BOOL performFetchResult = [[self fetchedResultsController] performFetch:error];
    
    if ([[self.fetchedResultsController fetchedObjects] count]>0) {
        self.isConvosLoaded = YES;
        [self.conversationsList reloadData];
    }
    
    return performFetchResult;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    if (self.needUpdateContents) {
        self.isConvosLoaded = YES;
        [self.conversationsList reloadData];
    }
}

#pragma mark - API
- (void)loadFriends {
    [Friend retrieveFacebookFriendsWithCompletionHandler:^(NSArray *friendIDs, NSError *error) {
        if (error == nil) {
            [Friend generateSocialFriend:friendIDs WithCompletionHandler:^(NSArray *friends, NSInteger statusCode, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error == nil) {
                        self.friends = friends;
                        if ((!friends || friends.count == 0) && statusCode == 204) {
                            [Friend removeArchivedObject];
                        } else {
                            [Friend archiveObject:friends];
                        }
                    }
                    self.isFriendFirstLoad = NO;
                    [self.friendsList reloadData];
                });
            }];
        }
    }];
}

- (void)loadConvos
{
    //self.isLoading = YES;
    NSString *facebookId = [self.sharedData.userDict objectForKey:@"fb_id"];
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    if (facebookId == nil) {
        return;
    }
    
    NSDictionary *params = @{ @"fb_id" : facebookId };
    
    NSString *url = [NSString stringWithFormat:@"%@/conversations",PHBaseNewURL];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
         NSString *responseString = operation.responseString;
         NSError *error;
         
         NSDictionary *json = (NSDictionary *)[NSJSONSerialization
                                               JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]
                                               options:kNilOptions
                                               error:&error];
         dispatch_async(dispatch_get_main_queue(), ^{
             
             self.isChatFirstLoad = NO;
             
             NSInteger responseStatusCode = operation.response.statusCode;
             if (responseStatusCode == 204) {
                 NSArray *fetchChats = [BaseModel fetchManagedObject:self.managedObjectContext
                                                            inEntity:NSStringFromClass([Chat class])
                                                        andPredicate:nil];
                 self.needUpdateContents = NO;
                 for (Chat *fetchChat in fetchChats) {
                     [self.managedObjectContext deleteObject:fetchChat];
                     
                     NSError *error;
                     if (![self.managedObjectContext save:&error]) NSLog(@"Error: %@", [error localizedDescription]);
                 }
                 self.needUpdateContents = YES;
                 [self.conversationsList reloadData];
                 
                 //Update badges
                 [self.sharedData.chatBadge updateValue:0];
                 [self.sharedData updateBadgeIcon];
                 
                 return;
             } else if (responseStatusCode != 200) {
                
                 [self.conversationsList reloadData];
                 return;
             }
             
             self.isConvosLoaded = YES;
             self.needUpdateContents = NO;
             
             int unreadcount = 0;
             
             @try {
                 NSArray *fetchChats = [BaseModel fetchManagedObject:self.managedObjectContext
                                                            inEntity:NSStringFromClass([Chat class])
                                                        andPredicate:nil];
                 
                 for (Chat *fetchChat in fetchChats) {
                     [self.managedObjectContext deleteObject:fetchChat];
                     
                     NSError *error;
                     if (![self.managedObjectContext save:&error]) NSLog(@"Error: %@", [error localizedDescription]);
                 }
                 
                 NSDictionary *data = [json objectForKey:@"data"];
                 if (data && data != nil) {
                     NSArray *chat_lists = [data objectForKey:@"chat_lists"];
                     
                     for (NSDictionary *chatRow in chat_lists) {
                         Chat *item = (Chat *)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Chat class])
                                                                            inManagedObjectContext:self.managedObjectContext];
                         
                         NSString *fb_id = [chatRow objectForKey:@"fb_id"];
                         if (fb_id && ![fb_id isEqual:[NSNull null]]) {
                             item.fb_id = fb_id;
                         } else {
                             item.fb_id = @"";
                         }
                         
                         NSString *fromId = [chatRow objectForKey:@"fromId"];
                         if (fromId && ![fromId isEqual:[NSNull null]]) {
                             item.fromID = fromId;
                         } else {
                             item.fromID = @"";
                         }
                         
                         NSString *fromName = [chatRow objectForKey:@"fromName"];
                         if (fromName && ![fromName isEqual:[NSNull null]]) {
                             item.fromName = fromName;
                         } else {
                             item.fromName = @"";
                         }
                         
                         NSNumber *hasreplied = [chatRow objectForKey:@"hasreplied"];
                         if (hasreplied && ![hasreplied isEqual:[NSNull null]]) {
                             item.hasReplied = hasreplied;
                         }
                         
                         NSString *last_message = [chatRow objectForKey:@"last_message"];
                         if (last_message && ![last_message isEqual:[NSNull null]]) {
                             item.lastMessage = last_message;
                         } else {
                             item.lastMessage = @"";
                         }
                         
                         NSString *last_updated = [chatRow objectForKey:@"last_updated"];
                         NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                         [formatter setDateFormat:PHDateFormatServer];
                         [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
                         [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
                         NSDate *lastUpdated = [formatter dateFromString:last_updated];
                         if (lastUpdated != nil) {
                             item.lastUpdated = lastUpdated;
                         }
                         
                         NSString *profile_image = [chatRow objectForKey:@"profile_image"];
                         if (profile_image && ![profile_image isEqual:[NSNull null]]) {
                             item.profileImage = profile_image;
                         } else {
                             item.profileImage = @"";
                         }
                         
                         NSNumber *unread = [chatRow objectForKey:@"unread"];
                         if (unread && ![unread isEqual:[NSNull null]]) {
                             item.unread = unread;
                             unreadcount += unread.integerValue;
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

             self.sharedData.unreadChatCount = unreadcount;
             
             //Update badges
             [self.sharedData.chatBadge updateValue:unreadcount];
             [self.sharedData updateBadgeIcon];
             
             [self.conversationsList reloadData];
             self.needUpdateContents = YES;
         });
         
         if(self.sharedData.hasMessageToLoad)
         {
             self.sharedData.hasMessageToLoad = NO;
             /*
              int userIndex = 0;
              for (int i = 0; i < [self.conversationsA count]; i++)
              {
              NSDictionary *dict = [self.conversationsA objectAtIndex:i];
              if(![[dict objectForKey:@"fb_id"] isEqualToString:self.sharedData.fromMailId])
              {
              userIndex = i;
              }
              }
              
              NSIndexPath* selectedCellIndexPath= [NSIndexPath indexPathForRow:userIndex inSection:0];
              [self.conversationsList selectRowAtIndexPath:selectedCellIndexPath animated:false scrollPosition:UITableViewScrollPositionMiddle];
              */
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         self.isChatFirstLoad = NO;
         [self.conversationsList reloadData];
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
         if (error.code == -1009 || error.code == -1005) {
             [SVProgressHUD showInfoWithStatus:@"Please check your internet connection"];
         }
     }];
}


-(void)loadImages
{
    for (Chat *chat in [self.fetchedResultsController fetchedObjects]) {
        NSString *pic_url = [self.sharedData profileImg:chat.fb_id];
        [self.sharedData loadImageCue:pic_url];
    }
}

-(void)blockUser
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    
    NSDictionary *params =@{
                            @"fromId" : self.sharedData.fb_id,
                            @"toId": self.sharedData.member_fb_id,
                            };
    NSString *urlToLoad = [NSString stringWithFormat:@"%@/blockuserwithfbid",PHBaseNewURL];
    [manager GET:urlToLoad parameters:params success:^
     (AFHTTPRequestOperation *operation, id resultObj)
     {
         NSPredicate *chatPredicate = [NSPredicate predicateWithFormat:@"fb_id == %@", self.sharedData.member_fb_id];
         NSArray *deletedChats = [BaseModel fetchManagedObject:self.managedObjectContext
                                                      inEntity:NSStringFromClass([Chat class])
                                                  andPredicate:chatPredicate];
         
         self.needUpdateContents = NO;
         for (Chat *deletedChat in deletedChats) {
             [self.managedObjectContext deleteObject:deletedChat];
         }
         self.needUpdateContents = YES;
         
         [self initClass];
         [self showSuccess];
         [[AnalyticManager sharedManager] trackMixPanelWithDict:@"Block User" withDict:@{@"origin":@"Chat"}];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self showFail];
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
     }];
}

-(void)showSuccess
{
    self.isInBlockMode = NO;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Blocked User"
                                                    message:[NSString stringWithFormat:@"%@ has been blocked",self.sharedData.member_first_name]
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    alert.delegate = self;
    [alert show];
}

-(void)showFail
{
    self.isInBlockMode = NO;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Blocked User"
                                                    message:@"Fail"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
}

-(void)deleteUser
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    NSDictionary *params =@{
                            @"fromId" : self.sharedData.fb_id,
                            @"toId":self.sharedData.member_fb_id,
                            };
    NSString *urlToLoad = [NSString stringWithFormat:@"%@/deletemessageswithfbid",PHBaseNewURL];
    
    [manager GET:urlToLoad parameters:params success:^
     (AFHTTPRequestOperation *operation, id resultObj)
     {
         NSLog(@"RESULT :: %@",resultObj);
         
         NSPredicate *chatPredicate = [NSPredicate predicateWithFormat:@"fb_id == %@", self.sharedData.member_fb_id];
         NSArray *deletedChats = [BaseModel fetchManagedObject:self.managedObjectContext
                                                      inEntity:NSStringFromClass([Chat class])
                                                  andPredicate:chatPredicate];
         
         self.needUpdateContents = NO;
         for (Chat *deletedChat in deletedChats) {
             [self.managedObjectContext deleteObject:deletedChat];
         }
         self.needUpdateContents = YES;
         
         [self initClass];
         [self showSuccessDelete];
         [[AnalyticManager sharedManager] trackMixPanelWithDict:@"Delete Messages" withDict:@{@"origin":@"Chat"}];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         [self showFailDelete];
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
     }];
    
}

-(void)showAlertQuestion:(NSString *)title withMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    // optional - add more buttons:
    [alert addButtonWithTitle:@"Yes"];
    [alert show];
}

#pragma mark - Segmentation
-(void)segmentationButtonDidTap:(id)sender {
    NSInteger senderTag = (NSInteger)[sender tag];
    
    if (senderTag == self.currentSegmentationIndex) {
        return;
    }
    
    self.currentSegmentationIndex = senderTag;
    
    CGFloat buttonSegmentationWidth = self.frame.size.width/2;
    
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

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.conversationsList]) {
        if(self.fetchedResultsController && [[self.fetchedResultsController fetchedObjects] count]>0){
            return [[self.fetchedResultsController fetchedObjects] count];
        }
    } else if ([tableView isEqual:self.friendsList]) {
        if (self.friends && self.friends.count > 0) {
            return self.friends.count + 1;
        }
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.conversationsList]) {
        if ([[self.fetchedResultsController fetchedObjects] count] > 0) {
            return 80.0;
        }
    } else if ([tableView isEqual:self.friendsList]) {
        if (self.friends && self.friends.count > 0) {
            return 80.0;
        }
    }
    
    return tableView.bounds.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.conversationsList]) {
        if ([[self.fetchedResultsController fetchedObjects] count] > 0) {
            static NSString *simpleTableIdentifier = @"Chat-ConvoCell";
            
            ConvoCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
            if (cell == nil)
            {
                cell = [[ConvoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            }
            
            if (self.sharedData.osVersion < 8)
            {
                cell.delegate = self;
            }
            
            [cell clearData];
            Chat *chat = [[self fetchedResultsController] objectAtIndexPath:indexPath];
            [cell loadChatData:chat];
            
            return cell;
        }
        
        EmptyCell *cell = (EmptyCell *)[tableView dequeueReusableCellWithIdentifier:EmptyTableViewCellIdentifier];
        [cell setTitle:@"No chats yet" andSubtitle:nil andIcon:[UIImage imageNamed:@"tab_chat"]];
        
        if (self.isChatFirstLoad) {
            [cell setMode:@"load"];
        } else {
            [cell setMode:@"empty"];
        }
        
        return cell;
        
    } else if ([tableView isEqual:self.friendsList]) {
        if (self.friends && self.friends.count > 0) {
            if (indexPath.row == self.friends.count) {
                static NSString *simpleTableIdentifier = @"InviteCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
                    
                    UIButton *inviteButton = [[UIButton alloc] initWithFrame:CGRectMake((self.sharedData.screenWidth - 160)/2, 20, 160, 40)];
                    [inviteButton addTarget:self action:@selector(inviteButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
                    [inviteButton setTitle:@"Invite Friends" forState:UIControlStateNormal];
                    [inviteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [[inviteButton titleLabel] setFont:[UIFont phBold:14]];
                    [inviteButton setBackgroundColor:[UIColor phBlueColor]];
                    [[cell contentView] addSubview:inviteButton];
                }
                
                return cell;
            }
            static NSString *simpleTableIdentifier = @"Friend-ConvoCell";
            
            ConvoCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
            if (cell == nil)
            {
                cell = [[ConvoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            }
            
            if (self.sharedData.osVersion < 8)
            {
                cell.delegate = self;
            }
            
            [cell clearData];
            Friend *friend = [self.friends objectAtIndex:indexPath.row];
            [cell loadFriendData:friend];
            
            return cell;
        }
    }
    
    EmptyCell *cell = (EmptyCell *)[tableView dequeueReusableCellWithIdentifier:EmptyTableViewCellIdentifier];
    [cell setTitle:@"Invite more friends" andSubtitle:nil andIcon:nil];
    if (self.isFriendFirstLoad) {
        [cell setMode:@"load"];
    } else {
        [cell setMode:@"empty"];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([tableView isEqual:self.conversationsList]) {
        if ([[self.fetchedResultsController fetchedObjects] count] > 0) {
            Chat *chat = [[self fetchedResultsController] objectAtIndexPath:indexPath];
            
            self.sharedData.messagesPage.toId = chat.fb_id;
            self.sharedData.messagesPage.toLabel.text = chat.fromName;
            self.sharedData.conversationId = chat.fb_id;
            
            self.sharedData.member_first_name = chat.fromName;
            self.sharedData.member_fb_id = chat.fb_id;
            self.sharedData.member_user_id = chat.fromID;
            
            ConvoCell *cell = (ConvoCell *)[tableView cellForRowAtIndexPath:indexPath];
            UIImage *imageToCopy = (cell.icon.imageView.image);
            UIGraphicsBeginImageContext(imageToCopy.size);
            [imageToCopy drawInRect:CGRectMake(0, 0, imageToCopy.size.width, imageToCopy.size.height)];
            UIImage *copiedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            self.sharedData.messagesPage.toIcon.image = copiedImage;
            
            self.sharedData.toImgURL = [self.sharedData profileImg:chat.fb_id];
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"SHOW_MESSAGES"
             object:self];
            
            [self performSelector:@selector(loadConvos) withObject:nil afterDelay:0.5];
        }
    } else if ([tableView isEqual:self.friendsList]) {
        if (self.friends && self.friends.count > 0) {
            Friend *friend = [self.friends objectAtIndex:indexPath.row];
            if (friend.connectState == FriendStateConnected) {
                ConvoCell *cell = (ConvoCell *)[tableView cellForRowAtIndexPath:indexPath];
                
                self.sharedData.messagesPage.toId = friend.fbID;
                self.sharedData.messagesPage.toLabel.text = cell.nameLabel.text;
                self.sharedData.conversationId = friend.fbID;
                
                self.sharedData.member_first_name = friend.fbID;
                self.sharedData.member_fb_id = cell.nameLabel.text;
                self.sharedData.member_user_id = friend.fbID;
                
                UIImage *imageToCopy = (cell.icon.imageView.image);
                UIGraphicsBeginImageContext(imageToCopy.size);
                [imageToCopy drawInRect:CGRectMake(0, 0, imageToCopy.size.width, imageToCopy.size.height)];
                UIImage *copiedImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                self.sharedData.messagesPage.toIcon.image = copiedImage;
                
                self.sharedData.toImgURL = [self.sharedData profileImg:friend.fbID];
                
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"SHOW_MESSAGES"
                 object:self];
                
                [self performSelector:@selector(loadConvos) withObject:nil afterDelay:0.5];
            } else {
                [SVProgressHUD show];
                [Friend connectFriend:@[friend.fbID] WithCompletionHandler:^(BOOL success, NSString *message, NSInteger statusCode, NSError *error) {
                    [SVProgressHUD dismiss];
                    if (error == nil && success) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             ConvoCell *cell = (ConvoCell *)[tableView cellForRowAtIndexPath:indexPath];
                             
                             self.sharedData.messagesPage.toId = friend.fbID;
                             self.sharedData.messagesPage.toLabel.text = cell.nameLabel.text;
                             self.sharedData.conversationId = friend.fbID;
                             
                             self.sharedData.member_first_name = friend.fbID;
                             self.sharedData.member_fb_id = cell.nameLabel.text;
                             self.sharedData.member_user_id = friend.fbID;
                             
                             UIImage *imageToCopy = (cell.icon.imageView.image);
                             UIGraphicsBeginImageContext(imageToCopy.size);
                             [imageToCopy drawInRect:CGRectMake(0, 0, imageToCopy.size.width, imageToCopy.size.height)];
                             UIImage *copiedImage = UIGraphicsGetImageFromCurrentImageContext();
                             UIGraphicsEndImageContext();
                             self.sharedData.messagesPage.toIcon.image = copiedImage;
                             
                             self.sharedData.toImgURL = [self.sharedData profileImg:friend.fbID];
                             
                             [[NSNotificationCenter defaultCenter]
                              postNotificationName:@"SHOW_MESSAGES"
                              object:self];
                             
                             [self performSelector:@selector(loadConvos) withObject:nil afterDelay:0.5];

                         });
                    }
                }];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.conversationsList]) {
        // Return YES if you want the specified item to be editable.
        if (self.sharedData.osVersion < 8) {
            return NO;
        }
        return YES;
    }
    
    return NO;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.conversationsList]) {
        if (self.sharedData.osVersion < 8) {
            return UITableViewCellEditingStyleNone;
        }
        
        if (!self.isConvosLoaded) {
            return UITableViewCellEditingStyleNone;
        } else {
            return UITableViewCellEditingStyleDelete;
        }
    }
    
     return UITableViewCellEditingStyleNone;
}


-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"EDITED_CALLED!");
    if (self.sharedData.osVersion < 8)
    {
        return @[];
    }
    
    UITableViewRowAction *button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Block" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                    {
                                        NSLog(@"Action to perform with Button 1");
                                        self.isInBlockMode = YES;
                                        
                                        Chat *chat = [[self fetchedResultsController] objectAtIndexPath:indexPath];
                                        self.sharedData.member_first_name = chat.fromName;
                                        self.sharedData.member_fb_id = chat.fb_id;
                                        [self showAlertQuestion:@"Confirm" withMessage:@"Are you sure you want to block this user?"];
                                    }];
    button.backgroundColor = [UIColor grayColor];
    UITableViewRowAction *button2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                     {
                                         //NSLog(@"Action to perform with Button2!");
                                         self.isInDeleteMode = YES;
                                         
                                         Chat *chat = [[self fetchedResultsController] objectAtIndexPath:indexPath];
                                         self.sharedData.member_first_name = chat.fromName;
                                         self.sharedData.member_fb_id = chat.fb_id;
                                         [self showAlertQuestion:@"Confirm" withMessage:@"Are you sure you want to delete chat messages from this user?"];
                                     }];
    button2.backgroundColor = [UIColor redColor]; //arbitrary color
    
    return @[button,button2];
}

#pragma mark - MGSwipeDelegate
-(BOOL) swipeTableCell:(MGSwipeTableCell*)cell canSwipe:(MGSwipeDirection)direction;
{
    return YES;
}

-(NSArray*) swipeTableCell:(MGSwipeTableCell*) cell swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings*) swipeSettings expansionSettings:(MGSwipeExpansionSettings*) expansionSettings
{
    
    swipeSettings.transition = MGSwipeTransitionBorder;
    expansionSettings.buttonIndex = 0;
    
    
    if (direction == MGSwipeDirectionLeftToRight) {
        
        return @[];
        /*
         expansionSettings.fillOnTrigger = NO;
         expansionSettings.threshold = 2;
         return @[[MGSwipeButton buttonWithTitle:@"Title" backgroundColor:[UIColor colorWithRed:0 green:122/255.0 blue:1.0 alpha:1.0] padding:5 callback:^BOOL(MGSwipeTableCell *sender) {
         
         [cell refreshContentView]; //needed to refresh cell contents while swipping
         
         
         
         return YES;
         }]];
         */
    }
    else {
        
        //expansionSettings.fillOnTrigger = YES;
        //expansionSettings.threshold = 1.1;
        
        CGFloat padding = 15;
        
        MGSwipeButton * trash = [MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:[UIColor redColor] padding:padding callback:^BOOL(MGSwipeTableCell *sender) {
            
            NSIndexPath * indexPath = [self.conversationsList indexPathForCell:sender];
            self.isInDeleteMode = YES;
            
            Chat *chat = [[self fetchedResultsController] objectAtIndexPath:indexPath];
            self.sharedData.member_first_name = chat.fromName;
            self.sharedData.member_fb_id = chat.fb_id;
            [self showAlertQuestion:@"Confirm" withMessage:@"Are you sure you want to delete chat messages from this user?"];
            return NO; //don't autohide to improve delete animation
        }];
        /*
         MGSwipeButton * flag = [MGSwipeButton buttonWithTitle:@"Flag" backgroundColor:[UIColor colorWithRed:1.0 green:149/255.0 blue:0.05 alpha:1.0] padding:padding callback:^BOOL(MGSwipeTableCell *sender) {
         
         //NSIndexPath * indexPath = [self.conversationsList indexPathForCell:sender];
         
         [cell refreshContentView]; //needed to refresh cell contents while swipping
         return YES;
         }];
         */
        MGSwipeButton * block = [MGSwipeButton buttonWithTitle:@"Block" backgroundColor:[UIColor grayColor] padding:padding callback:^BOOL(MGSwipeTableCell *sender) {
            
            NSIndexPath * indexPath = [self.conversationsList indexPathForCell:sender];
            self.isInBlockMode = YES;
            
            Chat *chat = [[self fetchedResultsController] objectAtIndexPath:indexPath];
            self.sharedData.member_first_name = chat.fromName;
            self.sharedData.member_fb_id = chat.fb_id;
            [self showAlertQuestion:@"Confirm" withMessage:@"Are you sure you want to block this user?"];
            
            return NO; //avoid autohide swipe
        }];
        
        return @[trash, block];
    }
    
    return nil;
}

-(void)swipeTableCell:(MGSwipeTableCell*) cell didChangeSwipeState:(MGSwipeState)state gestureIsActive:(BOOL)gestureIsActive
{
    NSString * str;
    switch (state) {
        case MGSwipeStateNone: str = @"None"; break;
        case MGSwipeStateSwippingLeftToRight: str = @"SwippingLeftToRight"; break;
        case MGSwipeStateSwippingRightToLeft: str = @"SwippingRightToLeft"; break;
        case MGSwipeStateExpandingLeftToRight: str = @"ExpandingLeftToRight"; break;
        case MGSwipeStateExpandingRightToLeft: str = @"ExpandingRightToLeft"; break;
    }
    NSLog(@"Swipe state: %@ ::: Gesture: %@", str, gestureIsActive ? @"Active" : @"Ended");
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1)
    {
        if(self.isInBlockMode)
        {
            [self blockUser];
        }
        
        if(self.isInDeleteMode)
        {
            [self deleteUser];
        }
        
        self.isInDeleteMode = NO;
        self.isInBlockMode = NO;
    }else
    {
        self.isInDeleteMode = NO;
        self.isInBlockMode = NO;
    }
}


-(void)showSuccessDelete
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Deleted Messages"
                                                    message:@"Messages have been deleted."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void)showFailDelete
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Deleted Messages"
                                                    message:@"Unable to delete messages."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
