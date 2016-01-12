//
//  BookTableDetailsCell.h
//  PartyHost
//
//  Created by Tony Suriyathep on 7/18/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookTableDetailsCell : UITableViewCell

@property (strong, nonatomic) SharedData *sharedData;

@property (strong, nonatomic) UILabel *cost;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *note;

-(void)populateData:(NSMutableDictionary *)dict;

@end
