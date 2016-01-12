//
//  WriteReview.h
//  PartyHost
//
//  Created by Tony Suriyathep on 5/15/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"

@interface WriteReview : UIView <UITextViewDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) SharedData *sharedData;
@property (strong, nonatomic) UIView *mainCon;
@property (strong, nonatomic) UIScrollView *mainScroll;
@property (strong, nonatomic) UIView *tabBar;
@property (strong, nonatomic) UILabel *tabTitle;
@property (strong, nonatomic) UIButton *btnPost;
@property (strong, nonatomic) UIButton *btnCancel;
@property (strong, nonatomic) RatingView *ratingView;
//@property (strong, nonatomic) UILabel *ratingText;
@property (strong, nonatomic) UITextView *messageText;
@property (strong, nonatomic) UIButton *btnSubmit;


@property (assign, nonatomic) int       numStars;

-(void)initClass;
-(void)exitHandler;

@end
