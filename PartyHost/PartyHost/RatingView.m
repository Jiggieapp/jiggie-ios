//
//  RatingView.m
//  PartyHost
//
//  Created by Tony Suriyathep on 5/14/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "RatingView.h"


@implementation RatingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    //self.backgroundColor = [UIColor redColor];
    if (self) {
        float viewWidth = self.frame.size.width;
        float viewHeight = self.frame.size.height;
        float starWidth = self.frame.size.height;
        float starHeight = self.frame.size.height;
        float widthIncrement = (viewWidth - starWidth)/4.0;
        
        //Create star images
        self.starImages = [[NSMutableArray alloc] initWithCapacity:5];
        for (int i = 0; i < 5; i++)
        {
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake((widthIncrement*i),(viewHeight/2)-(starHeight/2),starWidth,starHeight)];
            iv.tag = i+1;
            [self.starImages addObject:iv];
            [self addSubview:iv];
        }
    }
    return self;
}

-(void)updateRating:(UIColor*)tint stars:(float)stars
{
    for (int i = 0; i < 5; i++)
    {
        UIImageView *iv = [self.starImages objectAtIndex:i];
        
        if(stars>=1.0)
        {
            iv.image = [UIImage imageNamed:@"star_full"];
            if(tint!=nil) {
                iv.image = [iv.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                iv.tintColor = tint;
            }
            iv.alpha = 1.0;
        }
        else if(stars>0 && stars<1)
        {
            iv.image = [UIImage imageNamed:@"star_half"];
            if(tint!=nil) {
                iv.image = [iv.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                iv.tintColor = tint;
                iv.alpha = 0.75;
            }
            else iv.alpha = 1.0;
        }
        else if(stars<=0)
        {
            iv.image = [UIImage imageNamed:@"star_empty"];
            if(tint!=nil) {
                iv.image = [iv.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                iv.tintColor = tint;
                iv.alpha = 0.35;
            }
            else iv.alpha = 1.0;
        }
        
        stars -= 1.0;
    }
}

@end
