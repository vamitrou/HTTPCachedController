//
//  HTTPCachedController.m
//  
//
//  Created by Vasileios Mitrousis on 7/3/13.
//  Copyright (c) 2013 Vasileios Mitrousis. All rights reserved.
//

#import "HTTPCachedController.h"

#define _DEBUG 1

@implementation HTTPCachedController

@synthesize http_delegate;

- (id)initWithRequestType:(int)reqType andDelegate:(id<HTTPCachedControllerDelegate>)del
{
    if (self == [super init])
    {
        requestType = reqType;
        [self setHttp_delegate:del];
    }
    return self;
}

- (NSString*)URLencode:(NSString*)url
{
    // do not forget to release afterwards
    return (NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef) url, CFSTR(""), NULL, kCFStringEncodingUTF8);
}

- (void)postRequestToURL:(NSString*)url withData:(NSString*)data
{
    responseData = [[NSMutableData data] retain];
    NSString *URLString = [self URLencode:url];
    
    baseURL = [NSURL URLWithString:URLString];
    [URLString release];
    
    request = [NSMutableURLRequest requestWithURL:baseURL];
    [request setHTTPMethod:@"POST"];
    
    [self setKey:[NSString stringWithFormat:@"%@_%@", url, data]];
    
    [self setDataString:data];
    NSData *requestBody = [[self dataString] dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:requestBody];
    
    if (_DEBUG) NSLog(@"POST: curl -X POST %@ -d '%@'", URLString, [self dataString]);
    
    [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
}

- (void)getRequestToURL:(NSString*)url
{
    responseData = [[NSMutableData data] retain];
    NSString *URLString = [(NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef) url, CFSTR(""), NULL, kCFStringEncodingUTF8) autorelease];
    baseURL = [NSURL URLWithString:URLString];
    
    request = [NSMutableURLRequest requestWithURL:baseURL];
    [request setHTTPMethod:@"GET"];
    
    [self setKey:url];
    
    if (_DEBUG) NSLog(@"POST: curl -X GET %@", URLString);
    
    [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [responseData setLength:0];
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    
    int responseStatusCode = [httpResponse statusCode];
    if (_DEBUG) NSLog(@"status code: %d", responseStatusCode);
    if (_DEBUG) NSLog(@"-");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (http_delegate != nil)
    {
        NSString *cachedData = [[NSUserDefaults standardUserDefaults] objectForKey:[self key]];
        
        if (cachedData != nil && [cachedData length] > 0)
            [http_delegate connectionFinishedWithData:cachedData andRequestType:requestType];
        else
            [http_delegate noDataAvailable];
    }
    
    [responseData release];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{    
    NSString *str = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    if ([str length] > 0)
    {
        [[NSUserDefaults standardUserDefaults] setObject:str forKey:[self key]];
        
        if (http_delegate != nil)
            [http_delegate connectionFinishedWithData:str andRequestType:requestType];
    }
            
    [str release];
    [responseData release];
}

- (void)dealloc
{
    [self.key release];
    [self.dataString release];
    
    [super dealloc];
}

@end
