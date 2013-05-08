//
//  XinhuaClient.h
//  Demo
//
//  Created by zyq on 13-1-22.
//  Copyright (c) 2013年 zyq. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface CommonClient : ASIHTTPRequest
{
    SEL			selfaction;

}
@property (nonatomic,assign) id callback;
@property (nonatomic,retain) NSMutableDictionary *responseInfo;
@property(nonatomic,assign) SEL selfaction;
@property (nonatomic,assign) BOOL isCanceled;


- (id)initWithDelegate:(id)adelegate info:(id)requestInfo action:(SEL)action;//action为回调方法
- (id)initWithDelegate:(id)adelegate info:(id)requestInfo;


@end
