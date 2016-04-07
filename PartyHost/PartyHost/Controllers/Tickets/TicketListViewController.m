//
//  TicketListViewController.m
//  Jiggie
//
//  Created by Setiady Wiguna on 2/3/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "TicketListViewController.h"
#import "TicketSummaryViewController.h"
#import "SharedData.h"
#import "UIColor+PH.h"
#import "UIFont+PH.h"
#import "TicketListCell.h"
#import "AnalyticManager.h"


@interface TicketListViewController ()

@end

@implementation TicketListViewController

- (id)init {
    if ((self = [super init])) {
        self.sharedData = [SharedData sharedInstance];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor colorFromHexCode:@"F1F1F1"]];
    
    // Remove nav bar shadow
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    [closeButton setImage:[UIImage imageNamed:@"nav_back_new"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    
    [[self navigationItem] setLeftBarButtonItem:closeBarButtonItem];
    
    UIButton *helpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [helpButton setFrame:CGRectMake(0.0f, 0.0f, 40.0f, 30.0f)];
    [helpButton setImage:[UIImage imageNamed:@"button_help"] forState:UIControlStateNormal];
    [helpButton addTarget:self action:@selector(helpButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *helpBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:helpButton];
    
    [[self navigationItem] setRightBarButtonItem:helpBarButtonItem];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [titleView setBackgroundColor:[UIColor clearColor]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:@"CHOOSE ADMISSION"];
    [titleLabel setFont:[UIFont phBlond:13]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleView addSubview:titleLabel];
    
    UIImageView *titleIcon = [[UIImageView alloc] initWithFrame:CGRectMake(65, 28, 71, 5)];
    [titleIcon setImage:[UIImage imageNamed:@"icon_step_1"]];
    [titleView addSubview:titleIcon];
    
    [self.navigationItem setTitleView:titleView];
    

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.visibleSize.width, self.visibleSize.height)];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.tableView];
    
    UIView *tmpPurpleView = [[UIView alloc] initWithFrame:CGRectMake(0, -300, self.visibleSize.width, 300)];
    tmpPurpleView.backgroundColor = [UIColor phPurpleColor];
    [self.tableView addSubview:tmpPurpleView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 80)];
    [headerView setBackgroundColor:[UIColor phPurpleColor]];
    
    self.tableHeaderTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, self.view.bounds.size.width, 16)];
    [self.tableHeaderTitle setFont:[UIFont phBlond:15]];
    [self.tableHeaderTitle setTextColor:[UIColor whiteColor]];
    [self.tableHeaderTitle setBackgroundColor:[UIColor clearColor]];
    [self.tableHeaderTitle setTextAlignment:NSTextAlignmentCenter];
    [headerView addSubview:self.tableHeaderTitle];
    
    self.tableHeaderDescription = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, self.view.bounds.size.width, 16)];
    [self.tableHeaderDescription setFont:[UIFont phBlond:12]];
    [self.tableHeaderDescription setTextColor:[UIColor whiteColor]];
    [self.tableHeaderDescription setBackgroundColor:[UIColor clearColor]];
    [self.tableHeaderDescription setTextAlignment:NSTextAlignmentCenter];
    [headerView addSubview:self.tableHeaderDescription];
    
    self.tableView.tableHeaderView = headerView;

    self.emptyView = [[EmptyView alloc] initWithFrame:CGRectMake(0, 0, self.visibleSize.width, self.visibleSize.height)];
    [self.emptyView setData:@"No data found" subtitle:@"Sorry we're having some server issues, please check back in a few minutes." imageNamed:@""];
    [self.emptyView setMode:@"load"];
    [self.emptyView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.emptyView];
    
}

