//
//  InviteFriendsTableViewCell.m
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 5/11/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "InviteFriendsTableViewCell.h"
#import "APContact.h"

@implementation InviteFriendsTableViewCell

+ (UINib *)nib {
    return [UINib nibWithNibName:@"InviteFriendsTableViewCell" bundle:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.profileImageView.backgroundColor = [UIColor phGrayColor];
    
    self.inviteButton.layer.cornerRadius = 2;
    
    if ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending) {
        [self.contentView setTranslatesAutoresizingMaskIntoConstraints:YES];
        self.contentView.frame = self.bounds;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.profileImageView.layer.cornerRadius = CGRectGetHeight(self.profileImageView.bounds) / 2;
    self.profileImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Action
- (IBAction)didTapInviteButton:(id)sender {
    if (self.delegate) {
        [self.delegate InviteFriendsTableViewCell:self
                               didTapInviteButton:sender];
    }
}

#pragma mark - Configuration
- (void)configureContact:(APContact *)contact {
    [self.profileImageView setImage:contact.thumbnail];
    [self.nameLabel setText:[NSString stringWithFormat:@"%@ %@", contact.name.firstName, contact.name.lastName]];
    
    APPhone *phone = contact.phones.firstObject;
    APEmail *email = contact.emails.firstObject;
    
    [self.phoneNumberLabel setText:phone.number];
    [self.emailLabel setText:email.address];
}

@end
