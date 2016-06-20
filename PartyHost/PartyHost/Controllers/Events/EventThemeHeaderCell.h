//
//  EventThemeHeaderCell.h
//  Jiggie
//
//  Created by Setiady Wiguna on 6/17/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Theme;
@interface EventThemeHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *themeImageView;
@property (weak, nonatomic) IBOutlet UILabel *themeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *themeDescLabel;

+ (UINib *)nib;
- (void)loadData:(Theme *)theme;

@end
