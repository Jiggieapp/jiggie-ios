//
//  EventsHostingsListCell.h
//  PartyHost
//
//  Created by Sunny Clark on 2/15/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHImage.h"

@interface EventsHostingsListCell : UITableViewCell

@property(nonatomic,strong) SharedData *sharedData;
@property(nonatomic,strong) NSMutableDictionary *mainDict;
@property(nonatomic,strong) NSMutableDictionary *userDict;

@property(nonatomic,strong) UILabel *nameTitle;
@property(nonatomic,strong) UserBubble *userImg;
@property(nonatomic,strong) UILabel *interestedLabel;
@property(nonatomic,strong) UILabel *offeringLabel;
@property(nonatomic,strong) UILabel *verifiedLabel;
@property(nonatomic,strong) UIView *offeringContainer;

-(void)loadData:(NSMutableDictionary *)mainDict userDict:(NSMutableDictionary *)userDict;

@end
