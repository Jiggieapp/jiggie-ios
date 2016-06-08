//
//  CityListViewController.h
//  Jiggie
//
//  Created by Mohammad Nuruddin Effendi on 6/8/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CityListViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
