//
//  TrendButton.m
//  PartyHost
//
//  Created by Tony Suriyathep on 7/8/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "TrendButton.h"

@implementation TrendButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.originalFrame = frame;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont phBold:9];
        self.backgroundColor = [UIColor phPurpleColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self setTitleEdgeInsets:UIEdgeInsetsMake(5, 8, 3, 8)];
        [self setTitle:@"TRENDING EVENT" forState:UIControlStateNormal];
    }
    return self;
}

- (void)update:(NSString*)title color:(UIColor*)color {
    self.backgroundColor = color;
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)updateCenterFit:(NSString*)title color:(UIColor*)color {
    CGSize s = [TrendButton calculateSize:title];
    self.frame = CGRectMake(self.originalFrame.origin.x + (self.originalFrame.size.width/2) - (s.width/2),self.originalFrame.origin.y,s.width,s.height);
    [self update:title color:color];
}

+ (CGSize)calculateSize:(NSString*)title {
    NSDictionary *fontDict = @{NSFontAttributeName:[UIFont phBold:9]};
    CGSize stringSize = [title sizeWithAttributes:fontDict];
    UIEdgeInsets ei = UIEdgeInsetsMake(5, 8, 3, 8);
    int cornerRadiusValue = 5;
    int w = stringSize.width + ei.left + ei.right + cornerRadiusValue;
    int h = stringSize.height + ei.top + ei.bottom;
    return CGSizeMake(w,h);
}

@end
