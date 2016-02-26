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

@implementation Chats

@synthesize fetchedResultsController, managedObjectContext;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    self.sharedData = [SharedData sharedInstance];
    
    self.isConvosLoaded = NO;
    self.isLoading = NO;
    self.isInDeleteMode = NO;
    self.isInBlockMode = NO;
    self.needUpdateContents = YES;
    
    UIView *tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 60)];
    tabBar.backgroundColor = [UIColor phPurpleColor];
    [self addSubview:tabBar];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.sharedData.screenWidth, 40)];
    title.text = @"CHAT";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont phBold:18];
    [tabBar addSubview:title];
    
    self.conversationsList = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, self.sharedData.screenWidth, self.sharedData.screenHeight - 60 - 50)];
    self.conversationsList.delegate = self;
    self.conversationsList.dataSource = self;
    self.conversationsList.allowsMultipleSelectionDuringEditing = NO;
    self.conversationsList.backgroundColor = [UIColor whiteColor];
    self.conversationsList.separatorColor = [UIColor lightGrayColor];
    self.conversationsList.hidden = YES;
    [self addSubview:self.conversationsList];
    
    //Create empty view
    self.emptyView = [[EmptyView alloc] initWithFrame:CGRectMake(0, 60, frame.size.width, frame.size.height - 60)];
    [self.emptyView setData:@"You don't have new messages" subtitle:@"" imageNamed:@""];
    [self.emptyView setMode:@"load"];
    [self addSubview:self.emptyView];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(chatTappedHandler)
     name:@"CHAT_TAPPED"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(initClass)
     name:@"UPDATE_CONVERSATION_LIST"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(initClass)
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


-(void)initClass
{
    //Set a special message depending on account type
    if([self.sharedData isMember])
    {
        //self.labelEmpty.text = @"Reach out to a\nparty host and start a chat.\nWhat are you waiting for?";
        [self.emptyView setData:@"No chats yet" subtitle:@"Browse events to connect with guest so you can start chatting!" imageNamed:@"tab_chat"];
    }
    else
    {
        //self.labelEmpty.text = @"Post a hosting and start\nchatting with interested guests\nto secure party plans now!";
        [self.emptyView setData:@"No chats yet" subtitle:@"Book a table and start chatting with interested guests right now!" imageNamed:@"tab_chat"];
    }
    
    [self reloadFetch:nil];
    [self loadConvos];
    
//    if(!self.isLoading)
//    {
//        //self.isLoading = YES;
//        dispatch_queue_t someQueue = dispatch_queue_create("com.partyhost.app.chat_section", nil);
//        dispatch_async(someQueue,
//                       ^{
//                           [[AnalyticManager sharedManager] trackMixPanelWithDict:@"Conversations List" withDict:@{}];
//                           
//                           [self reloadFetch:nil];
//                           [self loadConvos];
//                       });
//    }
}

#pragma mark - Button Action
-(void)chatTappedHandler
{
    [self.conversationsList setContentOffset:CGPointZero animated:YES];
}

-(void)forceReload
{
    self.isConvosLoaded = NO;
    self.isLoading = NO;
    
    //Clear table
    [self.conversationsList setContentOffset:CGPointZero animated:YES];
    [self.conversationsList reloadData];
    
    //Show loading
    [self.emptyView setMode:@"load"];
}

-(void)exitConvoHandler
{
    if(self.sharedData.cPageIndex == 1)
    {
        [self initClass];
    }
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
        self.conversationsList.hidden = NO;
        [self.emptyView setMode:@"hide"];
        
        self.isConvosLoaded = YES;
        [self.conversationsList reloadData];
    }
    
    return performFetchResult;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    self.conversationsList.hidden = NO;
    [self.emptyView setMode:@"hide"];
    
    if (self.needUpdateContents) {
        self.isConvosLoaded = YES;
        [self.conversationsList reloadData];
    }
}

#pragma mark - API
-(void)loadConvos
{
    //self.isLoading = YES;
    NSString *facebookId = [self.sharedData.userDict objectForKey:@"fb_id"];
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    //facebookId = @"10152712297546999";
    //facebookId = @"10152215526006990";//Jay
    //facebookId = @"1376680319326091";
    
    
    //facebookId = @"1410449462602170"; //Harry
    
    if (facebookId == nil) {
        return;
    }
    
    NSDictionary *params = @{ @"fb_id" : facebookId };
    
    
    NSString *url = [NSString stringWithFormat:@"%@/conversations",PHBaseNewURL];
    NSLog(@"CHAT_START_LOAD :: %@",url);
    
    
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         NSString *responseString = operation.responseString;
         NSError *error;
         
         NSDictionary *json = (NSDictionary *)[NSJSONSerialization
                                               JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]
                                               options:kNilOptions
                                               error:&error];
         dispatch_async(dispatch_get_main_queue(), ^{
             
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
                 self.conversationsList.hidden = YES;
                 [self.emptyView setMode:@"empty"];
                 
                 return;
             } else if (responseStatusCode != 200) {
                 NSArray *fetchChats = [BaseModel fetchManagedObject:self.managedObjectContext
                                                            inEntity:NSStringFromClass([Chat class])
                                                        andPredicate:nil];
                 if (fetchChats.count == 0) {
                     self.conversationsList.hidden = YES;
                     [self.emptyView setMode:@"empty"];
                 }
                 return;
             }
             
             self.isConvosLoaded = YES;
             self.needUpdateContents = NO;
             
             //Show empty
             if(json.count <= 0) {
                 self.conversationsList.hidden = YES;
                 [self.emptyView setMode:@"empty"];
             }
             else {
                 self.conversationsList.hidden = NO;
                 [self.emptyView setMode:@"hide"];
             }
             
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
                     if(!chat_lists || chat_lists.count <= 0) {
                         self.conversationsList.hidden = YES;
                         [self.emptyView setMode:@"empty"];
                     }
                     
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
             self.isLoading = NO;
             
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"HIDE_LOADING"
              object:self];
             
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
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR :: %@",error);
         
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
    return 80.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ConvoCell";
    
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
    [cell loadData:chat];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES if you want the specified item to be editable.
    if (self.sharedData.osVersion < 8)
    {
        return NO;
    }
    return YES;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.sharedData.osVersion < 8)
    {
        return UITableViewCellEditingStyleNone;
    }
    
    if (!self.isConvosLoaded) {
        return UITableViewCellEditingStyleNone;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}


-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"EDITED_CALLED!");
    if (self.sharedData.osVersion < 8)
    {
        return @[];
    }
    
    /*
     if(!self.isConvosLoaded || [self.conversationsA count] == 0)
     {
     return @[];
     }
     */
    
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
