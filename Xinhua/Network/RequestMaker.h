//
//  RequestMaker.h
//  NetworkDemo
//
//  Created by Haoran Yu on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface RequestMaker : NSObject


/*-------------------------------------------------------------
 instruction
 author:zyq
 date  :2013-1-22
 此处对应借口个数，根据自己的app自行设计。
 1.获取对应客户端的栏目信息，例如新华国际的ClientID为201.LanguageType 标识中英文版本

 --------------------------------------------------------------*/
+ (void)getChannels:(NSString *)ClientID LanguageType:(NSInteger)languageType delegate:(id)delegate action:(SEL)action;


@end

