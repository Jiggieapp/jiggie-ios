//
//  BookTableDetailsCreditCell.h
//  PartyHost
//
//  Created by Tony Suriyathep on 8/24/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookTableConfirmCreditCell : UITableViewCell

@property (strong, nonatomic) SharedData *sharedData;

@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *note;

//-(void)populateData:(NSMutableDictionary *)dict;

@end
