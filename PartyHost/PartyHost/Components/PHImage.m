//
//  PHImage.m
//  PartyHost
//
//  Created by Sunny Clark on 3/8/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "PHImage.h"

@implementation PHImage


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.sharedData = [SharedData sharedInstance];
    self.picURL = @"";
    self.showLoading = NO;
    self.connection = nil;
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinner.frame = CGRectMake(0, 0, 100, 100);
    self.spinner.center = self.center;
    return self;
}

-(void)loadImage:(NSString *)imgURL defaultImageNamed:(NSString*)defaultImageNamed
{
    
    if (imgURL == nil) {
        if(defaultImageNamed!=nil) //Use default image
        {
            self.image = [UIImage imageNamed:defaultImageNamed];
        }
        self.picURL = @"";
        return;
    }
    
    self.picURL = imgURL;
    
    //Already exists
    if([self.sharedData.imagesDict objectForKey:imgURL] && [[self.sharedData.imagesDict objectForKey:imgURL] isKindOfClass:[UIImage class]])
    {
        self.image = [self.sharedData.imagesDict objectForKey:imgURL];
        [self.spinner stopAnimating];
        [self.spinner removeFromSuperview];
        
        return;
    }
    else if(defaultImageNamed!=nil) //Use default image
    {
        self.image = [UIImage imageNamed:defaultImageNamed];
    }
    else if(defaultImageNamed==nil) //Make it blank
    {
        self.image = nil;
    }
    
    //Show spinner
    if(self.showLoading)
    {
        [self addSubview:self.spinner];
        [self.spinner startAnimating];
    }
    
    //Download image and add to shared dict
    [self downloadImageWithURL:[[NSURL alloc] initWithString:imgURL] completionBlock:^(BOOL succeed, UIImage *result, NSString *pic_url)
    {
        if(succeed)
        {
            [self.sharedData.imagesDict setObject:result forKey:pic_url];
            if([pic_url isEqualToString:self.picURL])
            {
                self.image = result;
                if(self.showLoading)
                {
                    [self.spinner stopAnimating];
                    [self.spinner removeFromSuperview];
                }
            }
        }
    }];
}

-(void)cancelImage
{
    //Cancel if previous
    if(self.connection!=NULL)
    {
        [self.connection cancel];
        self.connection = NULL;
    }
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image, NSString *key))completionBlock
{
    //Cancel if previous
    //[self cancelImage];
    
    if (url == nil || !url) {
        return;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //Load async but allow cancel
    self.connection = [NWURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               self.connection = nil;
                               if ( !error )
                               {
                                   
                                   if([self.sharedData contentTypeForImageData:data])
                                   {
                                       UIImage *image = [[UIImage alloc] initWithData:data];
                                       completionBlock(YES,image,url.absoluteString);
                                   }else{
                                      completionBlock(NO,nil,url.absoluteString);
                                   }
                               } else{
                                   completionBlock(NO,nil,url.absoluteString);
                               }
                           }];
}

@end
