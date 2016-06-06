//
//  UserBubble.h
//  PartyHost
//
//  Created by Tony Suriyathep on 7/14/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NWURLConnection.h"

@interface UserBubble : UIButton

@property(nonatomic,strong) NSString *fb_id;
@property(nonatomic,strong) NSString *url;
@property(nonatomic,strong) NSString *initials;
@property(nonatomic,strong) NWURLConnection *connection; //This can be canceled

- (id)initWithFrame:(CGRect)frame;
- (void)loadPicture:(NSString *)picURL;
- (void)reset; //Cancel and revert to facebook default image
- (void)loadImage:(NSString*)url; //Load any image
- (void)loadFacebookImage:(NSString*)fb_id; //Load a facebook image
- (void)loadProfileImage:(NSString*)fb_id; //Load first image from member info
- (void)cancel; //Cancels an existing load
- (void)setName:(NSString*)firstName lastName:(NSString*)lastName;

@end
