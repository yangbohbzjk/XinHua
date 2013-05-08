//
//  NewsContent.h
//  XinHuaInternational
//
//  Created by zh ch on 13-1-22.
//  Copyright (c) 2013年  miti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataBase.h"
#import "NewsContent.h"

@interface NewsContentDB : DataBase

//添加一条新记录，返回该新闻条目的id。
//在添加之前，先基于docid和channelid判断是否应经存在，如果有，则不添加并返回0。
//如果出现异常，则返回-1
-(NSInteger)add:(NewsContent*)newsContent;

//基于docid和channelid判断是否已经存在
//0--不存在；1--存在；-1--程序错误
-(NSInteger)hasExist:(NSInteger)docId channelId:(NSInteger)cId;

//根据栏目id和新闻条目id，得到一条新闻的详细信息
-(NewsContent*)getNewsContent:(NSInteger)channelId docId:(NSInteger)dId;

//清除缓存，即删除所有新闻正文内容。
-(BOOL)deleteAll;


@end
