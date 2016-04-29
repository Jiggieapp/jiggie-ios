//
//  SocialMultiSliderTableViewCell.m
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 4/29/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "SocialMultiSliderTableViewCell.h"
#import "MSRangeSlider.h"

@implementation SocialMultiSliderTableViewCell

+ (UINib *)nib {
    return [UINib nibWithNibName:@"SocialMultiSliderTableViewCell" bundle:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.slider.minimumValue = 18;
    self.slider.maximumValue = 60;
    self.slider.minimumInterval = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)sliderDidValueChanged:(id)sender {
    if (self.delegate) {
        [self.delegate socialMultiSliderTableViewCell:self sliderDidValueChanged:sender];
    }
}

@end
