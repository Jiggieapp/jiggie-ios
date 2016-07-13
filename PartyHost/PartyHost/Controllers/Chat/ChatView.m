//
//  ChatView.m
//  Jiggie
//
//  Created by Mohammad Nuruddin Effendi on 6/16/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "ChatView.h"
#import "ChatListView.h"
#import "ChatFriendListView.h"

@interface ChatView ()

@property (strong, nonatomic) IBOutlet UIView *indicatorView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *indicatorViewLeadingConstraint;
@property (strong, nonatomic) ChatListView *chatListView;
@property (strong, nonatomic) ChatFriendListView *chatFriendListView;

@end

@implementation ChatView

- (ChatListView *)chatListView {
    if (!_chatListView) {
        _chatListView = [ChatListView instanceFromNib];
    }
    
    return _chatListView;
}

- (ChatFriendListView *)chatFriendListView {
    if (!_chatFriendListView) {
        _chatFriendListView = [ChatFriendListView instanceFromNib];
    }
    
    return _chatFriendListView;
}

+ (ChatView *)instanceFromNib {
    return (ChatView *)[[UINib nibWithNibName:@"ChatView" bundle:nil] instantiateWithOwner:self options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.activeContentView addSubview:self.chatListView];
    [self.friendsContentView addSubview:self.chatFriendListView];
    
    [self.activityIndicatorView stopAnimating];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.chatListView.frame = self.activeContentView.bounds;
    self.chatFriendListView.frame = self.friendsContentView.bounds;
}

- (void)initClass {
    [self.chatListView initClass];
    [self.chatFriendListView initClass];
}

- (IBAction)didTapInviteButton:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_INVITE_CONTACT_FRIENDS"
                                                        object:nil];
}

- (IBAction)didTapActionButton:(id)sender {
    self.indicatorViewLeadingConstraint.constant = 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 0);
        [self layoutIfNeeded];
    }];
}

- (IBAction)didTapFriendsButton:(id)sender {
    CGFloat xPos = CGRectGetWidth([UIScreen mainScreen].bounds);
    
    self.indicatorViewLeadingConstraint.constant = xPos / 2;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollView.contentOffset = CGPointMake(xPos, 0);
        [self layoutIfNeeded];
    }];
}

@end
