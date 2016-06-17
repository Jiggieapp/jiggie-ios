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

@implementation ChatListTableViewCell

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
    
    BadgeView *unreadBadgeView = [[BadgeView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    [unreadBadgeView updateValue:0];
    
    [self.badgeView addSubview:unreadBadgeView];
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
        [self.nameLabel setText:info.name];
        [self.lastMessageLabel setText:info.lastMessage];
        [self.dateLabel setText:[[NSDate dateWithTimeIntervalSince1970:info.updatedAt] timeAgo]];
    }
}

@end
