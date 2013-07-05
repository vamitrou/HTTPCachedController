HTTPCachedController
====================

A proxy for caching web API responses.

The HTTPCachedController is a proxy that stores fetched data into device's cache. 

If the same request is done at some time that no network connection is available, the cached data will be returned. 

The whole procedure is very transparent to the developer, and handles the data in the same way as either he is online or offline.



Example usage:

    HTTPCachedController *ctrl = [[[HTTPCachedController alloc] initWithRequestType:1 andDelegate:self] autorelease];
    [ctrl getRequestToURL:@"https://api.github.com/orgs/twitter/repos?page=1&per_page=10"];
    


and the completion listener implements the HTTPCachedControllerDelegate's:

    connectionFinishedWithData:(NSString*)data andRequestType:(int)reqType
