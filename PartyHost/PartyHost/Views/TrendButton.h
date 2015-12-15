//
//  TrendButton.h
//  PartyHost
//
//  Created by Tony Suriyathep on 7/8/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrendButton : UIButton

- (id)initWithFrame:(CGRect)frame;
- (void)update:(NSString*)title color:(UIColor*)color;
- (void)updateCenterFit:(NSString*)title color:(UIColor*)color;

+ (CGSize)calculateSize:(NSString*)title;

@property(nonatomic,assign) CGRect originalFrame;

@end
