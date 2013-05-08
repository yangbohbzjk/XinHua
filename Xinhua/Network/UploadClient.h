//
//  UploadClient.h
//  XinHuaInternational
//
//  Created by zyq on 13-3-27.
//  Copyright (c) 2013年  miti. All rights reserved.
//

#import "ASIFormDataRequest.h"

@interface UploadClient : ASIFormDataRequest
{
    SEL selfaction;
}
@property (nonatomic,assign)id callback;
@property (nonatomic,retain)NSMutableDictionary *responseInfo;
@property (nonatomic,assign)SEL selfaction;

- (id)initWithDelegate:(id)adelegate info:(id)requestInfo action:(SEL)action;//action为回调方法
@end
