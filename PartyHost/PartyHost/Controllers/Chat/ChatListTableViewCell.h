//
//  ChatListTableViewCell.h
//  Jiggie
//
//  Created by Mohammad Nuruddin Effendi on 6/16/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

@class Friend;
@interface ChatListTableViewCell : MGSwipeTableCell

@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UIView *badgeView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastMessageLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

+ (UINib *)nib;

- (void)configureChatListWithRoomInfo:(NSObject *)roomInfo;
- (void)configureChatFriendListWithFriend:(Friend *)friend;

@end
