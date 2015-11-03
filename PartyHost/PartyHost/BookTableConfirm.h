//
//  BookTableConfirm.h
//  PartyHost
//
//  Created by Tony Suriyathep on 7/15/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookTableConfirm : UIView <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (strong, nonatomic) SharedData *sharedData;

@property (strong, nonatomic) UIButton *btnCancel;
@property (strong, nonatomic) UIButton *btnHelp;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *subtitle;
@property (strong, nonatomic) UIView *centerText;
@property (strong, nonatomic) UIView *tableSeparator;
@property (strong, nonatomic) UILabel *agreeLabel;
@property (strong, nonatomic) UIButton *btnPurchase;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) SelectionCheckmark *checkmarkAgree;
@property (strong, nonatomic) NSMutableArray *checkmarkPurchases;
@property (strong, nonatomic) NSMutableArray *checkmarkValues;

-(void)initClass;

@end
