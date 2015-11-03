//
//  BookTableDetails.h
//  PartyHost
//
//  Created by Tony Suriyathep on 7/15/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookTableDetailsCell.h"

@class BookTable;

@interface BookTableDetails : UIView <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) SharedData *sharedData;

@property (strong, nonatomic) UIButton *btnCancel;
@property (strong, nonatomic) UIButton *btnHelp;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *subtitle;
@property (strong, nonatomic) UILabel *descriptionLabel;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *btnHost;
@property (strong, nonatomic) UIView *centerText;
@property (strong, nonatomic) UIView *tableSeparator;

-(void)initClass;

@end
