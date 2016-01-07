//
//  FeedMatch.m
//  Jiggie
//
//  Created by Setiady Wiguna on 1/5/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "FeedMatch.h"
#import "SharedData.h"
#import "Messages.h"

@implementation FeedMatch

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.sharedData = [SharedData sharedInstance];
    
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        self.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = self.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self addSubview:blurEffectView];
    }
    else {
        self.backgroundColor = [UIColor blackColor];
    }
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(4, 20, 50, 50)];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"nav_cancel"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(goCancel) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    
    self.btnUserImage = [[UIButton alloc] initWithFrame:CGRectZero];
    self.btnUserImage.layer.masksToBounds = YES;
    self.btnUserImage.contentMode = UIViewContentModeScaleAspectFill;
    self.btnUserImage.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.btnUserImage.layer.cornerRadius = 50;
    [self.btnUserImage addTarget:self action:@selector(btnUserImageDidTap) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnUserImage];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.userInteractionEnabled = NO;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.text = @"It's a match!";
    [self addSubview:self.titleLabel];
    
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
    self.descriptionLabel.textColor = [UIColor whiteColor];
    self.descriptionLabel.userInteractionEnabled = NO;
    self.descriptionLabel.backgroundColor = [UIColor clearColor];
    self.descriptionLabel.numberOfLines = 0;
    [self addSubview:self.descriptionLabel];
    
    self.startChatButton = [[UIButton alloc] initWithFrame:CGRectZero];
    self.startChatButton.backgroundColor = [UIColor phBlueColor];
    [self.startChatButton setTitle:@"Start Chatting" forState:UIControlStateNormal];
    [self.startChatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.startChatButton.layer.cornerRadius = 20;
    [self.startChatButton addTarget:self action:@selector(startChatButtonDidTap) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.startChatButton];
    
    self.continueButton = [[UIButton alloc] initWithFrame:CGRectZero];
    self.continueButton.backgroundColor = [UIColor clearColor];
    [self.continueButton setTitle:@"Continue" forState:UIControlStateNormal];
    [self.continueButton setTitleColor:[UIColor phBlueColor] forState:UIControlStateNormal];
    [self.continueButton addTarget:self action:@selector(continueButtonDidTap) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.continueButton];
    
    return self;
}

-(void)initClass
{
    self.fromFBId = self.sharedData.messagesPage.toId;
    self.fromFirstName = self.sharedData.messagesPage.toLabel.text;
    self.eventName = self.sharedData.feedMatchEvent;
    
//    self.sharedData.conversationId = self.sharedData.fromMailId;
//    self.sharedData.messagesPage.toId = self.sharedData.fromMailId;
//    self.sharedData.messagesPage.toLabel.text = [self.sharedData.fromMailName uppercaseString];
//    self.sharedData.toImgURL = [self.sharedData profileImg:self.sharedData.fromMailId];
//    [[NSNotificationCenter defaultCenter]
//     postNotificationName:@"SHOW_MESSAGES"
//     object:self];
    
    [self loadData];
}

-(void)reset
{
    self.fromFBId = @"";
    self.fromFirstName = @"";
    self.eventName = @"";
    
}

-(void)goCancel
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"EXIT_FEED_MATCH"
     object:self];
}

- (void)btnUserImageDidTap {
    self.sharedData.member_fb_id = self.fromFBId;
    self.sharedData.member_user_id = self.fromFBId;
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_MEMBER_PROFILE"
     object:self];
}

- (void)startChatButtonDidTap {
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_MESSAGES"
     object:self];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"EXIT_FEED_MATCH"
     object:self];
    
}

- (void)continueButtonDidTap {
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"EXIT_FEED_MATCH"
     object:self];
}

-(void)loadData {
    
    int lineSpacing = 20;
    int OffsetFontLargeDevice = 0;
    int startY = 120;
    
    if (self.sharedData.isIphone4) {
        startY = 80;
    } else if (self.sharedData.isIphone6) {
        lineSpacing = 30;
        OffsetFontLargeDevice = 1;
    } else if (self.sharedData.isIphone6plus) {
        lineSpacing = 40;
        OffsetFontLargeDevice = 3;
    }
    
    [self.btnUserImage setFrame:CGRectMake((self.bounds.size.width - 100)/2, startY, 100, 100)];
    
    NSString *usrImgURL = [self.sharedData profileImgLarge:self.fromFBId];
    [self.sharedData loadImage:usrImgURL onCompletion:^(){
        [self.btnUserImage setImage:[self.sharedData.imagesDict objectForKey:usrImgURL] forState:UIControlStateNormal];
        self.btnUserImage.contentMode = UIViewContentModeScaleAspectFill;
        self.btnUserImage.imageView.contentMode = UIViewContentModeScaleAspectFill;

    }];
    
    [self.titleLabel setFrame:CGRectMake(0, CGRectGetMaxY(self.btnUserImage.frame) + 1.5*lineSpacing, self.bounds.size.width, 20)];
    self.titleLabel.font = [UIFont phBold:18 + OffsetFontLargeDevice];
    
    [self.descriptionLabel setFrame:CGRectMake(40, CGRectGetMaxY(self.titleLabel.frame) + lineSpacing, self.bounds.size.width - 60,60)];
    self.descriptionLabel.font = [UIFont phBlond:14 + OffsetFontLargeDevice];
    
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:
                                           [NSString stringWithFormat:@"You and %@ were matched because your interest in %@", self.fromFirstName, self.eventName]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineHeightMultiple:1.5f];
    [paragraphStyle setLineSpacing:2.5f];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [attrText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrText.length)];
    self.descriptionLabel.attributedText = attrText;
    [self.descriptionLabel sizeToFit];
    
    [self.startChatButton setFrame:CGRectMake((self.bounds.size.width - 240)/2, CGRectGetMaxY(self.descriptionLabel.frame) + 1.5*lineSpacing, 240, 40)];
    self.startChatButton.titleLabel.font = [UIFont phBold:14 + OffsetFontLargeDevice];
    
    [self.continueButton setFrame:CGRectMake((self.bounds.size.width - 100)/2, CGRectGetMaxY(self.startChatButton.frame) + lineSpacing/2, 100, 40)];
    self.continueButton.titleLabel.font = [UIFont phBold:14 + OffsetFontLargeDevice];
}

@end
