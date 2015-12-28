//
//  BookTableOffering.h
//  PartyHost
//
//  Created by Tony Suriyathep on 7/17/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookTableOfferingCell.h"

@class BookTable;

@interface BookTableOffering : UIView <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) SharedData *sharedData;
@property (strong, nonatomic) NSMutableArray *mainArray;

@property (strong, nonatomic) UIButton *btnCancel;
@property (strong, nonatomic) UIButton *btnHelp;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *subtitle;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *btnContinue;

-(void)initClass;
-(void)reset;

@end
