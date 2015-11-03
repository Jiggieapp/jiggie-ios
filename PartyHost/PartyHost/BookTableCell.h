//
//  BookTableCell.h
//  PartyHost
//
//  Created by Tony Suriyathep on 7/16/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "PerkButton.h"

@interface BookTableCell : UITableViewCell

@property (strong, nonatomic) SharedData *sharedData;

@property (strong, nonatomic) UILabel *cost;
@property (strong, nonatomic) UILabel *perPerson;
@property (strong, nonatomic) UILabel *note;
@property (strong, nonatomic) PerkButton *perk;

-(void)populateData:(NSMutableDictionary *)dict;

@end
