//
//  EmptyCell.m
//  Jiggie
//
//  Created by Setiady Wiguna on 5/11/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "EmptyCell.h"

NSString *const EmptyTableViewCellIdentifier = @"EmptyTableViewCellIdentifier";

@implementation EmptyCell

+ (UINib *)nib {
    return [UINib nibWithNibName:@"EmptyCell" bundle:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending) {
        [self.contentView setTranslatesAutoresizingMaskIntoConstraints:YES];
        self.contentView.frame = self.bounds;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitle:(NSString *)title andSubtitle:(NSString *)subtitle andIcon:(UIImage *)icon {
    if (title && title != nil) {
        [self.emptyTitle setText:title];
    } else {
        [self.emptyTitle setText:@""];
    }
    
    if (subtitle && subtitle != nil) {
        [self.emptySubtitle setText:subtitle];
    } else {
        [self.emptySubtitle setText:@""];
    }
    
    [self.emptyIcon setImage:icon];
}

- (void)setMode:(NSString *)mode {
    if([mode isEqualToString:@"load"]) {
        [self.activityIndicatorView setHidden:NO];
        [self.activityIndicatorView startAnimating];
        [self.emptyTitle setHidden:YES];
        [self.emptySubtitle setHidden:YES];
        [self.emptyIcon setHidden:YES];
        
    } else if([mode isEqualToString:@"empty"]) {
        [self.activityIndicatorView setHidden:YES];
        [self.activityIndicatorView startAnimating];
        [self.emptyTitle setHidden:NO];
        [self.emptySubtitle setHidden:NO];
        [self.emptyIcon setHidden:NO];
    }
}

@end
