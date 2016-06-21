//
//  EventsThemeCell.m
//  Jiggie
//
//  Created by Setiady Wiguna on 6/15/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "EventsThemeCell.h"
#import "UIImageView+WebCache.h"
#import "Theme.h"

@implementation EventsThemeCell

+ (UINib *)nib {
    return [UINib nibWithNibName:@"EventsThemeCell" bundle:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadData:(Theme *)theme {
    [self.themeImageView setImage:nil];
    
    if (theme) {
        [self.themeImageView sd_setImageWithURL:[NSURL URLWithString:theme.image]];
    }
}

@end
