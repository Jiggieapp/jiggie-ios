//
//  InviteFriendsTableViewCell.m
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 5/11/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "InviteFriendsTableViewCell.h"
#import "Contact.h"

@implementation InviteFriendsTableViewCell

+ (UINib *)nib {
    return [UINib nibWithNibName:@"InviteFriendsTableViewCell" bundle:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.profileImageView.backgroundColor = [UIColor clearColor];
    self.InitialNameLabel.backgroundColor = [UIColor phGrayColor];
    
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
    
    self.InitialNameLabel.layer.cornerRadius = CGRectGetHeight(self.profileImageView.bounds) / 2;
    self.InitialNameLabel.layer.masksToBounds = YES;
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
- (void)configureContact:(Contact *)contact {
    [self.profileImageView setImage:contact.thumbnail];
    NSMutableString * firstCharacters = [NSMutableString string];
    NSArray * words = [contact.name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSInteger ctr = 0;
    for (NSString * word in words) {
        if ([word length] > 0 && ctr < 2) {
            NSString * firstLetter = [word substringToIndex:1];
            [firstCharacters appendString:[firstLetter uppercaseString]];
            ctr ++;
        }
        [self.InitialNameLabel setText:firstCharacters];
    }
    [self.nameLabel setText:[NSString stringWithFormat:@"%@", contact.name]];
    [self.phoneNumberLabel setText:contact.phones.lastObject];
    [self.emailLabel setText:contact.emails.lastObject];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"id_ID"]];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:2];
    
    NSString *creditAmount = [numberFormatter stringFromNumber:[NSNumber numberWithInteger:contact.credit.integerValue]];
    [self.creditLabel setText:[NSString stringWithFormat:@"+ Rp%@", creditAmount]];
}

@end
