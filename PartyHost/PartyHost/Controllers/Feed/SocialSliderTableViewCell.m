//
//  SocialSliderTableViewCell.m
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 4/28/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "SocialSliderTableViewCell.h"

@implementation SocialSliderTableViewCell

+ (UINib *)nib {
    return [UINib nibWithNibName:@"SocialSliderTableViewCell" bundle:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)sliderDidValueChanged:(id)sender {
}

@end
