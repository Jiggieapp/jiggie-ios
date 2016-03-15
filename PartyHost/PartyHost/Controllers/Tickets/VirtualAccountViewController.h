//
//  VirtualAccountViewController.h
//  Jiggie
//
//  Created by Setiady Wiguna on 3/14/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "BaseViewController.h"

@interface VirtualAccountViewController : BaseViewController

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *transferTime;
@property (nonatomic, strong) UILabel *transferAmount;
@property (nonatomic, strong) UILabel *transferTo;

@property (nonatomic, assign) BOOL showCloseButton;
@property (nonatomic, assign) BOOL showOrderButton;
@property (nonatomic, strong) NSString *VAType;

@end
