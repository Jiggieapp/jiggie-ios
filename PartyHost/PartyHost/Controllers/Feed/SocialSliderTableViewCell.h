//
//  SocialSliderTableViewCell.h
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 4/28/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SocialSliderTableViewCell;
@protocol SocialSliderTableViewCellDelegate <NSObject>

@required
- (void)socialSliderTableViewCell:(SocialSliderTableViewCell *)cell sliderDidValueChanged:(UISlider *)slider;

@end

@interface SocialSliderTableViewCell : UITableViewCell

@property (weak, nonatomic) id<SocialSliderTableViewCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) IBOutlet UISlider *slider;

+ (UINib *)nib;

@end
