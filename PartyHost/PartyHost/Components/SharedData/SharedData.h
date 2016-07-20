//
//  SharedData.h
//  PartyHost
//
//  Created by Sunny Clark on 12/26/14.
//  Copyright (c) 2014 Sunny Clark. All rights reserved.
//
#import <sys/sysctl.h>
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "Mixpanel.h"
#import "BadgeView.h"
#import "NWURLConnection.h"
#import "MPTweakInline.h"

@class Messages;
@class FeedView;
@class Profile;
@class More;
@class Settings;
@class MemberProfile;
@class Hostings;
@class Confirmations;
@class Events;
@class HostVenueDetail;
@class PopupView;
@class OverlayView;
@class BookTable;
@class PhoneVerify;
@class CreditCard;
@class SetupView;

@interface SharedData : NSObject

+(SharedData *) sharedInstance;

//Walkthrough
@property(nonatomic,assign) BOOL walkthroughOn; //Walkthrough was shown


@property(nonatomic,strong) NSString *apnToken;

@property(nonatomic,copy) NSString *area_event;
@property(nonatomic,copy) NSString *latlng_location;

@property(nonatomic,strong) NSMutableDictionary *userDict;
@property(nonatomic,strong) NSMutableDictionary *photosDict;
@property(nonatomic,strong) Messages            *messagesPage;
@property(nonatomic,strong) MemberProfile       *memberProfile;
@property(nonatomic,strong) SetupView           *setupPage;
@property(nonatomic,strong) Profile             *profilePage;
@property(nonatomic,strong) More                *morePage;
@property(nonatomic,strong) Settings            *settingsPage;
//@property(nonatomic,strong) Hostings            *hostingsPage;
@property(nonatomic,strong) FeedView            *feedPage;
//@property(nonatomic,strong) Confirmations       *confirmationsPage;
@property(nonatomic,strong) Events              *eventsPage;
@property(nonatomic,strong) BookTable           *bookTable;
@property(nonatomic,strong) NSMutableDictionary *imagesDict;
@property(nonatomic,strong) NSMutableDictionary *facebookImagesDict;
@property(nonatomic,copy) NSString            *appKey;
@property(nonatomic,copy) NSString            *fromMailId;
@property(nonatomic,copy) NSString            *fromMailName;
@property(nonatomic,copy) NSString            *conversationId;

@property(nonatomic,strong) UIButton            *morePageBtnBack;

@property(nonatomic,copy) NSString            *baseAPIURL;

@property(nonatomic,strong) NSMutableArray      *venuesNameList;

@property(nonatomic,strong) NSMutableArray      *keyboardsA;

//@property(nonatomic,strong) UILabel             *unreadLabel;
@property(nonatomic,strong) UIImageView         *chatIcon;
@property(nonatomic,strong) BadgeView           *chatBadge;
@property(nonatomic,strong) UIImageView         *feedIcon;
@property(nonatomic,strong) BadgeView           *feedBadge;

@property(nonatomic,copy) NSString            *fb_id;
@property(nonatomic,copy) NSString            *fb_access_token;
@property(nonatomic,copy) NSString            *ph_token;
@property(nonatomic,copy) NSString            *user_id;
@property(nonatomic,copy) NSString            *account_type;
@property(nonatomic,strong) NSMutableArray      *experiences;

@property(nonatomic,copy) NSString            *review_fb_id;

@property(nonatomic,copy) NSString            *member_fb_id;
@property(nonatomic,copy) NSString            *member_user_id;
@property(nonatomic,copy) NSString            *member_first_name;

@property(nonatomic,strong) NSString            *imdowntext;

@property(nonatomic,strong) NSMutableDictionary *cHostDict;
@property(nonatomic,copy) NSString            *cHostVenuePicURL;
@property(nonatomic,copy) NSString            *cEventsDatesStrg;
@property(nonatomic,copy) NSString            *cVenueName;
@property(nonatomic,strong) UIImage             *cVenueImage;

