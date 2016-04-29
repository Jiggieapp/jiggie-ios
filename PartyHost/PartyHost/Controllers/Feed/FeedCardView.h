//
//  FeedCardView.h
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 4/25/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Feed;
@class FeedCardView;
@protocol FeedCardViewDelegate <NSObject>

@required
- (void)feedCardView:(FeedCardView *)view didTapButton:(UIButton *)button withFeed:(Feed *)feed;
- (void)feedCardView:(FeedCardView *)view didTapPersonImageButton:(UIButton *)button withFeed:(Feed *)feed;
- (void)feedCardView:(FeedCardView *)view didTapEventNameLabel:(UILabel *)label withFeed:(Feed *)feed;

@end

@class Feed;
@interface FeedCardView : UIView

@property (weak, nonatomic) id<FeedCardViewDelegate> delegate;

@property (strong, nonatomic, readonly) Feed *feed;

@property (strong, nonatomic) IBOutlet UIButton *personImageButton;
@property (strong, nonatomic) IBOutlet UILabel *interestLabel;
@property (strong, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *connectLabel;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *okButton;
@property (strong, nonatomic) IBOutlet UIView *messageIconView;

+ (FeedCardView *)instanceFromNib;

- (void)configureCardWithFeed:(Feed *)feed;

@end
