//
//  EventsTheme.m
//  Jiggie
//
//  Created by Setiady Wiguna on 6/14/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "EventsTheme.h"
#import "Theme.h"
#import "AnalyticManager.h"
#import "SVProgressHUD.h"
#import "Event.h"
#import "AppDelegate.h"
#import "EventsRowCell.h"


@implementation EventsTheme

@synthesize fetchedResultsController, managedObjectContext;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    
    self.needUpdateContents = YES;
    
    self.sharedData = [SharedData sharedInstance];

    self.navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 60)];
    [self.navBar setBackgroundColor:[UIColor phPurpleColor]];
    [self addSubview:self.navBar];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, self.sharedData.screenWidth - 80, 40)];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleLabel setFont:[UIFont phBlond:16]];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setText:@"Themes"];
    [self.navBar addSubview:self.titleLabel];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(0.0f, 20.0f, 40.0f, 40.0f)];
    [closeButton setImageEdgeInsets:UIEdgeInsetsMake(8, 14, 8, 14)];
    [closeButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:closeButton];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navBar.frame),
                                                                   self.sharedData.screenWidth,
                                                                   self.sharedData.screenHeight - self.navBar.frame.size.height)];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.tableView];
    
    UIView *tmpPurpleView = [[UIView alloc] initWithFrame:CGRectMake(0, -300, self.sharedData.screenWidth, 300)];
    tmpPurpleView.backgroundColor = [UIColor phPurpleColor];
    [self.tableView addSubview:tmpPurpleView];
    
    //When there are no entries
    self.emptyView = [[EmptyView alloc] initWithFrame:self.tableView.frame];
    [self.emptyView setData:@"Oops there is a problem" subtitle:@"Sorry we're having some server issues, please check back in a few minutes." imageNamed:@""];
    [self.emptyView setMode:@"load"];
    self.emptyView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.emptyView];
    
    return self;
}

- (void)initClassWithTheme:(Theme *)theme {
    self.cTheme = nil;
    
    if (theme) {
        self.cTheme = theme;
        [self loadData:theme.themeID];
    }
    
    [self reset];
    [self reloadFetch:nil];
}

- (void)reset {
    [self.emptyView setMode:@"load"];
}

- (void)closeButtonDidTap:(id)sender {
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"EVENTS_GO_HOME"
     object:self];
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
    
    NSMutableArray *subPredicates = [NSMutableArray array];
    [subPredicates addObject:[NSPredicate predicateWithFormat:@"endDatetime > %@", [NSDate date]]];
    NSString *themeID = @"";
    if (self.cTheme) {
        themeID = self.cTheme.themeID;
    }
    [subPredicates addObject:[NSPredicate predicateWithFormat:@"themeID = %@", themeID]];

    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:subPredicates]];
    
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
        
        [self.tableView reloadData];
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
        [self.tableView reloadData];
    }
}

#pragma mark - Data
- (void)loadData:(NSString *)themeID {
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    NSString *url = nil;
    url = [NSString stringWithFormat:@"%@/events/themes/%@/",PHBaseNewURL,themeID];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         NSInteger responseStatusCode = operation.response.statusCode;
         if (responseStatusCode == 204) {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Theme Removed" message:@"Theme is no longer available." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             alert.tag = 1;
             [alert show];
             
             [self performSelector:@selector(closeButtonDidTap:)];
             
             [self.emptyView setMode:@"empty"];
             
             return;
         }
         
         NSString *responseString = operation.responseString;
         NSError *error;
         
         NSDictionary *json = (NSDictionary *)[NSJSONSerialization
                                               JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]
                                               options:kNilOptions
                                               error:&error];
         
         dispatch_async(dispatch_get_main_queue(), ^{
             
             @try {
                 
                 NSDictionary *data = [json objectForKey:@"data"];
                 if (data && data != nil) {
                     NSArray *events = [data objectForKey:@"events"];
                     
                     if (!events || events.count == 0) {
                         [self.emptyView setMode:@"empty"];
                     }
                     
                     self.needUpdateContents = NO;
                     
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
                         
                         NSString *themes_id = [eventRow objectForKey:@"themes_id"];
                         if (themes_id && ![themes_id isEqual:[NSNull null]]) {
                             item.themeID = themes_id;
                         } else {
                             item.themeID = @"";
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
             
             [self.tableView reloadData];
             
             self.needUpdateContents = YES;
             
         });
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if (error.code == -1009 || error.code == -1005) {
             [SVProgressHUD showInfoWithStatus:@"Please check your internet connection"];
         }
         [self.emptyView setMode:@"hide"];
     }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.fetchedResultsController && [[self.fetchedResultsController fetchedObjects] count] > 0){
        return [[self.fetchedResultsController fetchedObjects] count];
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([[self.fetchedResultsController fetchedObjects] count] > 0) {
        CGFloat pictureHeightRatio = 3.0 / 4.0;
        CGFloat cellHeight = pictureHeightRatio * tableView.bounds.size.width + 100;
        
        Event *event = [[self fetchedResultsController] objectAtIndexPath:indexPath];
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
    return tableView.bounds.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[self.fetchedResultsController fetchedObjects] count] > 0) {
        static NSString *simpleTableIdentifier = @"EventsRow1Cell";
        
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

@end
