//
//  EventsThemeCell.h
//  Jiggie
//
//  Created by Setiady Wiguna on 6/15/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Theme;
@interface EventsThemeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *themeImageView;

+ (UINib *)nib;
- (void)loadData:(Theme *)theme;

@end
