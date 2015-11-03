//
//  MessageBubbleTriangle.m
//  PartyHost
//
//  Created by Sunny Clark on 1/18/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "MessageBubbleTriangle.h"

@implementation MessageBubbleTriangle


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.isRightSide = YES;
    self.color = [UIColor blackColor];
    
    return self;
}


-(void)drawRect:(CGRect)rect {
    
    
    CAShapeLayer *mask = [[CAShapeLayer alloc] init];
    mask.frame = self.layer.bounds;
    
    CGFloat width = self.layer.frame.size.width;
    CGFloat height = self.layer.frame.size.height;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    
    if(self.isRightSide)
    {
        CGPathMoveToPoint(path, nil, 0, 0);
        CGPathAddLineToPoint(path, nil, width, height * .5);
        CGPathAddLineToPoint(path, nil, 0, height);
        CGPathCloseSubpath(path);
    }else{
        CGPathMoveToPoint(path, nil, 0, height * .5);
        CGPathAddLineToPoint(path, nil, width, height);
        CGPathAddLineToPoint(path, nil, width, 0);
        CGPathCloseSubpath(path);
    }
    
    mask.path = path;
    
    
    self.layer.mask = mask;
    
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.frame = self.bounds;
    shape.path = path;
    shape.lineWidth = 3.0f;
    shape.strokeColor = self.color.CGColor;
    shape.fillColor = self.color.CGColor;
    self.layer.sublayers = nil;
    [self.layer insertSublayer: shape atIndex:0];
    CGPathRelease(path);
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