@property(nonatomic,copy) NSString            *cHost_fb_id;
@property(nonatomic,copy) NSString            *cHosting_id;
@property(nonatomic,assign) int                 cHost_index;
@property(nonatomic,strong) NSIndexPath         *cHost_index_path;

@property(nonatomic,copy) NSString            *cInitHosting_id;


@property(nonatomic,copy) NSString            *cEventId_toLoad;

@property(nonatomic,copy) NSString            *cEventId_Feed;

@property(nonatomic,copy) NSString            *cEventId_Modal;

@property(nonatomic,copy) NSString            *cEventId_Summary;



@property(nonatomic,copy) NSString            *btnYesTxt;
@property(nonatomic,copy) NSString            *btnNOTxt;

@property(nonatomic,strong) UIButton            *btnPhoneVerifyCancel;

@property(nonatomic,copy) NSString            *ABTestChat;

@property(nonatomic,copy) NSString            *cFillType;
@property(nonatomic,copy) NSString            *cFillValue;


@property(nonatomic,copy) NSString            *cEventId;

@property(nonatomic,assign) int                 messageFontSize;
@property(nonatomic,assign) int                 osVersion;

@property(nonatomic,assign) int                 cVenueListIndex;

@property(nonatomic,assign) int                 cPageIndex;

@property(nonatomic,assign) BOOL                isInFeed;
@property(nonatomic,assign) BOOL                matchMe;



@property(nonatomic,strong) NSMutableDictionary *selectedHost;
@property(nonatomic,strong) NSMutableDictionary *selectedEvent;


@property(nonatomic,strong) NSMutableDictionary *mixPanelCEventDict;
@property(nonatomic,strong) NSMutableDictionary *mixPanelCTicketDict;

@property(nonatomic,copy) NSString            *mostRecentEventSelectedId;

@property(nonatomic,copy) NSString            *cGuestId;
@property(nonatomic,copy) NSString            *cHostingIdFromInvite;

@property(nonatomic,copy) NSString            *cInviteName;
@property(nonatomic,assign) BOOL                cameFromEventsTab;

@property(nonatomic,copy) NSString            *APN_STATE;


@property(nonatomic,copy) NSString            *APN_PERMISSION_STATE;


@property(nonatomic,assign) int                 maxProfilePics;

@property(nonatomic,assign) BOOL                isInConversation;
@property(nonatomic,assign) BOOL                hasMessageToLoad;
@property(nonatomic,assign) BOOL                hasFeedToLoad;


@property(nonatomic,assign) BOOL                isInAskingNotification;

@property(nonatomic,assign) BOOL                isLoggedIn;


@property(nonatomic,assign) BOOL                didAppsFlyerLoad;

@property(nonatomic,assign) int                 screenWidth;
@property(nonatomic,assign) int                 screenHeight;


@property(nonatomic,assign) int                 unreadChatCount;
@property(nonatomic,assign) int                 unreadFeedCount;


@property(nonatomic,strong) NSString            *phoneCountry;


@property(nonatomic,assign) BOOL                isIphone4;
@property(nonatomic,assign) BOOL                isIphone5;
@property(nonatomic,assign) BOOL                isIphone6;
@property(nonatomic,assign) BOOL                isIphone6plus;
@property(nonatomic,copy) NSString            *deviceType;

@property(nonatomic,assign) BOOL                hasInitEventSelection;

@property(nonatomic,strong) NSMutableDictionary *tapDict;

@property(nonatomic,strong) NSMutableDictionary *appsFlyerDict;

@property(nonatomic,copy) NSString            *toImgURL;



@property(nonatomic,copy) NSString            *cShareHostingId;

//Feed cell height
@property(nonatomic,assign) int                 feedCellHeightShort; //No image or buttons
@property(nonatomic,assign) int                 feedCellHeightLong; //Venue image with buttons

//Member review side padding
@property(nonatomic,assign) int                 memberReviewSidePadding;
@property(nonatomic,assign) int                 memberReviewFontSize;

@property(nonatomic,assign) BOOL                isGuestListingsShowing;

//Member write review
@property(nonatomic,strong) NSMutableDictionary *memberProfileDict; //Point to the dict, incase we need to write reviews

