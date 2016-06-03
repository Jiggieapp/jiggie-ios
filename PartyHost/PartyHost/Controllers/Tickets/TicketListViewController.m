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
#import "UserManager.h"
#import "UIImageView+WebCache.h"


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
    [self.navigationController setNavigationBarHidden:YES];   //it hides
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.visibleSize.width, self.view.bounds.size.height)];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.tableView];
    
    UIView *tmpPurpleView = [[UIView alloc] initWithFrame:CGRectMake(0, -300, self.visibleSize.width, 300)];
    tmpPurpleView.backgroundColor = [UIColor phPurpleColor];
    [self.tableView addSubview:tmpPurpleView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 240)];
    [headerView setBackgroundColor:[UIColor colorFromHexCode:@"F1F1F1"]];
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indicatorView setFrame:CGRectMake(0, 0, self.visibleSize.width, 240)];
    [headerView addSubview:indicatorView];
    
    self.eventImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.visibleSize.width, 240)];
    [self.eventImage setContentMode:UIViewContentModeScaleAspectFill];
    self.eventImage.layer.masksToBounds = YES;
    [self.eventImage setBackgroundColor:[UIColor phDarkGrayColor]];
    [headerView addSubview:self.eventImage];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)];
    [closeButton setImage:[UIImage imageNamed:@"nav_back_shadow"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:closeButton];
    
    UIButton *helpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [helpButton setFrame:CGRectMake(self.visibleSize.width - 60, 10.0f, 50.0f, 30.0f)];
    [helpButton setImage:[UIImage imageNamed:@"button_help_shadow"] forState:UIControlStateNormal];
    [helpButton addTarget:self action:@selector(helpButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:helpButton];
    
    self.infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 160, self.sharedData.screenWidth, headerView.bounds.size.height - 160)];
    [headerView addSubview:self.infoView];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 &&
        !UIAccessibilityIsReduceTransparencyEnabled()) {
        self.infoView.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = self.infoView.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.infoView addSubview:blurEffectView];
        self.infoView.alpha = 0.6;
    } else {
        self.infoView.backgroundColor = [UIColor blackColor];
        self.infoView.alpha = 0.4;
    }
    
    self.eventTitle = [[UILabel alloc] initWithFrame:CGRectMake(14, 170, self.view.bounds.size.width - 28, 20)];
    [self.eventTitle setNumberOfLines:2];
    [self.eventTitle setFont:[UIFont phBold:15]];
    [self.eventTitle setTextColor:[UIColor whiteColor]];
    [self.eventTitle setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:self.eventTitle];
    
    self.eventVenue = [[UILabel alloc] initWithFrame:CGRectMake(14, 190, self.view.bounds.size.width - 28, 20)];
    [self.eventVenue setFont:[UIFont phBlond:13]];
    [self.eventVenue setTextColor:[UIColor whiteColor]];
    [self.eventVenue setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:self.eventVenue];
    
    self.eventDate = [[UILabel alloc] initWithFrame:CGRectMake(14, 208, self.view.bounds.size.width - 28, 20)];
    [self.eventDate setFont:[UIFont phBlond:13]];
    [self.eventDate setTextColor:[UIColor whiteColor]];
    [self.eventDate setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:self.eventDate];
    
    self.tableView.tableHeaderView = headerView;
    
    self.emptyView = [[EmptyView alloc] initWithFrame:CGRectMake(0, 0, self.visibleSize.width, self.view.bounds.size.height)];
    [self.emptyView setData:@"No data found" subtitle:@"Sorry we're having some server issues, please check back in a few minutes." imageNamed:@""];
    [self.emptyView setMode:@"load"];
    [self.emptyView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.emptyView];
    
    self.navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.visibleSize.width, 60)];
    [self.navBar setBackgroundColor:[UIColor phPurpleColor]];
    
    self.navTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, self.visibleSize.width - 100, 40)];
    [self.navTitle setTextAlignment:NSTextAlignmentCenter];
    [self.navTitle setFont:[UIFont phBlond:15]];
    [self.navTitle setTextColor:[UIColor whiteColor]];
    [self.navTitle setBackgroundColor:[UIColor clearColor]];
    [self.navBar addSubview:self.navTitle];

    UIButton *navCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [navCloseButton setFrame:CGRectMake(0.0f, 20.0f, 40.0f, 40.0f)];
    [navCloseButton setImageEdgeInsets:UIEdgeInsetsMake(8, 14, 8, 14)];
    [navCloseButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [navCloseButton addTarget:self action:@selector(closeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:navCloseButton];
    
    UIButton *navHelpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [navHelpButton setFrame:CGRectMake(self.visibleSize.width - 60, 20.0f, 50.0f, 40.0f)];
    [navHelpButton setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 0)];
    [navHelpButton setImage:[UIImage imageNamed:@"button_help"] forState:UIControlStateNormal];
    [navHelpButton addTarget:self action:@selector(helpButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:navHelpButton];
    
    [self.view addSubview:self.navBar];
    
    // hides navbar
    [self showNavBar:NO withAnimation:NO];
    
}

- (void)viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:animated];
    
    [self loadData];
    [self loadGuestInfo];
    [self loadSupport];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showNavBar:(BOOL)isShow withAnimation:(BOOL)isAnimated {
    self.isNavBarShowing = isShow;
    
    CGFloat animateDuration = 0.0;
    if (isAnimated) {
        animateDuration = 0.25;
    }
    
    if (isShow) {
        [UIView animateWithDuration:animateDuration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.navBar setFrame:CGRectMake(0, 0, self.navBar.bounds.size.width, self.navBar.bounds.size.height)];
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [UIView animateWithDuration:animateDuration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.navBar setFrame:CGRectMake(0, - self.navBar.bounds.size.height, self.navBar.bounds.size.width, self.navBar.bounds.size.height)];
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark - Action
- (void)closeButtonDidTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)helpButtonDidTap:(id)sender {
    if ([MFMessageComposeViewController canSendText]) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *support = [prefs objectForKey:@"support"];
        if (support && support != nil) {
            NSString *telp = [support objectForKey:@"telp"];
            if (telp && telp != nil) {
                MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
                NSArray *myReceivers = [[NSArray alloc] initWithObjects:telp, nil];
                [picker setRecipients:myReceivers];
                picker.delegate = self;
                picker.messageComposeDelegate = self;
                picker.navigationBar.barStyle = UIBarStyleDefault;
                [self presentViewController:picker animated:YES completion:^{}];
            }
        }
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
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSInteger responseStatusCode = operation.response.statusCode;
        if (responseStatusCode != 200) {
            [self.emptyView setMode:@"empty"];
            [self showNavBar:YES withAnimation:YES];
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
                            
                            NSArray *photos = [product_lists objectForKey:@"photos"];
                            if (photos && photos!= nil && photos.count > 0) {
                                NSString *picURL = [photos objectAtIndex:0];
                                [self.eventImage sd_setImageWithURL:[NSURL URLWithString:picURL]
                                                   placeholderImage:nil];
                            }
                            
                            NSString *event_name = [product_lists objectForKey:@"event_name"];
                            if (event_name && event_name != nil) {
                                self.navTitle.text = event_name;
                                
                                self.eventTitle.text = [event_name uppercaseString];
                                
                                CGRect eventFrame = [self.eventTitle.text boundingRectWithSize:CGSizeMake(self.eventTitle.bounds.size.width, 40)
                                                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                                                     attributes:@{NSFontAttributeName:self.eventTitle.font}
                                                                                        context:nil];
                                CGFloat diff = eventFrame.size.height - self.eventTitle.bounds.size.height;
                                if (diff > 0) {
                                    [self.eventTitle setFrame:CGRectMake(self.eventTitle.frame.origin.x, self.eventTitle.frame.origin.y - diff, self.eventTitle.bounds.size.width, eventFrame.size.height)];
                                    
                                    [self.infoView setFrame:CGRectMake(self.infoView.frame.origin.x, self.infoView.frame.origin.y - diff, self.infoView.bounds.size.width, self.infoView.bounds.size.height + diff)];
                                }
                            }
                            
                            NSString *venue_name = [product_lists objectForKey:@"venue_name"];
                            if (venue_name && venue_name != nil) {
                                self.eventVenue.text = venue_name;
                            }
                            
                            NSString *start_datetime = [product_lists objectForKey:@"start_datetime"];
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            [formatter setDateFormat:PHDateFormatServer];
                            [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
                            [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
                            NSDate *startDatetime = [formatter dateFromString:start_datetime];
                            
                            [formatter setDateFormat:PHDateFormatApp];
                            [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
                            [formatter setTimeZone:[NSTimeZone localTimeZone]];
                            NSString *shortDateTime = [formatter stringFromDate:startDatetime];
                            
                            self.eventDate.text = shortDateTime;
                            
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
        if (operation.response.statusCode == 410) {
            [self reloadLoginWithFBToken:@"list"];
        } else {
            [self.emptyView setMode:@"empty"];
            [self showNavBar:YES withAnimation:YES];
        }
    }];
}

- (void)loadSupport {
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    //events/list/
    NSString *url = [NSString stringWithFormat:@"%@/product/support",PHBaseNewURL];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                        NSDictionary *support = [data objectForKey:@"support"];
                        if (support && support != nil) {
                            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                            [prefs setObject:support forKey:@"support"];
                            [prefs synchronize];
                        }
                    }
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
            }
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.response.statusCode == 410) {
            [self reloadLoginWithFBToken:@"support"];
        }
    }];
}

