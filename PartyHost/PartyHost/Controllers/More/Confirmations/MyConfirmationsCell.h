//
//  MyHostingsCell.h
//  PartyHost
//
//  Created by Sunny Clark on 2/4/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyConfirmationsCell : UITableViewCell

@property (strong, nonatomic) SharedData    *sharedData;

@property(nonatomic,strong) UIImageView     *imgIcon;
@property(nonatomic,strong) UILabel         *title;
@property(nonatomic,strong) UILabel         *subtitle;
@property(nonatomic,strong) UILabel         *month;
@property(nonatomic,strong) UILabel         *day;
@property(nonatomic,strong) NSDictionary    *data;
@property(nonatomic,strong) UIActivityIndicatorView *spinner;

-(void)showLoading;
-(void)hideLoading;
-(void)loadData:(NSDictionary *)dict;
-(void)showNone;

@end
