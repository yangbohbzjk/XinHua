//
//  NewsItemDB.h
//  XinHuaInternational
//
//  Created by zh ch on 13-1-22.
//  Copyright (c) 2013年  miti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataBase.h"
#import "NewsItem.h"

@interface NewsItemDB : DataBase

//添加一条新记录，返回该新闻条目的id。
//在添加之前，先基于docid和channelid判断是否应经存在，如果有，则不添加并返回0。
//如果出现异常，则返回-1
-(NSInteger)add:(NewsItem*)newsItem;

//批量插入多条新闻条目。成功返回1；部分成功（有部分已经存在）返回0；异常返回-1.
-(NSInteger)addList:(NSMutableArray*)newsItems;

//基于docid和channelid判断是否应经存在
//0--不存在；1--存在；-1--程序错误
-(NSInteger)hasExist:(NSInteger)docId channelId:(NSInteger)cId;

//根据栏目id，返回该栏目下一级新闻条目列表
-(NSMutableArray*)getListByPage:(NSInteger)channelId pageNum:(NSInteger)number pageSize:(NSInteger)size;

//根据栏目id和新闻条目id，获取该新闻条目日期之前列表。
-(NSMutableArray*)getListBeforeCurrentNews:(NSInteger)channelId docId:(NSInteger)dId itemCount:(NSInteger)count;

//根据docId和channelId获取单条新闻条目信息
-(NewsItem*)getItemByChannelId:(NSInteger)cId docId:(NSInteger)dId;

//清除缓存，即删除所有新闻条目。
-(BOOL)deleteAll;

@end
