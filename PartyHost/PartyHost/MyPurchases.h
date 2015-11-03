//
//  MyPurchases.h
//  PartyHost
//
//  Created by Tony Suriyathep on 7/22/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPurchasesCell.h"

@interface MyPurchases : UIView <UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIAlertViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong) SharedData *sharedData;
@property(nonatomic,strong) UIView *mainCon;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIButton *btnBack;
@property(nonatomic,strong) UILabel *title;
@property(nonatomic,strong) UIView *tabBar;
@property(nonatomic,strong) NSMutableArray *tableData;
@property(nonatomic,assign) BOOL isLoaded;
@property(nonatomic,strong) UILabel *labelEmpty;

-(void)initClass;

@end
