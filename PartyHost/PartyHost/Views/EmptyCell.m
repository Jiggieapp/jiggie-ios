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

- (void)setMode:(NSString *)mode withMessage:(NSString *)message {
    if([mode isEqualToString:@"load"]) {
        [self.activityIndicatorView setHidden:NO];
        [self.activityIndicatorView startAnimating];
        [self.messageLabel setHidden:YES];
        
    } else if([mode isEqualToString:@"empty"]) {
        [self.activityIndicatorView setHidden:YES];
        [self.activityIndicatorView startAnimating];
        [self.messageLabel setHidden:NO];
        
        if (message) {
            [self.messageLabel setText:message];
        } else {
            [self.messageLabel setText:@""];
        }
    }
}

@end
