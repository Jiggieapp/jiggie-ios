//
//  SocialFilterView.h
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 4/28/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocialFilterView : UIView

@property (strong, nonatomic, readonly) NSArray *filters;

+ (SocialFilterView *)instanceFromNib;

@end
