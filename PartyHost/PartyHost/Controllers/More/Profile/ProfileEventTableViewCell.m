//
//  ProfileEventTableViewCell.m
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 5/26/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "ProfileEventTableViewCell.h"
#import "MemberInfo.h"
#import "MemberInfoEvent.h"

@implementation ProfileEventTableViewCell

+ (UINib *)nib {
    return [UINib nibWithNibName:@"ProfileEventTableViewCell" bundle:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.categoryView.layer.cornerRadius = 14;
    self.categoryView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.categoryView.layer.borderWidth = 1;
    
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

- (void)configureMemberEvent:(MemberInfoEvent *)event withMemberInfo:(MemberInfo *)member {
    SharedData *sharedData = [SharedData sharedInstance];
    
    [sharedData loadImage:event.photos.firstObject onCompletion:^{
        [self.eventImageView setImage:sharedData.imagesDict[event.photos.firstObject]];
        [self.eventImageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.eventImageView setClipsToBounds:YES];
    }];
    
    [self.eventNameLabel setText:event.title];
    
    if ([member.bookings containsObject:event]) {
        [self.categoryLabel setText:@"Has table"];
    } else if ([member.tickets containsObject:event]) {
        [self.categoryLabel setText:@"Has ticket"];
    } else {
        [self.categoryLabel setText:@"Liked"];
    }
}

@end
