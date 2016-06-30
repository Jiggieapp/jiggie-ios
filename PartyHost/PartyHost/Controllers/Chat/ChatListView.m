//
//  ChatListViewController.m
//  Jiggie
//
//  Created by Mohammad Nuruddin Effendi on 6/15/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "ChatListView.h"
#import "ChatListTableViewCell.h"
#import "MGSwipeButton.h"
#import "Room.h"
#import "User.h"
#import "AnalyticManager.h"
#import "SVProgressHUD.h"
#import "RoomPrivateInfo.h"
#import "RoomGroupInfo.h"
#import "Message.h"

static NSString *const kChatsCellIdentifier = @"ChatsCellIdentifier";

@interface ChatListView () <UITableViewDataSource, UITableViewDelegate, MGSwipeTableCellDelegate>

@property (strong, nonatomic) NSArray *rooms;
@property (copy, nonatomic) NSString *roomId;
@property (copy, nonatomic) NSString *roomName;
@property (assign, nonatomic) BOOL isBlockedUser;

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
    
    [self.activityIndicatorView stopAnimating];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadData:)
                                                 name:@"MEMBER_ROOMS"
                                               object:nil];
}


- (void)initClass {
}

- (void)loadData:(NSNotification *)notification {
    NSArray *rooms = notification.object;
    if (rooms) {
        self.rooms = [Room retrieveRoomsInfoWithRooms:rooms];
        [self.tableView reloadData];
        
        if (self.rooms) {
            SharedData *sharedData = [SharedData sharedInstance];
            NSMutableArray *unreads = [NSMutableArray arrayWithArray:[[self.rooms valueForKey:@"unreads"] valueForKey:sharedData.fb_id]];
            [unreads removeObjectIdenticalTo:[NSNull null]];
            [unreads removeObject:[NSNumber numberWithInt:0]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TOTAL_UNREAD_MESSAGES"
                                                                object:[NSNumber numberWithInteger:unreads.count]];
        }
        
        
        NSString *roomId = [[NSUserDefaults standardUserDefaults] objectForKey:@"CURRENT_ROOM_ID"];
        
        if (roomId) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.identifier == %@", roomId];
            NSArray *currentRoom = [self.rooms filteredArrayUsingPredicate:predicate];
            
            if ([currentRoom firstObject]) {
                NSObject *roomInfo = [currentRoom firstObject];
                if ([roomInfo isKindOfClass:[RoomPrivateInfo class]]) {
                    RoomPrivateInfo *info = (RoomPrivateInfo *)roomInfo;
                    
                    [[NSUserDefaults standardUserDefaults] setObject:info.unreads forKey:@"CURRENT_UNREAD_MEMBERS"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                } else {
                    RoomGroupInfo *info = (RoomGroupInfo *)roomInfo;
                    
                    [[NSUserDefaults standardUserDefaults] setObject:info.unreads forKey:@"CURRENT_UNREAD_MEMBERS"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
        }
    } else {
        self.rooms = nil;
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rooms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kChatsCellIdentifier];
    
    if (cell == nil) {
        cell = [[ChatListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kChatsCellIdentifier];
    }
    
    if (!cell.delegate) {
        cell.delegate = self;
    }
    
    [cell configureChatListWithRoomInfo:self.rooms[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSObject *roomInfo = [self.rooms objectAtIndex:indexPath.row];
    NSString *eventName = @"";
    NSDictionary *roomMembers = [NSDictionary dictionary];
    
    if ([roomInfo isKindOfClass:[RoomPrivateInfo class]]) {
        RoomPrivateInfo *info = (RoomPrivateInfo *)roomInfo;
        self.roomId = info.identifier;
        eventName = info.event;
        roomMembers = info.members;
    } else {
        RoomGroupInfo *info = (RoomGroupInfo *)roomInfo;
        self.roomId = info.identifier;
        eventName = info.event;
        roomMembers = info.members;
    }
    
    NSDictionary *object = @{@"roomId" : self.roomId,
                             @"members" : roomMembers,
                             @"eventName" : eventName};
    
    [[NSUserDefaults standardUserDefaults] setObject:self.roomId forKey:@"CURRENT_ROOM_ID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_MESSAGES"
                                                        object:object];
}

#pragma mark - MGSwipeTableCellDelegate
- (BOOL)swipeTableCell:(MGSwipeTableCell*)cell canSwipe:(MGSwipeDirection)direction; {
    return YES;
}

- (NSArray*)swipeTableCell:(MGSwipeTableCell*)cell swipeButtonsForDirection:(MGSwipeDirection)direction swipeSettings:(MGSwipeSettings*) swipeSettings expansionSettings:(MGSwipeExpansionSettings*) expansionSettings {
    swipeSettings.transition = MGSwipeTransitionBorder;
    
    if (direction == MGSwipeDirectionRightToLeft) {
        CGFloat padding = 15;
        NSObject *roomInfo = [self.rooms objectAtIndex:[self.tableView indexPathForCell:cell].row];
        
        if ([roomInfo isKindOfClass:[RoomPrivateInfo class]]) {
            MGSwipeButton *trash = [MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:[UIColor redColor] padding:padding callback:^BOOL(MGSwipeTableCell *sender) {
                
                RoomPrivateInfo *info = (RoomPrivateInfo *)roomInfo;
                
                self.roomId = info.identifier;
                self.roomName = ((ChatListTableViewCell *)cell).nameLabel.text;
                
                [self showAlertViewWithTitle:@"Confirm"
                                     message:@"Are you sure you want to delete chat messages from this user?"
                                      andTag:5];
                
                return NO;
            }];
            
            MGSwipeButton * block = [MGSwipeButton buttonWithTitle:@"Block" backgroundColor:[UIColor grayColor] padding:padding callback:^BOOL(MGSwipeTableCell *sender) {
                
                self.roomName = ((ChatListTableViewCell *)cell).nameLabel.text;
                NSObject *roomInfo = [self.rooms objectAtIndex:[self.tableView indexPathForCell:sender].row];
                
                RoomPrivateInfo *info = (RoomPrivateInfo *)roomInfo;
                
                self.isBlockedUser = YES;
                self.roomId = info.identifier;
                
                [self showAlertViewWithTitle:@"Confirm"
                                     message:@"Are you sure you want to block this user?"
                                      andTag:10];
                
                return NO;
            }];
            
            return @[block, trash];
        } else {
            MGSwipeButton *exit = [MGSwipeButton buttonWithTitle:@"Exit" backgroundColor:[UIColor grayColor] padding:padding callback:^BOOL(MGSwipeTableCell *sender) {
                
                self.roomName = ((ChatListTableViewCell *)cell).nameLabel.text;
                RoomGroupInfo *info = (RoomGroupInfo *)roomInfo;
                
                self.isBlockedUser = NO;
                self.roomId = info.identifier;
                
                [self showAlertViewWithTitle:@"Confirm"
                                     message:@"Are you sure you want to exit this group?"
                                      andTag:10];
                
                return NO;
            }];
            
            return @[exit];
        }
    }
    
    return nil;
}

- (void)swipeTableCell:(MGSwipeTableCell*) cell didChangeSwipeState:(MGSwipeState)state gestureIsActive:(BOOL)gestureIsActive {
    NSString *str;
    switch (state) {
        case MGSwipeStateNone: str = @"None"; break;
        case MGSwipeStateSwippingLeftToRight: str = @"SwippingLeftToRight"; break;
        case MGSwipeStateSwippingRightToLeft: str = @"SwippingRightToLeft"; break;
        case MGSwipeStateExpandingLeftToRight: str = @"ExpandingLeftToRight"; break;
        case MGSwipeStateExpandingRightToLeft: str = @"ExpandingRightToLeft"; break;
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [SVProgressHUD show];
        
        if (alertView.tag == 5) {
            SharedData *sharedData = [SharedData sharedInstance];
            NSString *friendFbId = [self.roomId rangeOfString:@"_"].location != NSNotFound ? [RoomPrivateInfo getFriendFbIdFromIdentifier:self.roomId fbId:sharedData.fb_id] : @"";
            
            [Room clearChatFromFriendFbId:friendFbId withFbId:sharedData.fb_id andCompletionHandler:^(NSError *error) {
                if (error) {
                    [self showAlertViewWithTitle:@"Deleted Messages"
                                      andMessage:@"Unable to delete messages."];
                } else {
                    [self showAlertViewWithTitle:@"Deleted Messages"
                                      andMessage:@"Messages have been deleted."];
                    
                    [[AnalyticManager sharedManager] trackMixPanelWithDict:@"Delete Messages"
                                                                  withDict:@{@"origin" : @"Chat"}];
                }
                
                [SVProgressHUD dismiss];
            }];
        } else {
            if (self.isBlockedUser) {
                [Room blockPrivateChatWithRoomId:self.roomId andCompletionHandler:^(NSError *error) {
                    if (error) {
                        [self showAlertViewWithTitle:@"Blocked User"
                                          andMessage:@"Fail."];
                    } else {
                        [self showAlertViewWithTitle:@"Blocked User"
                                          andMessage:[NSString stringWithFormat:@"%@ has been blocked",
                                                      self.roomName]];
                        
                        [[AnalyticManager sharedManager] trackMixPanelWithDict:@"Block User"
                                                                      withDict:@{@"origin" : @"Chat"}];
                    }
                    
                    [SVProgressHUD dismiss];
                }];
            } else {
                SharedData *sharedData = [SharedData sharedInstance];
                [Room blockRoomWithRoomId:self.roomId withFbId:sharedData.fb_id andCompletionHandler:^(NSError *error) {
                    if (error) {
                        [self showAlertViewWithTitle:@"Exit Group"
                                          andMessage:@"Fail."];
                    } else {
                        [self showAlertViewWithTitle:@"Exit Group"
                                          andMessage:[NSString stringWithFormat:@"You have exited %@ group",
                                                      self.roomName]];
                        
                        [[AnalyticManager sharedManager] trackMixPanelWithDict:@"Exit Group"
                                                                      withDict:@{@"origin" : @"Chat"}];
                    }
                    
                    [SVProgressHUD dismiss];
                }];
            }
        }
    }
}

- (void)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message andTag:(NSInteger)tag {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alert setTag:tag];
    // optional - add more buttons:
    [alert addButtonWithTitle:@"Yes"];
    [alert show];
}

@end
