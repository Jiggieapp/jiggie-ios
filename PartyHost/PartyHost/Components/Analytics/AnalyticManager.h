//
//  AnalyticManager.h
//  Jiggie
//
//  Created by Setiady Wiguna on 12/14/15.
//  Copyright © 2015 Sunny Clark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnalyticManager : NSObject

@property(nonatomic, strong) SharedData *sharedData;

+ (AnalyticManager *)sharedManager;
- (void)startAnalytics;

//=============MixPanel==============================================================================//
-(void)setMixPanelSuperProperties;
-(void)setMixPanelOnceParams;
-(void)setMixPanelOnSignUp;
-(void)setMixPanelUserProfile;
-(void)setMixPanelOnLogin;
-(void)trackMixPanel:(NSString *)eventName;
-(void)trackMixPanelWithDict:(NSString *)eventName withDict:(NSDictionary *)dict;
-(void)trackMixPanelIncrementWithDict:(NSDictionary *)dict;
-(void)trackMixPanelIncrementWithEventDict:(NSDictionary *)eventDict;
-(void)createMixPanelDummyProfile;
//===================================================================================================//

@end
