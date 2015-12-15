//
//  EmptyView.h
//  PartyHost
//
//  Created by Tony Suriyathep on 7/23/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmptyView : UIView

@property(nonatomic,strong) UIView *container;
@property(nonatomic,strong) UILabel *title;
@property(nonatomic,strong) UILabel *subtitle;
@property(nonatomic,strong) UIImageView *image;
@property(nonatomic,strong) UIActivityIndicatorView *spinner;

-(void)setMode:(NSString*)mode; //load, empty, hide
-(void)setData:(NSString*)title subtitle:(NSString*)subtitle imageNamed:(NSString*)imageNamed;

@end
