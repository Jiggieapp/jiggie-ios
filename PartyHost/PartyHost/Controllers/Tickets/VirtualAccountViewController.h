//
//  VirtualAccountViewController.h
//  Jiggie
//
//  Created by Setiady Wiguna on 3/14/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "BaseViewController.h"

@interface VirtualAccountViewController : BaseViewController

@property (nonatomic, strong) UIView *navBar;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *transferTime;
@property (nonatomic, strong) UILabel *transferAmount;
@property (nonatomic, strong) UILabel *transferTo;
@property (nonatomic, strong) EmptyView *emptyView;

@property (nonatomic, strong) UIView *line2Vertical;

@property (nonatomic, assign) BOOL showCloseButton;
@property (nonatomic, assign) BOOL showOrderButton;
@property (nonatomic, assign) BOOL isModalScreen;
@property (nonatomic, assign) CGFloat listY;
@property (nonatomic, strong) NSString *VAType;
@property (nonatomic, strong) NSString *orderID;
@property (nonatomic, strong) NSDictionary *successData;

@end
