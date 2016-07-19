//
//  EventsTheme.h
//  Jiggie
//
//  Created by Setiady Wiguna on 6/14/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Theme;
@interface EventsTheme : UIView <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
}

@property (strong, nonatomic) SharedData *sharedData;

@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EmptyView *emptyView;

@property (nonatomic, strong) Theme *cTheme;
@property (nonatomic, assign) BOOL needUpdateContents;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void)initClassWithTheme:(Theme *)theme;

@end
