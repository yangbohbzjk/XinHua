//
//  ImageDownloadClient.h
//  XinHuaInternational
//
//  Created by  miti on 13-1-24.
//  Copyright (c) 2013年  miti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
@interface ImageDownloadClient  : ASIHTTPRequest
{
    SEL			selfaction;
    NSInteger   selfindex;//下载图片对应的索引
    
}
@property (nonatomic,assign) id callback;
@property (nonatomic,retain) NSMutableDictionary *responseInfo;
@property(nonatomic,assign) SEL selfaction;
@property(nonatomic,assign)  NSInteger   selfindex;
@property(nonatomic,assign)  BOOL  isCanceled;


- (id)initWithDelegate:(id)adelegate info:(id)requestInfo action:(SEL)action;//action为回调方法
- (id)initWithDelegate:(id)adelegate info:(id)requestInfo;
- (id)initWithDelegate:(id)adelegate info:(id)requestInfo action:(SEL)action selectindex:(NSInteger)selectindex;


@end
