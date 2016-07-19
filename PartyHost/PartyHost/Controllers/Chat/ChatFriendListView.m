//
//  ChatFriendListView.m
//  Jiggie
//
//  Created by Mohammad Nuruddin Effendi on 6/17/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "ChatFriendListView.h"
#import "ChatListTableViewCell.h"
#import "Friend.h"
#import "RoomPrivateInfo.h"
#import "SVProgressHUD.h"
#import "Friend.h"

static NSString *const kFriendConvoCellIdentifier = @"FriendConvoCellIdentifier";

@interface ChatFriendListView () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *friends;

@end

@implementation ChatFriendListView

+ (ChatFriendListView *)instanceFromNib {
    return (ChatFriendListView *)[[UINib nibWithNibName:@"ChatFriendListView" bundle:nil] instantiateWithOwner:self options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[ChatListTableViewCell nib] forCellReuseIdentifier:kFriendConvoCellIdentifier];
}


- (void)initClass {
    NSArray *friends = [Friend unarchiveObject];
    
    if (friends) {
        self.friends = friends;
        
        if (friends.count > 0) {
            [self.tableView reloadData];
        }
    }
    
    [self loadFriends];
}

#pragma mark - API
- (void)loadFriends {
    [Friend retrieveFacebookFriendsWithCompletionHandler:^(NSArray *friendIDs, NSError *error) {
        if (error == nil) {
            [Friend generateSocialFriend:friendIDs WithCompletionHandler:^(NSArray *friends, NSInteger statusCode, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error == nil) {
                        self.friends = friends;
                        if ((!friends || friends.count == 0) && statusCode == 204) {
                            [Friend removeArchivedObject];
                        } else {
                            [Friend archiveObject:friends];
                        }
                    }
                    
                    [self.tableView reloadData];
                });
            }];
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFriendConvoCellIdentifier];
    
    if (cell == nil) {
        cell = [[ChatListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFriendConvoCellIdentifier];
    }
    
    [cell configureChatFriendListWithFriend:[self.friends objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SharedData *sharedData = [SharedData sharedInstance];
    Friend *friend = self.friends[indexPath.row];
    
    if (friend.connectState == FriendStateNotConnected) {
        [SVProgressHUD show];
        [Friend connectFriend:@[friend.fbID] WithCompletionHandler:^(BOOL success,
                                                                     NSString *message,
                                                                     NSInteger statusCode,
                                                                     NSError *error) {
            [SVProgressHUD dismiss];
            
            if (error == nil && success) {
                NSMutableArray *friends = [NSMutableArray arrayWithArray:self.friends];
                [friend setFriendConnectState:FriendStateConnected];
                [friends replaceObjectAtIndex:indexPath.row withObject:friend];
                [Friend archiveObject:friends];
                
                self.friends = friends;
                [self.tableView reloadData];
                
                NSDictionary *object = @{@"roomId" : [RoomPrivateInfo getPrivateMessageIdWithsenderId:sharedData.fb_id
                                                                                        andReceiverId:friend.fbID],
                                         @"eventName" : @"friendlist"};
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_MESSAGES"
                                                                    object:object];
            }
        }];
    } else {
        NSDictionary *object = @{@"roomId" : [RoomPrivateInfo getPrivateMessageIdWithsenderId:sharedData.fb_id
                                                                                andReceiverId:friend.fbID],
                                 @"eventName" : @"friendlist"};
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_MESSAGES"
                                                            object:object];
    }
}

@end
