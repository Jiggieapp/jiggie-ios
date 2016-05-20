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

@property (weak, nonatomic) IBOutlet UIImageView *emptyIcon;
@property (weak, nonatomic) IBOutlet UILabel *emptyTitle;
@property (weak, nonatomic) IBOutlet UILabel *emptySubtitle;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

+ (UINib *)nib;
- (void)setTitle:(NSString *)title andSubtitle:(NSString *)subtitle andIcon:(UIImage *)icon;
- (void)setMode:(NSString *)mode;

@end
