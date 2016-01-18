//
//  FeedMatch.h
//  Jiggie
//
//  Created by Setiady Wiguna on 1/5/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedMatch : UIView

@property(nonatomic,strong) UIButton *btnUserImage;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *descriptionLabel;
@property(nonatomic,strong) UIButton *startChatButton;
@property(nonatomic,strong) UIButton *continueButton;

@property(strong,nonatomic) SharedData *sharedData;
@property(nonatomic,strong) NSString *fromFBId;
@property(nonatomic,strong) NSString *fromFirstName;
@property(nonatomic,strong) NSString *eventName;


-(void)initClass;
-(void)reset;

@end
