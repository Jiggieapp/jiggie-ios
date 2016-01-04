//
//  MyPurchasesCell.h
//  PartyHost
//
//  Created by Tony Suriyathep on 7/22/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPurchasesCell : UITableViewCell

@property (strong, nonatomic) SharedData    *sharedData;

@property(nonatomic,strong) UIImageView     *imgIcon;
@property(nonatomic,strong) UILabel         *title;
@property(nonatomic,strong) UILabel         *subtitle;
@property(nonatomic,strong) UILabel         *month;
@property(nonatomic,strong) UILabel         *day;
@property(nonatomic,strong) NSDictionary    *data;

-(void)loadData:(NSDictionary *)dict;

@end
