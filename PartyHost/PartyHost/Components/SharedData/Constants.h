//
//  Constants.h
//  PartyHost
//
//  Created by Tony Suriyathep on 6/19/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#ifndef PartyHost_Constants_h
#define PartyHost_Constants_h
#define PHVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

//Others
extern BOOL const PHDebugOn; //Pretend we are a new user in debug mode, they will see walkthrough, alerts etc.
extern int const PHTabHeight;
extern int const PHButtonHeight;
extern BOOL const PHMixPanelOn;

//App Dev Key
extern NSString *const MixpanelDevKey;
extern NSString *const AppsFlyerDevKey;

extern NSString *const JiggieItunesID;

//URL
extern NSString *const PHBaseURL;
extern NSString *const PHBaseDomain;
extern NSString *const PHGuestListingsURL;
extern NSString *const PHHostListingsURL;
extern NSString *const PHEventsURL;
extern NSString *const PHEventImageURL;
extern NSString *const PHEventProductsURL;
extern NSString *const PHDateFormatShort;
extern NSString *const PHTicketAddURL;
extern NSString *const PHMemberSettingsURL;
extern NSString *const PHMemberInfoURL;
extern NSString *const PHUserTagListURL;
extern NSString *const PHOrdersAllURL;
extern NSString *const PHDateFormatServer;
extern NSString *const PHPhoneVerifySendURL;
extern NSString *const PHPhoneVerifyValidateURL;
extern NSString *const PHUserPaymentURL;
extern NSString *const PHMemberMutualFriendsURL;
extern NSString *const PHBlankImgURL;

@interface Constants : NSObject {}

+(NSString*)userPaymentURL:(NSString*)fb_id;
+(NSString*)hostingsAddURL:(NSString*)fb_id event_id:(NSString*)event_id;
+(NSString*)guestListingsURL:(NSString*)event_id fb_id:(NSString*)fb_id;
+(NSString*)hostListingsURL:(NSString*)event_id fb_id:(NSString*)fb_id;
+(NSString*)eventsURL:(NSString*)account_type fb_id:(NSString*)fb_id;
+(NSString*)eventImageURL:(NSString*)event_id;
+(NSString*)eventProductsURL:(NSString*)event_id;
+(NSString*)ticketAddURL:(NSString*)fb_id event_id:(NSString*)event_id;
+(NSString*)guestEventsViewedURL:(NSString*)fb_id fb_id:(NSString*)event_id;
+(NSString*)fbProfileImageURL:(NSString*)fb_id;
+(NSString*)toDisplayDate:(NSString*)dbStartDateString;
+(NSString*)toDisplayDateRange:(NSString*)dbStartDateString dbEndDateString:(NSString*)dbEndDateString;
+(NSString*)toDisplayTime:(NSString*)dbStartDateString;
+(NSString*)toTitleDate:(NSString*)dbStartDateString;
+(NSString*)toTitleDateRange:(NSString*)dbStartDateString dbEndDateString:(NSString*)dbEndDateString;
+(NSString*)userTagListURL;
+(NSString*)memberSettingsURL;
+(NSString*)memberInfoURL:(NSString*)account_type member_fb_id:(NSString*)member_fb_id fb_id:(NSString*)fb_id;
+(NSString*)ordersAllURL:(NSString*)fb_id;
+(NSString*)phoneVerifySendURL:(NSString*)fb_id phone:(NSString*)phone;
+(NSString*)phoneVerifyValidateURL:(NSString*)fb_id token:(NSString*)token;
+(NSString*)formatPhoneNumber:(NSString*)simpleNumber;
+(NSString*)memberMutualFriendsURL:(NSString*)fb_id member_fb_id:(NSString*)member_fb_id;

@end

#endif