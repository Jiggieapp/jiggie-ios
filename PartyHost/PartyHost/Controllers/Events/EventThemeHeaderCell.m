//
//  EventThemeHeaderCell.m
//  Jiggie
//
//  Created by Setiady Wiguna on 6/17/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "EventThemeHeaderCell.h"
#import "UIImageView+WebCache.h"
#import "Theme.h"

@implementation EventThemeHeaderCell

+ (UINib *)nib {
    return [UINib nibWithNibName:@"EventThemeHeaderCell" bundle:nil];
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
    [self.themeTitleLabel setText:@""];
    [self.themeDescLabel setText:@""];
    
    if (theme) {
        [self.themeImageView sd_setImageWithURL:[NSURL URLWithString:theme.image]];
        [self.themeImageView setFrame:CGRectMake(0, 0, self.bounds.size.width, 60)];
        [self.themeTitleLabel setText:theme.name];
        [self.themeDescLabel setText:theme.desc];        
    }
}

@end