//Store which event was clicked for adding hosting
@property(nonatomic,strong) NSMutableDictionary *cAddEventDict;
@property(nonatomic,strong) NSMutableDictionary *eventDict; //On click events screen, store data

//Show host venue details as a push view
@property(nonatomic,strong) HostVenueDetail     *hostVenueDetailPage; //Shows host shoutout with venue details

@property(nonatomic,strong) CLLocationManager     *locationManager;

//Just for shared link
@property(nonatomic,copy) NSString            *shareHostingId; //hosting_id
@property(nonatomic,copy) NSString            *shareHostingHostFbId; //host fb_id
@property(nonatomic,copy) NSString            *shareHostingHostName; //host first_name
@property(nonatomic,copy) NSString            *shareHostingVenueName; //venue_name
@property(nonatomic,copy) NSString            *shareHostingHostDate; //hosting date

//feed match
@property(nonatomic,copy) NSString            *feedMatchEvent;
@property(nonatomic,copy) NSString            *feedMatchImage;

-(NSString*)capitalizeFirstLetter:(NSString *)strg;

-(UIColor*)colorWithHexString:(NSString*)hex;

-(CGSize)sizeForLabelString:(NSString *)text withFont:(UIFont *)font andMaxSize:(CGSize)maxSize;

-(void)loadImage:(NSString *)imgURL onCompletion:(void (^)(void))completionHandler;
-(void)loadImageCue:(NSString *)imgURL;

-(BOOL)contentTypeForImageData:(NSData *)data;
-(void)clearKeyBoards;
- (NSDictionary *)parseQueryString:(NSString *)query;

-(NSString *)clipSpace:(NSString *)strg;

-(NSString *)picURL:(NSString *)url;
-(NSString *)profileImg:(NSString *)fb_id;
-(NSString *)profileImgLarge:(NSString *)fb_id;
-(void)updateBadgeIcon;

//Extra views
@property(nonatomic,strong) PopupView *popupView;
@property(nonatomic,strong) OverlayView *overlayView;

//Book table
@property(nonatomic,strong) PhoneVerify *phoneVerify;
@property(nonatomic,strong) NSString *help_phone;
@property(nonatomic,strong) CreditCard *creditCard;

//Settings
@property(nonatomic,assign) BOOL notification_feed;
@property(nonatomic,assign) BOOL notification_messages;
@property(nonatomic,assign) BOOL location_on;
@property(nonatomic,assign) BOOL has_phone;
@property(nonatomic,copy) NSString *phone;
@property(nonatomic,copy) NSString *ccType;
@property(nonatomic,copy) NSString *ccLast4;
@property(nonatomic,copy) NSString *ccName;
-(NSDictionary*)createSaveSettingsParams;
-(void)loadSettingsResponse:(NSDictionary *)dict;
-(void)saveSettingsResponse;

//===================================================================================================//
//SOCIAL FILTER
@property(nonatomic,copy) NSString *gender;
@property(nonatomic,copy) NSString *gender_interest;
@property(nonatomic,copy) NSString *distance;
@property(nonatomic,copy) NSString *from_age;
@property(nonatomic,copy) NSString *to_age;
-(BOOL)isGuest;
-(BOOL)isHost;
-(BOOL)isMember;
-(void)calculateDefaultGenderSettings; //Calc account_type and gender_interest based on gender
//===================================================================================================//

//SPECIAL LOAD WITH CANCEL
- (NWURLConnection*)loadImageCancelable:(NSString *)imgURL completionBlock:(void (^)(UIImage *image))completionBlock;
//===================================================================================================//

- (void)syncSuperPropertiesOnServer:(NSMutableDictionary *)dict;

- (AFHTTPRequestOperationManager *)getOperationManager;
- (void)loginWithFBToken:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)loadTimeImage:(NSString *)imgURL withTimeOut:(float)time;

- (NSString *)formatCurrencyString:(NSString *)price;
- (BOOL)validateEmailWithString:(NSString*)checkString;

- (NSInteger)calculateAge:(NSString *)birthDate;

@end
