//
//  EventsHeader.h
//  PartyHost
//
//  Created by Sunny Clark on 2/12/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventsHeader : UITableViewCell

@property (strong, nonatomic) SharedData    *sharedData;

@property (strong, nonatomic) UILabel       *sectionHeaderLabel;

@property (strong, nonatomic) UIButton      *btnDown;
@property (strong, nonatomic) UIButton      *btnUp;

@end
