//
//  ConvoCell.h
//  PartyHost
//
//  Created by Sunny Clark on 1/1/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDate+TimeAgo.h"
#import "MGSwipeTableCell.h"

@class Chat, Friend;

@interface ConvoCell : MGSwipeTableCell

@property (strong, nonatomic) SharedData    *sharedData;

@property(nonatomic,strong) UILabel     *nameLabel;
@property(nonatomic,strong) UILabel     *lastLabel;
@property(nonatomic,strong) BadgeView   *unreadBadge;
@property(nonatomic,strong) UIImageView  *icon;
@property(nonatomic,strong) UIView      *iconCon;
@property(nonatomic,strong) UILabel     *dateLabel;

- (void)clearData;
- (void)loadChatData:(Chat *)chat;
- (void)loadFriendData:(Friend *)friend;

@end
