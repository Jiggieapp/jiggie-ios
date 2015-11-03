//
//  VenueListCell.h
//  PartyHost
//
//  Created by Sunny Clark on 2/4/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHImage.h"

@interface VenueListCell : UITableViewCell

@property (strong, nonatomic) SharedData    *sharedData;

@property(nonatomic,strong) UILabel         *date;
@property(nonatomic,strong) UILabel         *title;
@property(nonatomic,strong) UILabel         *subtitle;
@property(nonatomic,strong) PHImage         *bkImage;


@end