- (void)loadGuestInfo {
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    //events/list/
    NSString *url = [NSString stringWithFormat:@"%@/product/guest_info/%@",PHBaseNewURL, self.sharedData.fb_id];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                        NSDictionary *guest_detail = [data objectForKey:@"guest_detail"];
                        if (guest_detail && guest_detail != nil) {
                            NSDictionary *userInfo = @{@"name":[guest_detail objectForKey:@"name"],
                                                       @"email":[guest_detail objectForKey:@"email"],
                                                       @"dial_code":[guest_detail objectForKey:@"dial_code"],
                                                       @"phone":[guest_detail objectForKey:@"phone"]};
                            [UserManager saveUserTicketInfo:userInfo];
                        }
                    }
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
            }
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.response.statusCode == 410) {
            [self reloadLoginWithFBToken:@"guest_info"];
        }
    }];
}

- (void)reloadLoginWithFBToken:(NSString *)loadType {
    SharedData *sharedData = [SharedData sharedInstance];
    
    [sharedData loginWithFBToken:^(AFHTTPRequestOperation *operation, id responseObject) {
        sharedData.ph_token = responseObject[@"data"][@"token"];
        if ([loadType isEqualToString:@"list"]) {
            [self loadData];
        } else if ([loadType isEqualToString:@"support"]) {
            [self loadSupport];
        } else if ([loadType isEqualToString:@"guest_info"]) {
            [self loadGuestInfo];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self reloadLoginWithFBToken:loadType];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 && self.purchases.count > 0) {
        return 40;
    } else if (section == 1 && self.reservations.count > 0) {
        return 40;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(14, 14, 320, 20);
    myLabel.font = [UIFont phBlond:12];
    myLabel.textColor = [UIColor darkGrayColor];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    myLabel.backgroundColor = [UIColor clearColor];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:myLabel];
    
    return headerView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.purchases.count > 1) {
            return @"TICKETS";
        }
        return @"TICKET";
    }
    if (self.reservations.count > 1) {
        return @"TABLES";
    }
    return @"TABLE";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.purchases.count;
    }
    return self.reservations.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
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
        [cell setData:purchase];
        
        return cell;
    }
    
    static NSString *simpleTableIdentifier = @"Reservation-TicketCell";
    
    TicketListCell *cell = (TicketListCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[TicketListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        cell.cellWidth = self.visibleSize.width;
    }
    
    NSDictionary *reservation = [self.reservations objectAtIndex:indexPath.row];
    [cell setData:reservation];
    
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

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    if (offset.y > 180) {
        if (!self.isNavBarShowing) {
            [self showNavBar:YES withAnimation:YES];
        }
    } else if (self.isNavBarShowing) {
        [self showNavBar:NO withAnimation:YES];
    }
}

@end
