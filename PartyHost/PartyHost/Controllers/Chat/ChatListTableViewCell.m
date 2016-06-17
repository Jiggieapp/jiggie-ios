//
//  ChatListTableViewCell.m
//  Jiggie
//
//  Created by Mohammad Nuruddin Effendi on 6/16/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "ChatListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NSDate+TimeAgo.h"
#import "RoomGroupInfo.h"
#import "RoomPrivateInfo.h"
#import "User.h"
#import "BadgeView.h"
#import "Friend.h"

@interface ChatListTableViewCell ()

@property (strong, nonatomic) BadgeView *unreadBadgeView;

@end

@implementation ChatListTableViewCell

- (BadgeView *)unreadBadgeView {
    if (!_unreadBadgeView) {
        _unreadBadgeView = [[BadgeView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    }
    
    return _unreadBadgeView;
}

+ (UINib *)nib {
    return [UINib nibWithNibName:@"ChatListTableViewCell" bundle:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending) {
        [self.contentView setTranslatesAutoresizingMaskIntoConstraints:YES];
        self.contentView.frame = self.bounds;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    }
    
    self.photoImageView.layer.cornerRadius = 25;
    self.photoImageView.layer.masksToBounds = YES;
    
    [self.unreadBadgeView updateValue:0];
    
    [self.badgeView addSubview:self.unreadBadgeView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureChatListWithRoomInfo:(NSObject *)roomInfo {
    if ([roomInfo isKindOfClass:[RoomPrivateInfo class]]) {
        RoomPrivateInfo *info = (RoomPrivateInfo *)roomInfo;
        SharedData *sharedData = [SharedData sharedInstance];
        NSString *friendFbId = [RoomPrivateInfo getFriendFbIdFromIdentifier:info.identifier fbId:@"111222333"];
        
        [User retrieveUserInfoWithFbId:friendFbId andCompletionHandler:^(User *user, NSError *error) {
            if (user) {
                [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:user.avatarURL]];
                [self.nameLabel setText:user.name];
            }
        }];
        
        [self.lastMessageLabel setText:info.lastMessage];
        [self.dateLabel setText:[[NSDate dateWithTimeIntervalSince1970:info.updatedAt] timeAgo]];
    } else {
        RoomGroupInfo *info = (RoomGroupInfo *)roomInfo;
        
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:info.avatarURL]];
        [self.nameLabel setText:info.event];
        [self.lastMessageLabel setText:info.lastMessage];
        [self.dateLabel setText:[[NSDate dateWithTimeIntervalSince1970:info.updatedAt] timeAgo]];
    }
}

- (void)configureChatFriendListWithFriend:(Friend *)friend {
    [self.unreadBadgeView updateValue:0];
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:friend.imgURL]];
    [self.nameLabel setText:[[NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName] capitalizedString]];
    
    if ([friend.about length] == 0) {
        [self.lastMessageLabel setText:@""];
    } else {
        [self.lastMessageLabel setText:friend.about];
    }
    
    [self.dateLabel setText:@""];
}

@end
