//
//  EventsGuestListCell.h
//  PartyHost
//
//  Created by Sunny Clark on 2/15/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHImage.h"
#import "Events.h"
#import "EventsGuestList.h"
#import "Feed.h"

@interface EventsGuestListCell : UITableViewCell<UIAlertViewDelegate>

@property (strong, nonatomic) SharedData *sharedData;

@property(nonatomic,strong) UILabel *nameTitle;
@property(nonatomic,strong) UserBubble *userImg;
//@property(nonatomic,strong) UILabel *infoBody;
@property(nonatomic,strong) SelectionButton *btnInvite;
@property(nonatomic,strong) NSMutableDictionary *mainDict;
@property(nonatomic,strong) NSMutableDictionary *userDict;

-(void)loadData:(NSMutableDictionary *)mainDict userDict:(NSMutableDictionary *)userDict;

@end
