//
//  EmptyView.m
//  PartyHost
//
//  Created by Tony Suriyathep on 7/23/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "EmptyView.h"

@implementation EmptyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, (frame.size.height/2)-((64+8+32+16+16)/2) - 16, frame.size.width, 64+8+32+16+50)];
    self.container.backgroundColor = [UIColor clearColor];
    self.container.hidden = YES;
    [self addSubview:self.container];
    
    self.image = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-64)/2, 0, 64, 64)];
    self.image.userInteractionEnabled = NO;
    self.image.contentMode = UIViewContentModeScaleAspectFill;
    [self.container addSubview:self.image];
    
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(16, 64+12, frame.size.width-32, 32)];
    self.title.text = @"Check back soon";
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.adjustsFontSizeToFitWidth = YES;
    self.title.textColor = [UIColor blackColor];
    self.title.font = [UIFont phBlond:22];
    
    
    //self.title.layer.borderColor = [UIColor whiteColor].CGColor;
    //self.title.layer.borderWidth = 1.0;
    
    self.title.layer.shadowColor = [[UIColor whiteColor] CGColor];
    self.title.layer.shadowRadius = 1;
    self.title.layer.shadowOpacity = 1;
    //self.title.layer.shadowOffset = CGSizeMake(3, 3);
    
    //self.title.shadowColor = [UIColor whiteColor];
    //self.title.shadowOffset = CGSizeMake(1,1);
    
    [self.container addSubview:self.title];
    
    self.subtitle = [[UILabel alloc] initWithFrame:CGRectMake(16, self.title.frame.origin.y + self.title.frame.size.height + 12, frame.size.width - 32, 50)];
    self.subtitle.text = @"You’ve looked through everyone interested";
    self.subtitle.textAlignment = NSTextAlignmentCenter;
    self.subtitle.adjustsFontSizeToFitWidth = YES;
    self.subtitle.textColor = [UIColor phDarkGrayColor];
    self.subtitle.font = [UIFont phBlond:14];
    self.subtitle.numberOfLines = 2;
    [self.container addSubview:self.subtitle];
    
    //Create spinner only 1st time
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.spinner.hidden = YES;
    [self.spinner setColor:[UIColor grayColor]];
    [self addSubview:self.spinner];
    
    return self;
}

-(void)setData:(NSString*)title subtitle:(NSString*)subtitle imageNamed:(NSString*)imageNamed
{
    self.title.text = title;
    
    //Need line spacing cause this font is bad!!!
    self.subtitle.frame = CGRectMake(16, self.title.frame.origin.y + self.title.frame.size.height + 12, self.frame.size.width - 32, 50);
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:subtitle];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSTextAlignmentCenter];
    [style setLineSpacing:4];
    [attrString addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, [subtitle length])];
    self.subtitle.attributedText = attrString;
    [self.subtitle sizeToFit];
    self.subtitle.frame = CGRectMake(16, self.title.frame.origin.y + self.title.frame.size.height + 12, self.frame.size.width - 32, self.subtitle.frame.size.height);
    
    self.image.image = [[UIImage imageNamed:imageNamed] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.image.tintColor = [UIColor phLightGrayColor];
}

-(void)setMode:(NSString*)mode
{
    if([mode isEqualToString:@"load"])
    {
        self.hidden = NO;
        self.spinner.hidden = NO;
        [self.spinner startAnimating];
        self.container.hidden = YES;
    }
    else if([mode isEqualToString:@"empty"])
    {
        self.hidden = NO;
        self.spinner.hidden = YES;
        [self.spinner stopAnimating];
        self.container.hidden = NO;
    }
    else if([mode isEqualToString:@"hide"])
    {
        self.hidden = YES;
        self.spinner.hidden = YES;
        [self.spinner stopAnimating];
        self.container.hidden = NO;
    }
}

@end
