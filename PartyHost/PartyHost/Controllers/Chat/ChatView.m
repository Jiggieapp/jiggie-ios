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
    BOOL isMigratedToFirebase = [[NSUserDefaults standardUserDefaults] boolForKey:@"IS_ALREADY_MIGRATED_TO_FIREBASE"];
    
    if (isMigratedToFirebase) {
        [self.chatListView initClass];
        [self.chatFriendListView initClass];
    } else {
        SharedData *sharedData = [SharedData sharedInstance];
        AFHTTPRequestOperationManager *manager = [sharedData getOperationManager];
        NSString *url = [NSString stringWithFormat:@"%@/chat/firebase/%@", PHBaseNewURL, sharedData.fb_id];
        
        [self.activityIndicatorView startAnimating];
        [manager GET:url parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (operation.response.statusCode == 200) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IS_ALREADY_MIGRATED_TO_FIREBASE"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self.chatListView initClass];
                [self.chatFriendListView initClass];
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.activityIndicatorView stopAnimating];
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.activityIndicatorView stopAnimating];
        }];
    }
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
