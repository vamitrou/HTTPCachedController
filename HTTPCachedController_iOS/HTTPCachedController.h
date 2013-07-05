//
//  HTTPCachedController.h
//  
//
//  Created by Vasileios Mitrousis on 7/3/13.
//  Copyright (c) 2013 Vasileios Mitrousis. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HTTPCachedControllerDelegate

- (void)connectionFinishedWithData:(NSString*)data andRequestType:(int)reqType;
- (void)noDataAvailable;

@end

@interface HTTPCachedController : NSObject
{
    NSMutableURLRequest *request;
    NSMutableData *responseData;
    NSURL *baseURL;
    
    int requestType;
    
    id<HTTPCachedControllerDelegate> http_delegate;
}

@property (nonatomic, retain) NSString *dataString;
@property (nonatomic, retain) NSString *key;
@property (readwrite, assign) id<HTTPCachedControllerDelegate> http_delegate;

- (id)initWithRequestType:(int)reqType andDelegate:(id<HTTPCachedControllerDelegate>)del;
- (void)postRequestToURL:(NSString*)url withData:(NSString*)data;
- (void)getRequestToURL:(NSString*)url;

@end
