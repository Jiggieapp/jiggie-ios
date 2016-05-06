//
//  SidePhotoTableViewCell.h
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 5/3/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SidePhotoTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UIImageView *photoActionImageView;
@property (strong, nonatomic) IBOutlet UIView *activityIndicatorView;

+ (UINib *)nib;

@end
