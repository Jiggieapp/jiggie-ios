//
//  Privacy.m
//  PartyHost
//
//  Created by Sunny Clark on 2/16/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "Privacy.h"

@implementation Privacy

#define contains(str1, str2) ([str1 rangeOfString: str2 ].location != NSNotFound)

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    self.sharedData = [SharedData sharedInstance];
    
    UIView *tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 60)];
    tabBar.backgroundColor = [UIColor phPurpleColor];
    [self addSubview:tabBar];
    
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, frame.size.width, 40)];
    self.title.text = @"PRIVACY";
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.font = [UIFont phBold:18];
    self.title.textColor = [UIColor whiteColor];
    [tabBar addSubview:self.title];
    
    //Webview alloc once
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 60, self.sharedData.screenWidth, self.frame.size.height - 60)];
    self.webView.backgroundColor = [UIColor whiteColor];
    [[self.webView scrollView] setContentInset:UIEdgeInsetsMake(16, 16, 16, 16)];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    self.webView.dataDetectorTypes = UIDataDetectorTypeNone;
    [self addSubview:self.webView];
    
    //Add spinner to middle
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.frame = CGRectMake(0, 0, self.sharedData.screenWidth, self.sharedData.screenHeight);
    self.spinner.hidden = YES;
    [self addSubview:self.spinner];
    
    return self;
}

-(void)initClass
{
    self.title.text = self.mainTitle;
    
    //Show spinner
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
    
    self.webView.hidden = YES;
    NSDate *date = [NSDate date];
    NSTimeInterval ti = [date timeIntervalSince1970];
    NSString *url = [NSString stringWithFormat:@"%@?cb=%f",self.webURL,ti];
    NSLog(@"WebView URL :: %@",url);
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:url]]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if(contains(request.URL.absoluteString,self.webURL))
    {
        return YES;
    }
    return NO;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.spinner.hidden = YES;
    [self.spinner stopAnimating];
    
    self.webView.hidden = NO;
}

@end
