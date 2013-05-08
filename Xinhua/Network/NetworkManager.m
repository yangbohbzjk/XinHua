//
//  NetworkManager.m
//  NetworkDemo
//
//  Created by zyq on 13-1-22.
//  Copyright (c) 2013年 zyq. All rights reserved.
//

#import "NetworkManager.h"
#import "CommonClient.h"
#import "NetWorkConfig.h"
#import "UploadClient.h"
#import "ImageDownloadClient.h"
#define kCommonQueueMaxCount         3
#define kUploadQueueMaxCount         3
#define kPicQueueMaxCount            10

static NetworkManager *sharedManager = nil;

@implementation NetworkManager
@synthesize commonQueue,pictureQueue;
@synthesize picUrlArray;

- (id)init
{
    self = [super init];
    if (self) {
        
        //数据请求队列
        self.commonQueue = [[[ASINetworkQueue alloc] init] autorelease];
        commonQueue.maxConcurrentOperationCount = kCommonQueueMaxCount;
        commonQueue.shouldCancelAllRequestsOnFailure = NO;
        [commonQueue go];
        
        //图片请求队列
        self.pictureQueue = [[[ASINetworkQueue alloc] init] autorelease];
        pictureQueue.maxConcurrentOperationCount = kPicQueueMaxCount;
        pictureQueue.shouldCancelAllRequestsOnFailure = NO;
        [pictureQueue go];
        
        self.picUrlArray = [[[NSMutableArray alloc] init] autorelease];
        
    }
    return self;
}

+ (NetworkManager *)sharedManager
{
    if (sharedManager == nil) {
        sharedManager = [[NetworkManager alloc] init];
    }
    
    return sharedManager;
}

+ (void)releaseManager
{
    if (sharedManager) {
        [sharedManager release],sharedManager=nil;
    }
}

- (void)dealloc
{
    [commonQueue cancelAllOperations];
    self.commonQueue = nil;
    
    [pictureQueue cancelAllOperations];
    self.pictureQueue = nil;
    
    self.picUrlArray = nil;
    
    [super dealloc];
}

#pragma mark - 请求数据

- (void)requestDataWithDelegate:(id)delegate info:(id)requestInfo
{
    CommonClient *client = [[CommonClient alloc] initWithDelegate:delegate info:requestInfo];
    [commonQueue addOperation:client];
    [client release],client = nil;
}
- (void)requestDataWithDelegate:(id)delegate info:(id)requestInfo selfaction:(SEL)action
{
    CommonClient *client = [[CommonClient alloc] initWithDelegate:delegate info:requestInfo action:action];
    [commonQueue addOperation:client];
    [client release],client = nil;

}
- (void)requestDataWithDelegate:(id)delegate info:(id)requestInfo selfaction:(SEL)action selectindex:(NSInteger)selectindex
{
    ImageDownloadClient *client=[[ImageDownloadClient alloc] initWithDelegate:delegate info:requestInfo action:action selectindex:selectindex];
    [commonQueue addOperation:client];
    [client release],client = nil;
}
- (void)uploadWithDelegate:(id)delegate info:(id)requestInfo selfaction:(SEL)action
{
    UploadClient *uploadclient = [[UploadClient alloc] initWithDelegate:delegate info:requestInfo action:action];
    [uploadclient startAsynchronous];
    [uploadclient release],uploadclient = nil;
}

//取消某个对象的所有数据请求
- (void) cancelRequestForDelegate:(id)delegate 
{
    NSArray *clients = [commonQueue operations];
    
    for (int i=0 ;i<[clients count] ;i++)
    {
        CommonClient *commenClient=[clients objectAtIndex:i];
        
        if (commenClient.isCanceled==NO) {
            NSLog(@"%d",commenClient.isCanceled);
            if ([commenClient.callback isEqual:delegate])
            {
                commenClient.isCanceled=YES;
                [commenClient clearDelegatesAndCancel];
                
                // [commonQueue removeObjectAtIndex:i];
            }

        }
    }
    for (int j=0; j<[clients count]; j++) {
        ImageDownloadClient *imageClient=[clients objectAtIndex:j];
        if (imageClient.isCanceled==NO) {
            if ([imageClient.callback isEqual:delegate])
            {    imageClient.isCanceled=YES;
                [imageClient clearDelegatesAndCancel];
                //[commonQueue removeObjectAtIndex:j];
            }
        }
    
    }
    }


@end
