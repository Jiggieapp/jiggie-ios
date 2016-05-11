//
//  InviteFriendsTableViewCell.h
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 5/11/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APContact;
@class InviteFriendsTableViewCell;

@protocol InviteFriendsTableViewCellDelegate <NSObject>

@required
- (void)InviteFriendsTableViewCell:(InviteFriendsTableViewCell *)cell
                didTapInviteButton:(UIButton *)sender;

@end

@interface InviteFriendsTableViewCell : UITableViewCell

@property (weak, nonatomic) id<InviteFriendsTableViewCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UIButton *inviteButton;

+ (UINib *)nib;

- (void)configureContact:(APContact *)contact;

@end
