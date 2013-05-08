//
//  NetworkManager.h
//  NetworkDemo
//
//  Created by zyq on 13-1-22.
//  Copyright (c) 2013年 zyq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"

@interface NetworkManager : NSObject

@property (nonatomic, retain) ASINetworkQueue *commonQueue;
@property (nonatomic, retain) ASINetworkQueue *pictureQueue;
@property (nonatomic, retain) NSMutableArray *picUrlArray;   //防止图片重复下载

+ (NetworkManager *) sharedManager;
+ (void) releaseManager;

//请求数据
- (void)requestDataWithDelegate:(id)delegate info:(id)requestInfo;
- (void)requestDataWithDelegate:(id)delegate info:(id)requestInfo selfaction:(SEL)action;
- (void)requestDataWithDelegate:(id)delegate info:(id)requestInfo selfaction:(SEL)action selectindex:(NSInteger)selectindex;
- (void)uploadWithDelegate:(id)delegate info:(id)requestInfo selfaction:(SEL)action;
//取消某个对象的所有数据请求
- (void) cancelRequestForDelegate:(id)delegate;

@end
