//
//  BookTableOfferingCell.h
//  PartyHost
//
//  Created by Tony Suriyathep on 7/17/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookTableOfferingCell : UITableViewCell

@property (strong, nonatomic) SharedData *sharedData;

@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *subtitle;
@property (strong, nonatomic) PerkButton *perk;
@property (strong, nonatomic) SelectionCheckmark *check;

-(void)populateData:(NSDictionary *)dict;

@end
