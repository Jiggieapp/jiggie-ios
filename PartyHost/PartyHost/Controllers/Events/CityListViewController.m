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

@interface CityListViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

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
    // Do any additional setup after loading the view from its nib.
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

#pragma mark - Data
- (void)loadData {
    [SVProgressHUD show];
    [City retrieveCitiesWithCompletionHandler:^(NSArray *cities, NSInteger statusCode, NSError *error) {
        if (cities) {
            self.cities = cities;
            [self.tableView setDataSource:self];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        
        [SVProgressHUD dismiss];
    }];}

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
    
    NSDictionary *cities = [self.cities objectAtIndex:indexPath.row];
    
    if (self.isSearchCities) {
        cities = [self.searchedCities objectAtIndex:indexPath.row];
    }
    
    if (cities) {
        NSString *name = [cities objectForKey:@"name"];
        [[cell textLabel] setText:name];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *city = cell.detailTextLabel.text;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectedCity"
                                                        object:city];
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
    self.searchedCities = [self.cities filteredArrayUsingPredicate:predicate];
    self.isSearchCities = ![searchText isEqualToString:@""];
    
    [self.tableView reloadData];
}

@end
