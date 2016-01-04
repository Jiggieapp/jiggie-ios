//
//  MemberReviewCell.h
//  PartyHost
//
//  Created by Tony Suriyathep on 5/13/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"
#import "PHImage.h"
#import "NSDate+TimeAgo.h"

@interface MemberReviewCell : UITableViewCell

@property (strong, nonatomic) SharedData *sharedData;
@property (strong, nonatomic) NSMutableDictionary *reviewData;
@property (strong, nonatomic) UILabel *memberName;
@property (strong, nonatomic) UILabel *reviewDate;
@property (strong, nonatomic) PHImage *memberIcon;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIView *separator;
@property (nonatomic,strong) RatingView *ratingView;

-(void)setReview:(NSMutableDictionary*)data;

-(void)clearData;


@end
