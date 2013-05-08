//
//  NewsItemDB.m
//  XinHuaInternational
//
//  Created by zh ch on 13-1-22.
//  Copyright (c) 2013年  miti. All rights reserved.
//

#import "NewsItemDB.h"

@implementation NewsItemDB

//批量插入多条新闻条目。成功返回1；部分成功（有部分已经存在）返回0；异常返回-1.
-(NSInteger)addList:(NSMutableArray*)newsItems{
    
    if ([self openDatabase]==FALSE) {
        return -1;
    }
    //
    NSMutableArray *itemsToInsert = [[NSMutableArray alloc] init];
    NSInteger count = 0;
    //开启事务
    [self beginTransaction];
    
    //首先循环判断是否已经存在。对于已经存在的暂时不做处理，只插入不存在的新闻条目
    NSString *sqlSelect = @" SELECT * FROM NewsItems WHERE docId=? and channelId=? ";
    sqlite3_stmt *statement = nil;
    int success = [self prepareSql:sqlSelect sqlStatement:&statement];
    if (success != SQLITE_OK) {
        NSLog(@"Error:%d failed to prepare to check",success);
        return -1;
    }
    NSInteger token = 0;

    for(int j = 0;j < [ newsItems count ];j++)
    {
        NewsItem *newsItem = [newsItems objectAtIndex:j];
        //绑定参数
        sqlite3_bind_int(statement, 1, newsItem.docId);
        sqlite3_bind_int(statement, 2, newsItem.channelId);
        while (sqlite3_step(statement)==SQLITE_ROW)
        {
            token = 1;
        }
        if( token == 0 )
            [itemsToInsert addObject:newsItem];
        else
            token = 0;
        sqlite3_reset(statement);
    }
    
    //对去重过的新闻条目列表插入到数据库
    NSString *sql = @"INSERT INTO NewsItems (docId,channelId,topic,type,createDate,discussNum,docSource,smallImageHref,abstracts) VALUES (?,?,?,?,?,?,?,?,?)";
    
    success = [self prepareSql:sql sqlStatement:&statement];
    if (success != SQLITE_OK) {
        NSLog(@"Error:%d failed to prepare insert",success);
        return -1;
    }
    for(int i = 0;i<[itemsToInsert count];i++)
    {
        NewsItem *newsItemInsert = [itemsToInsert objectAtIndex:i];
        //绑定参数
        sqlite3_bind_int(statement, 1, newsItemInsert.docId);
        sqlite3_bind_int(statement, 2, newsItemInsert.channelId);
        sqlite3_bind_text(statement, 3, [newsItemInsert.topic UTF8String], -1, NULL);
        sqlite3_bind_int(statement, 4, newsItemInsert.type);
        sqlite3_bind_text(statement, 5, [newsItemInsert.createDate UTF8String], -1, NULL);
        sqlite3_bind_int(statement, 6, newsItemInsert.discussNum);
        sqlite3_bind_text(statement, 7,[newsItemInsert.docSource UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 8,[newsItemInsert.smallImageHref UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 9,[newsItemInsert.abstract UTF8String], -1, NULL);
        
        success = sqlite3_step(statement);
        if (success == SQLITE_ERROR) {
            NSLog(@"Error: failed to insert into the database:%@",newsItemInsert.topic);
//            sqlite3_finalize(statement);
//            sqlite3_close(database);
        }
        else
            count++;
        //重新初始化该statement对象绑定的变量
        sqlite3_reset(statement);
    }
    sqlite3_finalize(statement);
    
    //执行事务
    [self commitTransaction];
    sqlite3_close(database);
    
    NSInteger nRet;
    
    if( count == [newsItems count] )
    {
        nRet = 1;
    }
    else if (count == [itemsToInsert count])
    {
        nRet = 0;
    }
    else
    {
        nRet = -1;
    }
    [itemsToInsert release];
    return nRet;
    
//    if( count == [newsItems count] )
//    {  [itemsToInsert release];
//        return 1;
//    }
//    else if (count == [itemsToInsert count])
//    {
//        [itemsToInsert release];
//        return 0;
//    }
//    else
//    {
//        [itemsToInsert release];
//        return -1;
//    }
}

//基于docid和channelid判断是否应经存在
////0--不存在；1--存在；-1--程序错误
-(NSInteger)hasExist:(NSInteger)docId channelId:(NSInteger)cId{
    if ([self openDatabase]==FALSE) {
        return -1;
    }

    NSString *sqlSelect = @" SELECT * FROM NewsItems WHERE docId=? and channelId=? ";
    sqlite3_stmt *statement = nil;
    int success = [self prepareSql:sqlSelect sqlStatement:&statement];
    if (success != SQLITE_OK) {
        NSLog(@"Error:%d failed to prepare to check",success);
        return -1;
    }
    //绑定参数
    sqlite3_bind_int(statement, 1, docId);
    sqlite3_bind_int(statement, 2, cId);
    
    while (sqlite3_step(statement)==SQLITE_ROW)
    {
        sqlite3_finalize(statement);
        sqlite3_close(database);
        return 1;
    }
    
    return 0;
}



//添加一条新记录，返回该新闻条目的id。
//在添加之前，先基于docid和channelid判断是否应经存在，如果有，则不添加并返回0。
-(NSInteger)add:(NewsItem*)newsItem
{
    NSInteger hasExist = [self hasExist:newsItem.docId channelId:newsItem.channelId];
    switch (hasExist) {
        case -1://出错
            return -1;
            break;
        case 1://已存在，无需添加
            return 0;
            break;
        default:
            break;
    }
    
    if ([self openDatabase]==FALSE) {
        return -1;
    }
    
    NSString *sql = @"INSERT INTO NewsItems (docId,channelId,topic,type,createDate,discussNum,docSource,smallImageHref,abstracts) VALUES (?,?,?,?,?,?,?,?,?)";
    
    sqlite3_stmt *statement = nil;
    int success = [self prepareSql:sql sqlStatement:&statement];
    if (success != SQLITE_OK) {
        NSLog(@"Error:%d failed to prepare insert",success);
        return -1;
    }
    
    //绑定参数
    sqlite3_bind_int(statement, 1, newsItem.docId);
    sqlite3_bind_int(statement, 2, newsItem.channelId);
    sqlite3_bind_text(statement, 3, [newsItem.topic UTF8String], -1, NULL);
	sqlite3_bind_int(statement, 4, newsItem.type);
    sqlite3_bind_text(statement, 5, [newsItem.createDate UTF8String], -1, NULL);
	sqlite3_bind_int(statement, 6, newsItem.discussNum);
    sqlite3_bind_text(statement, 7,[newsItem.docSource UTF8String], -1, NULL);
    sqlite3_bind_text(statement, 8,[newsItem.smallImageHref UTF8String], -1, NULL);
    sqlite3_bind_text(statement, 9,[newsItem.abstract UTF8String], -1, NULL);
    success = sqlite3_step(statement);
    
    if (success == SQLITE_ERROR) {
        NSLog(@"Error: failed to insert into the database");
        sqlite3_finalize(statement);
        sqlite3_close(database);
        return -1;
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    
    // NSLog(@"rowid%llu",sqlite3_last_insert_rowid);
    //return sqlite3_last_insert_rowid(database);
    return newsItem.docId;
}

//根据栏目id，返回该栏目下一级新闻条目列表
-(NSMutableArray *)getListByPage:(NSInteger)channelId pageNum:(NSInteger)number pageSize:(NSInteger)size{
    
    NSMutableArray *newsItemMutableArray=[[[NSMutableArray alloc] init] autorelease];
    
    if ([self openDatabase]==FALSE) {
        return nil;
    }
    
    NSString *sql = @"SELECT * FROM NewsItems where channelId = ? order by createDate Desc limit ?,?";
    sqlite3_stmt *statement = nil;
    int success = [self prepareSql:sql sqlStatement:&statement];
    if (success != SQLITE_OK) {
        NSLog(@"Error:%d failed to prepare select",success);
        return nil;
    }
    
    //绑定参数
	sqlite3_bind_int(statement, 1, channelId);
    sqlite3_bind_int(statement, 2, (number-1)*size);
    sqlite3_bind_int(statement, 3, size);
    
    while (sqlite3_step(statement)==SQLITE_ROW) {
        NewsItem *newsItem=[[NewsItem alloc] init];
        
        newsItem.docId = sqlite3_column_int(statement, 0);
        newsItem.channelId = sqlite3_column_int(statement, 1);
        newsItem.topic = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
        newsItem.type = sqlite3_column_int(statement, 3);
        newsItem.createDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
        newsItem.discussNum = sqlite3_column_int(statement, 5);
        newsItem.docSource = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
        newsItem.smallImageHref = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
        newsItem.abstract = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
        
        [newsItemMutableArray addObject:newsItem];
        [newsItem release];
        
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    
    return newsItemMutableArray;
}

//根据栏目id和新闻条目id，获取该新闻条目日期之前列表。
-(NSMutableArray*)getListBeforeCurrentNews:(NSInteger)channelId docId:(NSInteger)dId itemCount:(NSInteger)count
{
    NSMutableArray *newsItemMutableArray=[[[NSMutableArray alloc] init] autorelease];
    
    if ([self openDatabase]==FALSE) {
        return nil;
    }
    
    NSString *sql = @"SELECT * FROM NewsItems where channelId = ? and createDate < ( select createDate from NewsItems where docId = ? and channelId = ? ) order by createDate Desc limit ?";
    sqlite3_stmt *statement = nil;
    int success = [self prepareSql:sql sqlStatement:&statement];
    if (success != SQLITE_OK) {
        NSLog(@"Error:%d failed to prepare select",success);
        return nil;
    }
    
    //绑定参数
	sqlite3_bind_int(statement, 1, channelId);
    sqlite3_bind_int(statement, 2, dId);
    sqlite3_bind_int(statement, 3, channelId);
    sqlite3_bind_int(statement, 4, count);
    
    while (sqlite3_step(statement)==SQLITE_ROW) {
        NewsItem *newsItem=[[NewsItem alloc] init];
        
        newsItem.docId = sqlite3_column_int(statement, 0);
        newsItem.channelId = sqlite3_column_int(statement, 1);
        newsItem.topic = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
        newsItem.type = sqlite3_column_int(statement, 3);
        newsItem.createDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
        newsItem.discussNum = sqlite3_column_int(statement, 5);
        newsItem.docSource = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
        newsItem.smallImageHref = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
        newsItem.abstract = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
        
        [newsItemMutableArray addObject:newsItem];
        [newsItem release];
        
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    
    return newsItemMutableArray;
}

//根据docId和channelId获取单条新闻条目信息
-(NewsItem*)getItemByChannelId:(NSInteger)cId docId:(NSInteger)dId
{
    NewsItem *news = [[[NewsItem alloc] init] autorelease];
    
    if ([self openDatabase]==FALSE) {
        return nil;
    }
    
    NSString *sql = @"SELECT * FROM NewsItems where channelId = ? and docId = ?";
    sqlite3_stmt *statement = nil;
    int success = [self prepareSql:sql sqlStatement:&statement];
    if (success != SQLITE_OK) {
        NSLog(@"Error:%d failed to prepare select",success);
        return nil;
    }
    
    //绑定参数
	sqlite3_bind_int(statement, 1, cId);
    sqlite3_bind_int(statement, 2, dId);
    
    while (sqlite3_step(statement)==SQLITE_ROW) {
        news.docId = sqlite3_column_int(statement, 0);
        news.channelId = sqlite3_column_int(statement, 1);
        news.topic = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
        news.type = sqlite3_column_int(statement, 3);
        news.createDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
        news.discussNum = sqlite3_column_int(statement, 5);
        news.docSource = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
        news.smallImageHref = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
        news.abstract = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    
    return news;

}

//清除缓存，即删除所有新闻条目。
-(BOOL)deleteAll{
    if ([self openDatabase]==FALSE) {
        return NO;
    }
    
    NSString *sql = @"DELETE FROM NewsItems";
    
    sqlite3_stmt *statement = nil;
    int success = [self prepareSql:sql sqlStatement:&statement];
    if (success != SQLITE_OK) {
        NSLog(@"Error:%d failed to prepare delete",success);
        return NO;
    }
    
    success = sqlite3_step(statement);
    
    if (success == SQLITE_ERROR) {
        NSLog(@"Error: failed to delete the database");
        sqlite3_finalize(statement);
        sqlite3_close(database);
        return NO;
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    
    return YES;

}

@end