- (void)viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (void)closeButtonDidTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)helpButtonDidTap:(id)sender {
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        NSArray *myReceivers = [[NSArray alloc] initWithObjects:@"+6281218288317", nil];
        [picker setRecipients:myReceivers];
        picker.delegate = self;
        picker.messageComposeDelegate = self;
        picker.navigationBar.barStyle = UIBarStyleDefault;
        [self presentViewController:picker animated:YES completion:^{}];
    }
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    switch (result) {
        case MessageComposeResultCancelled:
            break;
        case MessageComposeResultFailed:
            break;
        case MessageComposeResultSent:
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Data 
- (void)loadData {
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    //events/list/
    NSString *url = [NSString stringWithFormat:@"%@/product/list/%@",PHBaseNewURL,self.eventID];
//    NSString *url = [NSString stringWithFormat:@"%@/product/list/56bd7b9ccd915d0300f17514",PHBaseNewURL];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSInteger responseStatusCode = operation.response.statusCode;
        if (responseStatusCode != 200) {
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
            if (json && json != nil) {
                @try {
                    NSDictionary *data = [json objectForKey:@"data"];
                    if (data && data != nil) {
                        NSDictionary *product_lists = [data objectForKey:@"product_lists"];
                        if (product_lists && product_lists != nil) {
                            self.productList = product_lists;
                            
                            NSString *event_name = [product_lists objectForKey:@"event_name"];
                            if (event_name && event_name != nil) {
                                self.tableHeaderTitle.text = event_name;
                            }
                            
                            NSString *venue_name = [product_lists objectForKey:@"venue_name"];
                            
                            NSString *start_datetime = [product_lists objectForKey:@"start_datetime"];
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            [formatter setDateFormat:PHDateFormatServer];
                            [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
                            [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
                            NSDate *startDatetime = [formatter dateFromString:start_datetime];
                            
                            [formatter setDateFormat:PHDateFormatAppShort];
                            [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
                            [formatter setTimeZone:[NSTimeZone localTimeZone]];
                            NSString *shortDateTime = [formatter stringFromDate:startDatetime];
                            
                            self.tableHeaderDescription.text = [NSString stringWithFormat:@"%@ - %@", shortDateTime, venue_name];
                            
                            NSArray *purchase = [product_lists objectForKey:@"purchase"];
                            if (purchase && purchase != nil) {
                                self.purchases = purchase;
                            }
                            
                            NSArray *reservation = [product_lists objectForKey:@"reservation"];
                            if (reservation && reservation != nil) {
                                self.reservations = reservation;
                            }
                            
                            
                            // MixPanel
                            [self.sharedData.mixPanelCTicketDict removeAllObjects];
                            [self.sharedData.mixPanelCTicketDict setObject:[self.productList objectForKey:@"event_name"] forKey:@"Event Name"];
                            [self.sharedData.mixPanelCTicketDict setObject:[self.productList objectForKey:@"start_datetime"] forKey:@"Event Start Date"];
                            [self.sharedData.mixPanelCTicketDict setObject:[self.productList objectForKey:@"end_datetime"] forKey:@"Event End Date"];
                            [self.sharedData.mixPanelCTicketDict setObject:[self.productList objectForKey:@"description"] forKey:@"Event Description"];
                            [self.sharedData.mixPanelCTicketDict setObject:[self.productList objectForKey:@"venue_name"] forKey:@"Event Venue Name"];
                            [self.sharedData.mixPanelCTicketDict setObject:[self.productList objectForKey:@"venue_city"] forKey:@"Event Venue City"];
                            NSArray *mixpanelTags = [self.productList objectForKey:@"tags"];
                            if (mixpanelTags && mixpanelTags != nil) {
                                [self.sharedData.mixPanelCTicketDict setObject:mixpanelTags forKey:@"Event Tags"];
                            }
                            
                            [[AnalyticManager sharedManager] trackMixPanelWithDict:@"Product List" withDict:self.sharedData.mixPanelCTicketDict];

                        }
                    }
                    [self.tableView reloadData];
                    [self.emptyView setMode:@"hide"];
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
            }
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self.emptyView setMode:@"empty"];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 && self.purchases.count > 0) {
        return 30;
    } else if (section == 1 && self.reservations.count > 0) {
        return 30;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 1)];
    [topLine setBackgroundColor:[UIColor phLightGrayColor]];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 26, tableView.bounds.size.width, 1)];
    [bottomLine setBackgroundColor:[UIColor phLightGrayColor]];
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(14, 0, 320, 26);
    myLabel.font = [UIFont phBlond:12];
    myLabel.textColor = [UIColor lightGrayColor];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 26)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    [headerView addSubview:myLabel];
    [headerView addSubview:topLine];
    [headerView addSubview:bottomLine];
    
    return headerView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"TICKETS";
    }
    return @"RESERVE TABLE";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.purchases.count;
    }
    return self.reservations.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *simpleTableIdentifier = @"Purchase-TicketCell";
        
        TicketListCell *cell = (TicketListCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[TicketListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
            cell.cellWidth = self.visibleSize.width;
        }
        
        NSDictionary *purchase = [self.purchases objectAtIndex:indexPath.row];
        [cell setData:purchase hasDescription:YES];
        
        return cell;
    }
    
    static NSString *simpleTableIdentifier = @"Reservation-TicketCell";
    
    TicketListCell *cell = (TicketListCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[TicketListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        cell.cellWidth = self.visibleSize.width;
    }
    
    NSDictionary *reservation = [self.reservations objectAtIndex:indexPath.row];
    [cell setData:reservation hasDescription:NO];
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    TicketSummaryViewController *ticketSummaryViewController = [[TicketSummaryViewController alloc] init];
    if ([indexPath section] == 0) {
        ticketSummaryViewController.productSelected = [self.purchases objectAtIndex:indexPath.row];
        ticketSummaryViewController.isTicketProduct = YES;
    } else if ([indexPath section] == 1) {
        ticketSummaryViewController.productSelected = [self.reservations objectAtIndex:indexPath.row];
        ticketSummaryViewController.isTicketProduct = NO;
    }
    ticketSummaryViewController.productList = self.productList;
    [self.navigationController pushViewController:ticketSummaryViewController animated:YES];
}

@end
