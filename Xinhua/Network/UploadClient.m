//
//  UploadClient.m
//  XinHuaInternational
//
//  Created by zyq on 13-3-27.
//  Copyright (c) 2013年  miti. All rights reserved.
//

#import "UploadClient.h"
#import "NetWorkConfig.h"

@implementation UploadClient
@synthesize callback,responseInfo,selfaction;

- (id)initWithDelegate:(id)adelegate info:(id)requestInfo action:(SEL)action
{
    NSString *strURL = [requestInfo objectForKey:RequestUrl];
    NSURL *requestUrl= [NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    selfaction = action;
    self = [super initWithURL:requestUrl];
    [self setShouldAttemptPersistentConnection:NO];
    if (self) {
        self.delegate = self;
        self.callback = adelegate;
        self.responseInfo = requestInfo;
        
        //此处根据接口进行调整。
        if ([requestInfo objectForKey:NewsFiledata])
        {
            [self setData:[requestInfo objectForKey:NewsFiledata] forKey:NewsFiledata];
        }
        if ([requestInfo objectForKey:NewsTitle]) {
            [self setPostValue:[requestInfo objectForKey:NewsTitle] forKey:NewsTitle];
        }
        if ([requestInfo objectForKey:NewsDes]) {
            [self setPostValue:[requestInfo objectForKey:NewsDes] forKey:NewsDes];
        }
        if ([requestInfo objectForKey:ClientMark]) {
            [self setPostValue:[requestInfo objectForKey:ClientMark] forKey:ClientMark];
        }
        if ([requestInfo objectForKey:ClientId]) {
            [self setPostValue:[requestInfo objectForKey:ClientId] forKey:ClientId];
        }
        if ([requestInfo objectForKey:ClientDes]) {
            [self setPostValue:[requestInfo objectForKey:ClientDes] forKey:ClientDes];
        }
        [self setPostFormat:ASIMultipartFormDataPostFormat];


    }
    return self;
}

- (void)dealloc
{
    [responseInfo release];
    [super dealloc];
}

- (void)requestFinished:(ASIHTTPRequest*)request
{
    NSData *respData = [self responseData];
    
    if (respData)
    {
        [responseInfo setObject:RequestSuccess forKey:RequestStatus];
        [responseInfo setObject:respData forKey:ResponseData];
    }
    else
    {
        [responseInfo setObject:RequestFail forKey:RequestStatus];
        [responseInfo setObject:respData forKey:ResponseData];
        
        NSLog(@"response data is null");
    }
    
    //[callback performSelector:@selector(requestDidFinish:) withObject:responseInfo];
    [callback performSelectorOnMainThread:selfaction withObject:responseInfo waitUntilDone:YES];//:selfaction withObject:responseInfo];
    
}

- (void)requestFailed:(ASIHTTPRequest*)request
{
    @try{
        [responseInfo setObject:RequestFail forKey:RequestStatus];//服务器响应的状态
        //[responseInfo setObject:self.error forKey:ResponseError];
        [responseInfo setObject:NSLocalizedString(@"server_noresponse",nil) forKey:ResponseError];
        
        NSLog(@"request failed");
        //  [callback performSelector:@selector(requestDidFinish:) withObject:responseInfo];
        [callback performSelector:selfaction withObject:responseInfo];
        
    }
    @catch(...)
    {
        //NSLog(...)
    }
    
}
@end
