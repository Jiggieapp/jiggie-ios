//
//  ProfileEventTableViewCell.h
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 5/26/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MemberInfo;
@class MemberInfoEvent;

@interface ProfileEventTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *eventImageView;
@property (strong, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (strong, nonatomic) IBOutlet UIView *categoryView;
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;

+ (UINib *)nib;

- (void)configureMemberEvent:(MemberInfoEvent *)event
              withMemberInfo:(MemberInfo *)member;

@end
