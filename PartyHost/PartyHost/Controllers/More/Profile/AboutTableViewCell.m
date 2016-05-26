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
    
    [self.aboutLabel setText:memberInfo.about];
}

@end
