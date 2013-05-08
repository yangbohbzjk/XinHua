//
//  NewsCollectionDB.h
//  XinHuaInternational
//
//  Created by  miti on 13-1-27.
//  Copyright (c) 2013年  miti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataBase.h"
#import "NewsCollection.h"
#import "NewsItem.h"
#import "Channel.h"
@interface NewsCollectionDB : DataBase

//添加一条新记录，返回该新闻收藏的id。
//在添加之前，先基于docid和channelid判断是否应经存在，如果有，则不添加并返回0。
//如果出现异常，则返回-1
-(NSInteger)add:(NewsCollection*)newsCollection;

//基于docid和channelid判断是否已经存在
//0--不存在；1--存在；-1--程序错误
-(NSInteger)hasExist:(NSInteger)docId channelId:(NSInteger)cId userName:(NSString *)username;

//根据用户名，栏目id和新闻条目id，得到一条新闻收藏的详细信息
-(NewsCollection*)getNewsCollectionByUser:(NSString*)username channelId:(NSInteger)cId docId:(NSInteger)dId;

//清除收藏，即删除该条收藏记录。
-(BOOL)deleteCollectionByUser:(NSString*)username channelId:(NSInteger)cId docId:(NSInteger)dId;

//根据用户名获取该用户所有收藏的新闻条目。默认用户名为空
-(NSMutableArray*)getNewsItemsFromCollectionByPage:(NSString*)username pageNum:(NSInteger)number pageSize:(NSInteger)size;
-(BOOL)deleteAll;
@end
