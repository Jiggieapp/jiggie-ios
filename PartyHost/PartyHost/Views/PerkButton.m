//
//  TrendButton.m
//  PartyHost
//
//  Created by Tony Suriyathep on 7/8/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "PerkButton.h"

@implementation PerkButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.originalFrame = frame;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont phBold:8];
        self.titleLabel.adjustsFontSizeToFitWidth = NO;
        self.backgroundColor = [UIColor phDarkGrayColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 2;
        [self setTitleEdgeInsets:UIEdgeInsetsMake(3, 1, 2, 1)];
        [self setTitle:@"VIP TABLE" forState:UIControlStateNormal];
    }
    return self;
}

- (void)update:(NSString*)title color:(UIColor*)color {
    self.backgroundColor = color;
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)updateCenterFit:(NSString*)title color:(UIColor*)color {
    CGSize s = [PerkButton calculateSize:title maxWidth:self.originalFrame.size.width];
    self.frame = CGRectMake(self.originalFrame.origin.x + (self.originalFrame.size.width/2) - (s.width/2),self.originalFrame.origin.y,s.width,s.height);
    [self update:title color:color];
}

- (void)updateLeftFit:(NSString*)title color:(UIColor*)color {
    CGSize s = [PerkButton calculateSize:title maxWidth:self.originalFrame.size.width];
    self.frame = CGRectMake(self.originalFrame.origin.x,self.originalFrame.origin.y,s.width,s.height);
    [self update:title color:color];
}

- (void)updateRightFit:(NSString*)title color:(UIColor*)color {
    CGSize s = [PerkButton calculateSize:title maxWidth:self.originalFrame.size.width];
    self.frame = CGRectMake(self.originalFrame.origin.x + self.originalFrame.size.width - s.width,self.originalFrame.origin.y,s.width,s.height);
    [self update:title color:color];
}

+ (CGSize)calculateSize:(NSString*)title maxWidth:(int)maxWidth {
    NSDictionary *fontDict = @{NSFontAttributeName:[UIFont phBold:10]};
    //NSDictionary *fontDict = @{NSFontAttributeName:[UIFont fontWithName:@"Verdana" size:10]};
    CGSize stringSize = [title sizeWithAttributes:fontDict];
    UIEdgeInsets ei = UIEdgeInsetsMake(3, 1, 2, 1);
    int cornerRadiusValue = 0;
    int stringW = stringSize.width;
    if(stringW > maxWidth) {stringW = maxWidth;}
    int w = stringW + ei.left + ei.right + cornerRadiusValue;
    int h = stringSize.height + ei.top + ei.bottom;
    return CGSizeMake(w+2,h);
}

@end
