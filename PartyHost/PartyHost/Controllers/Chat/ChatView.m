//
//  ChatView.m
//  Jiggie
//
//  Created by Mohammad Nuruddin Effendi on 6/16/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "ChatView.h"
#import "ChatListView.h"

@interface ChatView ()

@property (strong, nonatomic) ChatListView *chatListView;

@end

@implementation ChatView

- (ChatListView *)chatListView {
    if (!_chatListView) {
        _chatListView = [ChatListView instanceFromNib];
    }
    
    return _chatListView;
}


+ (ChatView *)instanceFromNib {
    return (ChatView *)[[UINib nibWithNibName:@"ChatView" bundle:nil] instantiateWithOwner:self options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.activeContentView addSubview:self.chatListView];
}

- (void)initClass {
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.chatListView.frame = CGRectMake(0, 0, CGRectGetWidth(self.activeContentView.bounds), CGRectGetHeight(self.activeContentView.bounds));
}

- (IBAction)didTapInviteButton:(id)sender {
}

- (IBAction)didTapActionButton:(id)sender {
}

- (IBAction)didTapFriendsButton:(id)sender {
}

@end
