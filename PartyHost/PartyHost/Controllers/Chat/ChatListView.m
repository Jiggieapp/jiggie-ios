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
#import "AnalyticManager.h"
#import "SVProgressHUD.h"
#import "RoomPrivateInfo.h"
#import "RoomGroupInfo.h"

static NSString *const kChatsCellIdentifier = @"ChatsCellIdentifier";

@interface ChatListView () <UITableViewDataSource, UITableViewDelegate, MGSwipeTableCellDelegate>

@property (strong, nonatomic) NSArray *rooms;
@property (copy, nonatomic) NSString *roomId;

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
            self.rooms = [Room retrieveRoomsInfoWithRooms:rooms];
            [self.tableView reloadData];
        }
    }];
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
}

#pragma mark - MGSwipeTableCellDelegate
- (BOOL)swipeTableCell:(MGSwipeTableCell*)cell canSwipe:(MGSwipeDirection)direction; {
    return YES;
}

- (NSArray*)swipeTableCell:(MGSwipeTableCell*) cell swipeButtonsForDirection:(MGSwipeDirection)direction swipeSettings:(MGSwipeSettings*) swipeSettings expansionSettings:(MGSwipeExpansionSettings*) expansionSettings {
    swipeSettings.transition = MGSwipeTransitionBorder;
    
    if (direction == MGSwipeDirectionRightToLeft) {
        CGFloat padding = 15;
        
        MGSwipeButton *trash = [MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:[UIColor redColor] padding:padding callback:^BOOL(MGSwipeTableCell *sender) {
            
            NSObject *roomInfo = [self.rooms objectAtIndex:[self.tableView indexPathForCell:sender].row];
            
            if ([roomInfo isKindOfClass:[RoomPrivateInfo class]]) {
                RoomPrivateInfo *info = (RoomPrivateInfo *)roomInfo;
                self.roomId = info.identifier;
            } else {
                RoomGroupInfo *info = (RoomGroupInfo *)roomInfo;
                self.roomId = info.identifier;
            }
            
            [self showAlertQuestion:@"Confirm" withMessage:@"Are you sure you want to delete chat messages from this user?" andTag:5];
            
            return NO;
        }];
        
        MGSwipeButton * block = [MGSwipeButton buttonWithTitle:@"Block" backgroundColor:[UIColor grayColor] padding:padding callback:^BOOL(MGSwipeTableCell *sender) {
            
            NSObject *roomInfo = [self.rooms objectAtIndex:[self.tableView indexPathForCell:sender].row];
            
            if ([roomInfo isKindOfClass:[RoomPrivateInfo class]]) {
                RoomPrivateInfo *info = (RoomPrivateInfo *)roomInfo;
                self.roomId = info.identifier;
            } else {
                RoomGroupInfo *info = (RoomGroupInfo *)roomInfo;
                self.roomId = info.identifier;
            }
            
            [self showAlertQuestion:@"Confirm" withMessage:@"Are you sure you want to block this user?" andTag:10];
            
            return NO;
        }];
        
        return @[block, trash];
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
    
    NSLog(@"Swipe state: %@ ::: Gesture: %@", str, gestureIsActive ? @"Active" : @"Ended");
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [SVProgressHUD show];
        
        if (alertView.tag == 5) {
            [Room clearChatFromRoomId:self.roomId andCompletionHandler:^(NSError *error) {
                if (error) {
                    [self showFailDelete];
                } else {
                    [self showSuccessDelete];
                    [[AnalyticManager sharedManager] trackMixPanelWithDict:@"Delete Messages"
                                                                  withDict:@{@"origin" : @"Chat"}];
                }
                
                [SVProgressHUD dismiss];
            }];
        }
    }
}

- (void)showSuccessDelete {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Deleted Messages"
                                                    message:@"Messages have been deleted."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)showFailDelete {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Deleted Messages"
                                                    message:@"Unable to delete messages."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)showAlertQuestion:(NSString *)title withMessage:(NSString *)message andTag:(NSInteger)tag {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alert setTag:tag];
    // optional - add more buttons:
    [alert addButtonWithTitle:@"Yes"];
    [alert show];
}

@end
