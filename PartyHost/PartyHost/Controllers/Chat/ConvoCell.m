//
//  ConvoCell.m
//  PartyHost
//
//  Created by Sunny Clark on 1/1/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "ConvoCell.h"
#import "Chat.h"
#import "Friend.h"

@implementation ConvoCell

- (void)awakeFromNib
{
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        self.sharedData = [SharedData sharedInstance];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        self.iconCon = [[UIView alloc] initWithFrame:CGRectMake(10, 15, 50, 50)];
        self.iconCon.hidden = YES;
        [self.contentView addSubview:self.iconCon];
        
        //User Icon
        self.icon = [[UserBubble alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        self.icon.userInteractionEnabled = NO;
        [self.iconCon addSubview:self.icon];
        
        //Chat Badge
        self.unreadBadge = [[BadgeView alloc] initWithFrame:CGRectMake(50-16,0,16,16)];
        [self.unreadBadge updateValue:0];
        [self.iconCon addSubview:self.unreadBadge];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 16+6, self.sharedData.screenWidth - 100 - 80, 20)];
        self.nameLabel.adjustsFontSizeToFitWidth = YES;
        self.nameLabel.font = [UIFont phBold:15];
        self.nameLabel.textColor = [UIColor blackColor];
        //self.nameLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.nameLabel];
        
        self.lastLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height+1, self.sharedData.screenWidth - 75 - 32, 20)];
        self.lastLabel.font = [UIFont phBlond:11];
        self.lastLabel.textColor = [UIColor lightGrayColor];
        self.lastLabel.adjustsFontSizeToFitWidth = NO;
        self.lastLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        //self.lastLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.lastLabel];
        
        //last_updated
        /*

        */
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth - 100 - 38, self.nameLabel.frame.origin.y, 100, 12)];
        //self.dateLabel.backgroundColor = [UIColor greenColor];
        self.dateLabel.font = [UIFont phBlond:9];
        self.dateLabel.textColor = [UIColor lightGrayColor];
        self.dateLabel.text = @"";
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.dateLabel];
    }
    return self;
}

/*
 {
 fromId: "149",
 fromName: "Sunnyc",
 profile_image: "https://fbcdn-sphotos-g-a.akamaihd.net/hphotos-ak-xpa1/v/t1.0-9/10171813_10203284044206352_3581429843021219214_n.jpg?oh=02f49090a2132a0ec9706b0701debfde&oe=5546D485&__gda__=1426510227_15d9fa95928d8d76c14b6cb8be7607c9",
 last_message: "hey",
 unread: "0"
 }
 */

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)clearData {
    self.textLabel.text = @"";
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.iconCon.hidden = YES;
    self.nameLabel.hidden = YES;
    self.lastLabel.hidden = YES;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.textLabel.hidden = NO;
    [self.unreadBadge updateValue:0];
}

- (void)loadChatData:(Chat *)chat {
    self.iconCon.hidden = NO;
    self.nameLabel.hidden = NO;
    self.lastLabel.hidden = NO;
    self.textLabel.text = @"";
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    self.nameLabel.text = [chat.fromName capitalizedString];
    [self.icon setName:chat.fromName lastName:nil];
    
    //Set last message
    if([chat.lastMessage length]==0) {
        self.lastLabel.text = @"";
    } else {
        self.lastLabel.text = chat.lastMessage;
    }
    
    //Time ago
    self.dateLabel.text = [chat.lastUpdated timeAgo];
    
    [self.unreadBadge updateValue:chat.unread.intValue];
    
    [self.icon loadFacebookImage:chat.fb_id];
}

- (void)loadFriendData:(Friend *)friend {
    self.iconCon.hidden = NO;
    self.nameLabel.hidden = NO;
    self.lastLabel.hidden = NO;
    self.textLabel.text = @"";
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    self.nameLabel.text = [[NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName] capitalizedString];
    [self.icon setName:self.nameLabel.text lastName:nil];
    
    //Set about
    if([friend.about length]==0) {
        self.lastLabel.text = @"";
    } else {
        self.lastLabel.text = friend.about;
    }
    
    //Hide time ago
    self.dateLabel.text = @"";
    
    [self.unreadBadge updateValue:0];
    
    if (friend.imgURL) {
        [self.icon loadImage:friend.imgURL];
    }
}

@end
