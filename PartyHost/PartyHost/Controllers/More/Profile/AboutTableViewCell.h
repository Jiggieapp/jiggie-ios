//
//  AboutTableViewCell.h
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 5/25/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MemberInfo;

@interface AboutTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *aboutLabel;
@property (strong, nonatomic) IBOutlet UIImageView *hasTableImageView;
@property (strong, nonatomic) IBOutlet UIImageView *hasTicketImageView;

+ (UINib *)nib;

- (void)configureMemberInfo:(MemberInfo *)memberInfo;

@end
