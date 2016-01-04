//
//  PHImage.h
//  PartyHost
//
//  Created by Sunny Clark on 3/8/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NWURLConnection.h"
#import "UIImageViewAligned.h"

@interface PHImage : UIImageViewAligned

@property(nonatomic,strong) SharedData *sharedData;

@property(nonatomic,strong) NSString *picURL;
@property(nonatomic,strong) UIActivityIndicatorView *spinner;
@property(nonatomic,strong) NWURLConnection *connection; //We need to cancel the request!
@property(nonatomic,assign) BOOL showLoading;

-(void)loadImage:(NSString *)imgURL defaultImageNamed:(NSString*)defaultImageNamed;
-(void)cancelImage;
- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image, NSString *key))completionBlock;
@end
