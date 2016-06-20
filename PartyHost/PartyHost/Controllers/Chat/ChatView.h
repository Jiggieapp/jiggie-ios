//
//  ChatView.h
//  Jiggie
//
//  Created by Mohammad Nuruddin Effendi on 6/16/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatView : UIView

@property (strong, nonatomic) IBOutlet UIButton *activeButton;
@property (strong, nonatomic) IBOutlet UIButton *friendsButton;
@property (strong, nonatomic) IBOutlet UIButton *inviteButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *activeContentView;
@property (strong, nonatomic) IBOutlet UIView *friendsContentView;

+ (ChatView *)instanceFromNib;

- (void)initClass;

- (IBAction)didTapInviteButton:(id)sender;
- (IBAction)didTapActionButton:(id)sender;
- (IBAction)didTapFriendsButton:(id)sender;

@end
