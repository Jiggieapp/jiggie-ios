//
//  EmptyCell.h
//  Jiggie
//
//  Created by Setiady Wiguna on 5/11/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const EmptyTableViewCellIdentifier;

@interface EmptyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

+ (UINib *)nib;
- (void)setMode:(NSString *)mode withMessage:(NSString *)message;

@end
