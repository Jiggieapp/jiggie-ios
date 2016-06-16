//
//  EventsTheme.h
//  Jiggie
//
//  Created by Setiady Wiguna on 6/14/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventsTheme : UIView

@property (strong, nonatomic) SharedData *sharedData;

@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) UILabel *titleLabel;

@end