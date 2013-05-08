//
//  ChannelDB.h
//  XinHuaInternational
//
//  Created by zh ch on 13-1-22.
//  Copyright (c) 2013年  miti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataBase.h"
#import "Channel.h"

@interface ChannelDB : DataBase

//添加一条新栏目记录，返回该栏目的id。不成功返回-1
-(NSInteger)add:(Channel*)channel;
//添加多条记录
-(NSInteger)addList:(NSMutableArray*)channelItems;
//根据栏目id和语言类别，判断该栏目是否已经存在
-(BOOL)hasExist:(NSInteger)channelId languageType:(NSString *)languageType;

//基于栏目id删除该栏目。删除成功返回YES，否则为NO。
-(BOOL)deleteById:(NSInteger)channelId;

//根据传入的栏目id，更新该栏目信息。如果更新不成功，则返回NO;否则为YES
-(BOOL)update:(Channel*)channel;

//根据栏目id，返回该栏目下一级的子栏目列表（其中包含栏目的详细信息）
//如果传入的id为0，则返回第一级栏目列表
-(NSMutableArray*)getList:(NSInteger)channelId languageType:(NSString *)languageType;

//根据Type和语言类型，返回对应的channel列表
-(NSMutableArray*)getListByType:(NSInteger)type languageType:(NSString *)languageType level:(NSInteger)level;
-(Channel *)getChannel:(NSInteger)channelId;
-(BOOL)deleteAll;
//获得所有栏目
-(NSMutableArray *)getAllChannelByLanguage:(NSString *)languageType;

@end
