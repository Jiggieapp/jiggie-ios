//
//  AnalyticManager.h
//  Jiggie
//
//  Created by Setiady Wiguna on 12/14/15.
//  Copyright © 2015 Sunny Clark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnalyticManager : NSObject

+ (AnalyticManager *)sharedManager;
- (void)startAnalytics;

@end
