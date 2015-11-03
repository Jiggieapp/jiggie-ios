//
//  Privacy.h
//  PartyHost
//
//  Created by Sunny Clark on 2/16/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Privacy : UIView<UIWebViewDelegate>

@property (strong, nonatomic) SharedData    *sharedData;

@property(nonatomic,strong) NSString *webURL;
@property(nonatomic,strong) NSString *mainTitle;
@property(nonatomic,strong) UILabel *title;
@property(nonatomic,strong) UIWebView *webView;

@property(strong,nonatomic) UIActivityIndicatorView *spinner;

-(void)initClass;

@end
