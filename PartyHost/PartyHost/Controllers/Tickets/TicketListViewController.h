//
//  TicketListViewController.h
//  Jiggie
//
//  Created by Setiady Wiguna on 2/3/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "BaseViewController.h"
#import "Event.h"

@interface TicketListViewController : BaseViewController

@property (nonatomic, strong) Event *cEvent;
@property (strong, nonatomic) SharedData *sharedData;

@end
