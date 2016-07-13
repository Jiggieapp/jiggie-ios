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
    
    if ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending) {
        [self.contentView setTranslatesAutoresizingMaskIntoConstraints:YES];
        self.contentView.frame = self.bounds;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
        
        [self.themeDescLabel setPreferredMaxLayoutWidth:304];
    }
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

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat pictureHeightRatio = 3.0 / 4.0;
    CGFloat imageContentHeight = pictureHeightRatio * self.contentView.bounds.size.width;
    self.imageConstraintHeight.constant = imageContentHeight;
}

@end
