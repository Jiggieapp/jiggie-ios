//
//  UserBubble.m
//  PartyHost
//
//  Created by Tony Suriyathep on 7/14/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "UserBubble.h"

@implementation UserBubble

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[UIColor colorWithWhite:1 alpha:0.50] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = frame.size.height/2;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        //For no user mode
        [self setTitleEdgeInsets:UIEdgeInsetsMake(2,0,0,2)];
        [self setTitle:@"" forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont phBold:frame.size.height/2.5];
        self.titleEdgeInsets = UIEdgeInsetsMake(2,0,0,0);
        self.layer.borderWidth = 0;
        self.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.50].CGColor;
        
        [self reset];
    }
    
    self.fb_id = @"";
    self.initials = @"";
    
    return self;
}

- (void)setName:(NSString*)firstName lastName:(NSString*)lastName
{
    NSString *firstInitial = @"";
    NSString *lastInitial = @"";
    
    if(firstName!=nil&& [firstName length]>0)
    {
        firstInitial = [[firstName substringToIndex:1] uppercaseString];
    }
 
    if(lastName!=nil&& [lastName length]>0)
    {
        lastInitial = [[lastName substringToIndex:1] uppercaseString];
    }
    
    self.initials = [NSString stringWithFormat:@"%@%@",firstInitial,lastInitial];
}

- (void)reset {
    [self cancel];
}

- (NWURLConnection*)loadImage:(NSString*)url {
    SharedData *sharedData = [SharedData sharedInstance];
    self.url = url;
    
    //Already exists
    UIImage *img = sharedData.imagesDict[url];
    if(img) {
        [self cancel];
        [self setImage:img forState:UIControlStateNormal];
        [self setTitle:@"" forState:UIControlStateNormal];
        self.layer.borderWidth = 0;
        return [[NWURLConnection alloc] init];
    }
    
    //Show default image and wait
    [self reset];
    [self setImage:nil forState:UIControlStateNormal];
    [self setTitle:self.initials forState:UIControlStateNormal];
    self.layer.borderWidth = 0;
    self.connection = [sharedData loadImageCancelable:self.url completionBlock:^(UIImage *image)
   {
       [self setImage:image forState:UIControlStateNormal];
       [self setTitle:@"" forState:UIControlStateNormal];
       self.layer.borderWidth = 0;
   }];
    return self.connection;
}

- (NWURLConnection*)loadFacebookImage:(NSString*)fb_id {
    SharedData *sharedData = [SharedData sharedInstance];
    self.fb_id = fb_id;
    return [self loadImage:[sharedData profileImg:self.fb_id]];
}

- (void)loadProfileImage:(NSString *)fb_id {
    self.fb_id = fb_id;
    NSString *url = [NSString stringWithFormat:@"%@/memberinfo/%@", PHBaseNewURL, self.fb_id];
    SharedData *sharedData = [SharedData sharedInstance];
    AFHTTPRequestOperationManager *manager = [sharedData getOperationManager];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger responseStatusCode = operation.response.statusCode;
        if (responseStatusCode != 200) {
            return;
        }
        
        NSString *responseString = operation.responseString;
        NSError *error;
        NSDictionary *json = (NSDictionary *)[NSJSONSerialization
                                              JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]
                                              options:kNilOptions
                                              error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (json && json != nil) {
                NSDictionary *data = [json objectForKey:@"data"];
                if (data && data != nil) {
                    NSDictionary *memberinfo = [data objectForKey:@"memberinfo"];
                    if (memberinfo && memberinfo != nil) {
                        NSArray *photos = memberinfo[@"photos"];
                        if (photos && photos != nil) {
                            [self loadImage:photos[0]];
                        }
                    }
                }
            }
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void)cancel {
    if(self.connection!=nil) {
        [self.connection cancel];
        self.connection = nil;
    }
}

@end
