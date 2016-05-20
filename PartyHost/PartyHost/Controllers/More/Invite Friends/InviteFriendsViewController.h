//
//  InviteFriendsViewController.h
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 5/11/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteFriendsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *inviteAllButton;

@property (assign, nonatomic) BOOL isShowCloseButton;
@end
