//
//  SocialMultiSliderTableViewCell.h
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 4/29/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSRangeSlider;
@class SocialMultiSliderTableViewCell;

@protocol SocialMultiSliderTableViewCellDelegate <NSObject>

@required
- (void)socialMultiSliderTableViewCell:(SocialMultiSliderTableViewCell *)cell sliderDidValueChanged:(MSRangeSlider *)slider;

@end

@interface SocialMultiSliderTableViewCell : UITableViewCell

@property (weak, nonatomic) id<SocialMultiSliderTableViewCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) MSRangeSlider *slider;

+ (UINib *)nib;

@end