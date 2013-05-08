//
//  XinhuaClient.m
//  Demo
//
//  Created by zyq on 13-1-22.
//  Copyright (c) 2013年 zyq. All rights reserved.
//

#import "CommonClient.h"
#import "NetWorkConfig.h"
#import "GTMBase64.h"


@implementation CommonClient
@synthesize callback,responseInfo,selfaction,isCanceled;


- (NSString *)encodeBase64:(NSString *)input
{
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    base64String = [base64String stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    return base64String;
}

- (id)initWithDelegate:(id)aDelegate info:(id)requestInfo
{
    NSString *strURL  = [requestInfo objectForKey:RequestUrl];
    NSURL *requestUrl = [NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"%@",strURL);
    
    self = [super initWithURL:requestUrl];
    isCanceled=NO;
    if (self)
    {
        if ([requestInfo objectForKey:RequestMethod] == POST) {
            
            NSString *bodyStr = [requestInfo objectForKey:POST_BODY];
            [self addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
            [self appendPostData:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
            [self setRequestMethod:POST];
        }else
        {
            NSString *Base64UsernameAndPassword = [self encodeBase64:[NSString stringWithFormat:@"%@:%@",Username,Password]];
            [self addRequestHeader:@"Authorization" value:[NSString stringWithFormat:@"Basic %@",Base64UsernameAndPassword]];
            [self setRequestMethod:GET];
        }
        
        self.delegate = self;
        self.callback = aDelegate;
		self.responseInfo = requestInfo;
        [self setTimeOutSeconds:kTimeoutInterval2];
        //self.timeOutSeconds = kTimeoutInterval2;
        self.shouldAttemptPersistentConnection = NO;
    }
    
    return self;
}
- (id)initWithDelegate:(id)adelegate info:(id)requestInfo action:(SEL)action
{
    NSString *strURL  = [requestInfo objectForKey:RequestUrl];
    NSURL *requestUrl = [NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"%@",strURL);
    selfaction=action;
    isCanceled=NO;
    self = [super initWithURL:requestUrl];
    
    if (self)
    {
        if ([requestInfo objectForKey:RequestMethod] == POST) {
            
            NSString *bodyStr = [requestInfo objectForKey:POST_BODY];
            [self addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
            [self appendPostData:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
            [self setRequestMethod:POST];
        }else
        {
            NSString *Base64UsernameAndPassword = [self encodeBase64:[NSString stringWithFormat:@"%@:%@",Username,Password]];
            [self addRequestHeader:@"Authorization" value:[NSString stringWithFormat:@"Basic %@",Base64UsernameAndPassword]];
            [self setRequestMethod:GET];
        }
        
        self.delegate = self;
        self.callback = adelegate;
		self.responseInfo = requestInfo;
       // self.timeOutSeconds = kTimeoutInterval2;
         [self setTimeOutSeconds:kTimeoutInterval2];
        self.shouldAttemptPersistentConnection = NO;
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
    [callback performSelector:selfaction withObject:responseInfo];
    
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


//- (id)initWithTarget:(id)aDelegate action:(SEL)anAction
//{
//    self = [super initWithDelegate:aDelegate];
//    delegate = aDelegate;
//    opeType = DEFAULT;
//    action = anAction;
//    hasError = FALSE;
//    return self;
//}

@end
