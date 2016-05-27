//
//  AboutTableViewCell.m
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 5/25/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "AboutTableViewCell.h"
#import "MemberInfo.h"

@implementation AboutTableViewCell

+ (UINib *)nib {
    return [UINib nibWithNibName:@"AboutTableViewCell" bundle:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending) {
        [self.contentView setTranslatesAutoresizingMaskIntoConstraints:YES];
        self.contentView.frame = self.bounds;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureMemberInfo:(MemberInfo *)memberInfo {
    if (memberInfo.age) {
        [self.nameLabel setText:[NSString stringWithFormat:@"%@ %@, %@",
                                 memberInfo.firstName, memberInfo.lastName, memberInfo.age]];
    } else {
        [self.nameLabel setText:[NSString stringWithFormat:@"%@ %@",
                                 memberInfo.firstName, memberInfo.lastName]];
    }
    
    if ([memberInfo.fbId isEqualToString:[SharedData sharedInstance].fb_id]) {
        [self.hasTableImageView setImage:nil];
        [self.hasTicketImageView setImage:nil];
    } else {
        if (memberInfo.bookings.count > 0) {
            [self.hasTableImageView setImage:[UIImage imageNamed:@"feed-table-icon"]];
        } else {
            [self.hasTableImageView setImage:nil];
        }
        
        if (memberInfo.tickets.count > 0) {
            [self.hasTicketImageView setImage:[UIImage imageNamed:@"feed-ticket-icon"]];
        } else {
            [self.hasTicketImageView setImage:nil];
        }
    }
    
    [self.aboutLabel setText:memberInfo.about];
}

@end
