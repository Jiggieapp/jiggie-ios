//
//  ChatFriendListView.h
//  Jiggie
//
//  Created by Mohammad Nuruddin Effendi on 6/17/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatFriendListView : UIView

@property (strong, nonatomic) IBOutlet UITableView *tableView;

+ (ChatFriendListView *)instanceFromNib;

- (void)initClass;
- (void)loadFriendsFromArchive;

@end
