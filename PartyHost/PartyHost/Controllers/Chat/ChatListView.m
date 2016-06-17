//
//  ChatListViewController.m
//  Jiggie
//
//  Created by Mohammad Nuruddin Effendi on 6/15/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "ChatListView.h"
#import "ChatListTableViewCell.h"
#import "Room.h"

static NSString *const kChatsCellIdentifier = @"ChatsCellIdentifier";

@interface ChatListView () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *chats;

@end

@implementation ChatListView

+ (ChatListView *)instanceFromNib {
    return (ChatListView *)[[UINib nibWithNibName:@"ChatListView" bundle:nil] instantiateWithOwner:self options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[ChatListTableViewCell nib] forCellReuseIdentifier:kChatsCellIdentifier];
}


- (void)initClass {
    [Room retrieveRoomsWithFbId:@"111222333" andCompletionHandler:^(NSArray *rooms, NSError *error) {
        if (rooms) {
            self.chats = [Room retrieveRoomsInfoWithRooms:rooms];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chats.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kChatsCellIdentifier];
    
    if (cell == nil) {
        cell = [[ChatListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kChatsCellIdentifier];
    }
    
    [cell configureChatListWithRoomInfo:self.chats[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
