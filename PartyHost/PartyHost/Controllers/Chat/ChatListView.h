//
//  ChatListViewController.h
//  Jiggie
//
//  Created by Mohammad Nuruddin Effendi on 6/15/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatListView : UIView

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

+ (ChatListView *)instanceFromNib;

- (void)initClass;

@end
