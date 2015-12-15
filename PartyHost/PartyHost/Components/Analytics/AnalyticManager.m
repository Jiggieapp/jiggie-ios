//
//  AnalyticManager.m
//  Jiggie
//
//  Created by Setiady Wiguna on 12/14/15.
//  Copyright © 2015 Sunny Clark. All rights reserved.
//

#import "AnalyticManager.h"
#import <AdSupport/ASIdentifierManager.h>
#import "Mixpanel.h"
#import "AppsFlyerTracker.h"

@implementation AnalyticManager

static AnalyticManager *_sharedManager = nil;

+ (AnalyticManager *)sharedManager {
    @synchronized([AnalyticManager class])
    {
        if (!_sharedManager) {
            _sharedManager = [[AnalyticManager alloc] init];
        }
        return _sharedManager;
    }
    
    return nil;
}

#pragma mark - Start
- (void)startAnalytics {
    NSString *idfaString = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [AppsFlyerTracker sharedTracker].appsFlyerDevKey = AppsFlyerDevKey;
    [AppsFlyerTracker sharedTracker].appleAppID = JiggieItunesID;
    [AppsFlyerTracker sharedTracker].customerUserID = idfaString;
    
    [Mixpanel sharedInstanceWithToken:MixpanelDevKey];
}

@end
