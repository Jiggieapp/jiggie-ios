//
//  CityListViewController.m
//  Jiggie
//
//  Created by Mohammad Nuruddin Effendi on 6/8/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "CityListViewController.h"
#import "JGKeyboardNotificationHelper.h"
#import "SVProgressHUD.h"
#import "City.h"
#import "Mantle.h"

@interface CityListViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;

@property (nonatomic, assign) BOOL isSearchCities;
@property (nonatomic, strong) NSArray *searchedCities;
@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, strong) JGKeyboardNotificationHelper *keyboardNotification;

@end

@implementation CityListViewController

- (JGKeyboardNotificationHelper *)keyboardNotification {
    if (!_keyboardNotification) {
        _keyboardNotification = [JGKeyboardNotificationHelper new];
    }
    
    return _keyboardNotification;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor phPurpleColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName : [UIFont phBlond:16]}];
    
    UIBarButtonItem *closeBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_close"]
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(didTapCloseButton:)];
    [self.navigationItem setLeftBarButtonItem:closeBarButtonItem];
    
    self.title = @"Choose City";
    
    [self.tableView setTableFooterView:[UIView new]];
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self observeKeyboardNotification];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.keyboardNotification removeObserser:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didTapCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Observer
- (void)observeKeyboardNotification {
    [self.keyboardNotification handleKeyboardNotificationWithCompletion:^(UIViewAnimationOptions animation, NSTimeInterval duration, CGRect frame) {
        [UIView animateWithDuration:duration
                              delay:.0f
                            options:animation
                         animations:^{
                             self.tableViewBottomConstraint.constant = CGRectGetHeight(frame);
                             [self.view setNeedsUpdateConstraints];
                             [self.view layoutIfNeeded];
                         } completion:nil];
    }];
    
    [self.keyboardNotification addObserser];
}

#pragma mark - Data
- (void)loadData {
    NSArray *cities = [City unarchiveCities];
    
    if (cities.count > 0) {
        self.cities = cities;
        
        [self.tableView setDataSource:self];
        [self.tableView reloadData];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [City retrieveCitiesWithCompletionHandler:^(NSArray *cities, NSInteger statusCode, NSError *error) {
                if (cities) {
                    if (cities.count > 0) {
                        self.cities = cities;
                        
                        [City archiveCities:cities];
                        [self.tableView reloadData];
                    }
                }
            }];
        });
    } else {
        [SVProgressHUD show];
        [City retrieveCitiesWithCompletionHandler:^(NSArray *cities, NSInteger statusCode, NSError *error) {
            if (cities) {
                self.cities = cities;
                [self.tableView setDataSource:self];
                
                if (cities.count > 0) {
                    [City archiveCities:cities];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
            
            [SVProgressHUD dismiss];
        }];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSearchCities) {
        return self.searchedCities.count;
    }
    
    return self.cities.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"CitiesCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
        [[cell textLabel] setFont:[UIFont phBlond:14]];
    }
    
    City *city = [self.cities objectAtIndex:indexPath.row];
    
    if (self.isSearchCities) {
        city = [self.searchedCities objectAtIndex:indexPath.row];
    }
    
    if (city) {
        [[cell textLabel] setText:[city.name capitalizedString]];
    }
    
    City *currentCity = [MTLJSONAdapter modelOfClass:[City class]
                                  fromJSONDictionary:[[NSUserDefaults standardUserDefaults]
                                                      objectForKey:@"CurrentCity"]
                                               error:nil];
    
    if ([city.initial isEqualToString:currentCity.initial]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        if (!currentCity && [city.initial isEqualToString:@"JKT"]) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        } else {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    City *city = self.cities[indexPath.row];
    
    NSDictionary *currentCity = [MTLJSONAdapter JSONDictionaryFromModel:city error:nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:currentCity forKey:@"CurrentCity"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SELECTED_CITY"
                                                        object:currentCity];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.isSearchCities = NO;
    
    [searchBar setText:nil];
    [searchBar setShowsCancelButton:NO];
    
    [self.tableView reloadData];
    [self.view endEditing:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO];
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
    self.searchedCities = [self.cities filteredArrayUsingPredicate:predicate];
    self.isSearchCities = ![searchText isEqualToString:@""];
    
    [self.tableView reloadData];
}

@end
