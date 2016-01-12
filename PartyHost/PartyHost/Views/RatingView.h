//
//  RatingView.h
//  PartyHost
//
//  Created by Tony Suriyathep on 5/14/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RatingView : UIView

@property(nonatomic,assign) float stars;
@property(nonatomic,strong) NSMutableArray *starImages;

-(void)updateRating:(UIColor*)tint stars:(float)stars;

@end
