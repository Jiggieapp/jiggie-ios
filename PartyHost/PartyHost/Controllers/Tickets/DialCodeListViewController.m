//
//  DialCodeListViewController.m
//  Jiggie
//
//  Created by Setiady Wiguna on 4/20/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "DialCodeListViewController.h"
#import "JGKeyboardNotificationHelper.h"

@interface DialCodeListViewController ()

@property (nonatomic, assign) BOOL isSearchDialCodes;
@property (nonatomic, strong) NSArray *searchedDialCodes;
@property (nonatomic, strong) JGKeyboardNotificationHelper *keyboardNotification;

@end

@implementation DialCodeListViewController

- (JGKeyboardNotificationHelper *)keyboardNotification {
    if (!_keyboardNotification) {
        _keyboardNotification = [JGKeyboardNotificationHelper new];
    }
    
    return _keyboardNotification;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.visibleSize.width, 60)];
    [self.navBar setBackgroundColor:[UIColor phPurpleColor]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, self.visibleSize.width - 80, 40)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:@""];
    [titleLabel setFont:[UIFont phBlond:16]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.navBar addSubview:titleLabel];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(0.0f, 20.0f, 40.0f, 40.0f)];
    [closeButton setImageEdgeInsets:UIEdgeInsetsMake(8, 14, 8, 14)];
    [closeButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:closeButton];
    
    [self.view addSubview:self.navBar];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 60, self.visibleSize.width, 44)];
    [self.searchBar setPlaceholder:@"Country Name"];
    [self.searchBar setDelegate:self];
    [self.view addSubview:self.searchBar];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60 + self.searchBar.bounds.size.height, self.visibleSize.width, self.view.bounds.size.height - 60 - self.searchBar.bounds.size.height)];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:[UIView new]];
    [self.view addSubview:self.tableView];
    
    self.emptyView = [[EmptyView alloc] initWithFrame:CGRectMake(0, 60, self.visibleSize.width, self.view.bounds.size.height - 60)];
    [self.emptyView setData:@"No data found" subtitle:@"Sorry we're having some server issues, please check back in a few minutes." imageNamed:@""];
    [self.emptyView setMode:@"load"];
    [self.emptyView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.emptyView];
    
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self observeKeyboardNotification];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.keyboardNotification removeObserser:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Observer
- (void)observeKeyboardNotification {
    [self.keyboardNotification handleKeyboardNotificationWithCompletion:^(UIViewAnimationOptions animation, NSTimeInterval duration, CGRect frame) {
        [UIView animateWithDuration:duration
                              delay:.0f
                            options:animation
                         animations:^{
                             CGRect tableViewFrame = self.tableView.frame;
                             CGFloat tableViewHeight = CGRectGetHeight(frame) > 0 ? CGRectGetHeight(tableViewFrame) - CGRectGetHeight(frame) : CGRectGetHeight(self.view.bounds) - 60 - CGRectGetHeight(self.searchBar.bounds);
                             tableViewFrame.size.height = tableViewHeight;
                             self.tableView.frame = tableViewFrame;
                         } completion:nil];
    }];
    
    [self.keyboardNotification addObserser];
}

#pragma mark - Action
- (void)closeButtonDidTap:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - Data
- (void)loadData {
    SharedData *sharedData = [SharedData sharedInstance];
    AFHTTPRequestOperationManager *manager = [sharedData getOperationManager];
    //events/list/
    NSString *url = [NSString stringWithFormat:@"%@/list_countrycode",PHBaseNewURL];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger responseStatusCode = operation.response.statusCode;
        if (responseStatusCode != 200) {
            [self.emptyView setMode:@"hide"];
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
                        NSArray *list_countryCode = [data objectForKey:@"list_countryCode"];
                        if (list_countryCode && list_countryCode != nil) {
                            self.dialCodes = list_countryCode;
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
            [self reloadLoginWithFBToken];
        } else {
            [self.emptyView setMode:@"empty"];
        }
    }];
}

- (void)reloadLoginWithFBToken {
    SharedData *sharedData = [SharedData sharedInstance];
    
    [sharedData loginWithFBToken:^(AFHTTPRequestOperation *operation, id responseObject) {
        sharedData.ph_token = responseObject[@"data"][@"token"];
        [self loadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self reloadLoginWithFBToken];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSearchDialCodes) {
        return self.searchedDialCodes.count;
    }
    
    return self.dialCodes.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"DialCodeCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
        
        [[cell textLabel] setFont:[UIFont phBlond:14]];
        [[cell detailTextLabel] setFont:[UIFont phBlond:13]];
    }
    
    NSDictionary *dialCode = [self.dialCodes objectAtIndex:indexPath.row];
    
    if (self.isSearchDialCodes) {
        dialCode = [self.searchedDialCodes objectAtIndex:indexPath.row];
    }
    
    if (dialCode && dialCode != nil) {
        NSString *name = [dialCode objectForKey:@"name"];
        if (name && name != nil) {
            [[cell textLabel] setText:name];
        }
        
        NSString *countryCallingCodes = [dialCode objectForKey:@"countryCallingCodes"];
        if (countryCallingCodes && countryCallingCodes != nil) {
            [[cell detailTextLabel] setText:countryCallingCodes];
        } else {
            [[cell detailTextLabel] setText:@""];
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *dialCode = cell.detailTextLabel.text;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DialCodeSelected"
                                                        object:dialCode];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSCharacterSet *digitCharacters = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *symbolCharacters = [NSCharacterSet symbolCharacterSet];
    
    if ([searchText rangeOfCharacterFromSet:digitCharacters].location != NSNotFound ||
        [searchText rangeOfCharacterFromSet:symbolCharacters].location != NSNotFound) {
        return;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name CONTAINS[c] %@", searchText];
    self.searchedDialCodes = [self.dialCodes filteredArrayUsingPredicate:predicate];
    
    self.isSearchDialCodes = ![searchText isEqualToString:@""];
        
    [self.tableView reloadData];
}

@end
