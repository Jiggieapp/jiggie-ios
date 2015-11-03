//
//  NWURLConnection.h
//  PartyHost
//
//  Created by Tony Suriyathep on 6/24/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#ifndef PartyHost_NWURLConnection_h
#define PartyHost_NWURLConnection_h

@interface NWURLConnection : NSObject<NSURLConnectionDelegate>

@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, copy) void(^completionHandler)(NSURLResponse *response, NSData *data, NSError *error);

+ (NWURLConnection *)sendAsynchronousRequest:(NSURLRequest *)request queue:(NSOperationQueue *)queue completionHandler:(void(^)(NSURLResponse *response, NSData *data, NSError *error))completionHandler;
- (void)start;
- (void)cancel;

@end

#endif
