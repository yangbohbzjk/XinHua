//
//  NewsCollectionDB.m
//  XinHuaInternational
//
//  Created by  miti on 13-1-27.
//  Copyright (c) 2013年  miti. All rights reserved.
//

#import "NewsCollectionDB.h"

@implementation NewsCollectionDB
//添加一条新记录，返回该新闻收藏的id。
//在添加之前，先基于docid和channelid判断是否应经存在，如果有，则不添加并返回0。
//如果出现异常，则返回-1
-(NSInteger)add:(NewsCollection*)newsCollection;
{
    NSInteger hasExist = [self hasExist:newsCollection.docId channelId:newsCollection.channelId userName:newsCollection.username];
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
    
    NSString *sql = @"INSERT INTO NewsCollections (username,docId,channelId,topic,type,smallImageHref,docSource,createDate,content,largeImageURL,videoURL,middleImageURL,abstracts,authors,imagelist) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    
    sqlite3_stmt *statement = nil;
    int success = [self prepareSql:sql sqlStatement:&statement];
    if (success != SQLITE_OK) {
        NSLog(@"Error:%d failed to prepare insert",success);
        return -1;
    }
    
    //绑定参数
    sqlite3_bind_text(statement, 1, [newsCollection.username UTF8String], -1, NULL);
    sqlite3_bind_int(statement, 2, newsCollection.docId);
    sqlite3_bind_int(statement, 3, newsCollection.channelId);
    sqlite3_bind_text(statement, 4, [newsCollection.topic UTF8String], -1, NULL);
    sqlite3_bind_int(statement, 5, newsCollection.type);
    sqlite3_bind_text(statement, 6, [newsCollection.smallImageHref UTF8String], -1, NULL);
    sqlite3_bind_text(statement, 7,[newsCollection.docSource UTF8String], -1, NULL);
    sqlite3_bind_text(statement, 8, [newsCollection.createDate UTF8String], -1, NULL);
    sqlite3_bind_text(statement, 9, [newsCollection.content UTF8String], -1, NULL);
    sqlite3_bind_text(statement, 10, [newsCollection.largeImageURL UTF8String], -1, NULL);
    sqlite3_bind_text(statement, 11,[newsCollection.videoURL UTF8String], -1, NULL);
    sqlite3_bind_text(statement, 12, [newsCollection.middleImageURL UTF8String], -1, NULL);
    sqlite3_bind_text(statement, 13, [newsCollection.abstract UTF8String], -1, NULL);
    sqlite3_bind_text(statement, 14, [newsCollection.authors UTF8String], -1, NULL);
    sqlite3_bind_text(statement, 15,[newsCollection.imagelist UTF8String], -1, NULL);
    
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
    return newsCollection.docId;
}

//基于docid和channelid判断是否已经存在
//0--不存在；1--存在；-1--程序错误
-(NSInteger)hasExist:(NSInteger)docId channelId:(NSInteger)cId userName:(NSString *)username
{
    if ([self openDatabase]==FALSE) {
        return -1;
    }
    
    NSString *sqlSelect = @" SELECT * FROM NewsCollections WHERE docId=? and channelId=? and username=?";
    sqlite3_stmt *statement = nil;
    int success = [self prepareSql:sqlSelect sqlStatement:&statement];
    if (success != SQLITE_OK) {
        NSLog(@"Error:%d failed to prepare to check",success);
        return -1;
    }
    //绑定参数
    sqlite3_bind_int(statement, 1, docId);
    sqlite3_bind_int(statement, 2, cId);
    sqlite3_bind_text(statement, 3, [username UTF8String], -1, NULL);
    
    while (sqlite3_step(statement)==SQLITE_ROW)
    {
        sqlite3_finalize(statement);
        sqlite3_close(database);
        return 1;
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    return 0;
}

//根据用户名，栏目id和新闻条目id，得到一条新闻收藏的详细信息
-(NewsCollection*)getNewsCollectionByUser:(NSString*)username channelId:(NSInteger)cId docId:(NSInteger)dId
{
    NewsCollection *news = [[[NewsCollection alloc] init] autorelease];
    
    if ([self openDatabase]==FALSE) {
        return nil;
    }
    
    NSString *sql = @"SELECT * FROM NewsCollections where username = ? and channelId = ? and docId = ?";
    sqlite3_stmt *statement = nil;
    int success = [self prepareSql:sql sqlStatement:&statement];
    if (success != SQLITE_OK) {
        NSLog(@"Error:%d failed to prepare select",success);
        return nil;
    }
    
    //绑定参数
    sqlite3_bind_text(statement, 1, [username UTF8String], -1, NULL);
	sqlite3_bind_int(statement, 2, cId);
    sqlite3_bind_int(statement, 3, dId);
    
    while (sqlite3_step(statement)==SQLITE_ROW) {
        news.username = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
        news.docId = sqlite3_column_int(statement, 1);
        news.channelId = sqlite3_column_int(statement, 2);
        news.topic = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
        news.type = sqlite3_column_int(statement, 4);
        news.smallImageHref = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
        news.docSource = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
        news.createDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
        news.content = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
        news.largeImageURL = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
        news.videoURL = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
        news.middleImageURL = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
        news.abstract = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
        news.authors = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
        news.imagelist = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    
    return news;

}

//清除收藏，即删除该条收藏记录。
-(BOOL)deleteCollectionByUser:(NSString*)username channelId:(NSInteger)cId docId:(NSInteger)dId
{
    if ([self openDatabase]==FALSE) {
        return NO;
    }
    
    NSString *sql = @"DELETE FROM NewsCollections where username=? and channelId=? and docId = ? ";
    
    sqlite3_stmt *statement = nil;
    int success = [self prepareSql:sql sqlStatement:&statement];
    if (success != SQLITE_OK) {
        NSLog(@"Error:%d failed to prepare delete",success);
        return NO;
    }
    //绑定参数
    sqlite3_bind_text(statement, 1, [username UTF8String], -1, NULL);
	sqlite3_bind_int(statement, 2, cId);
    sqlite3_bind_int(statement, 3, dId);
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

    return YES;
}

//根据用户名获取该用户所有收藏的新闻条目。默认用户名为空
-(NSMutableArray*)getNewsItemsFromCollectionByPage:(NSString*)username pageNum:(NSInteger)number pageSize:(NSInteger)size
{
    NSMutableArray *newsItemMutableArray=[[[NSMutableArray alloc] init] autorelease];
    
    if ([self openDatabase]==FALSE) {
        return nil;
    }
    
    NSString *sql = @"SELECT * FROM NewsCollections where username = ? order by createDate Desc limit ?,?";
    sqlite3_stmt *statement = nil;
    int success = [self prepareSql:sql sqlStatement:&statement];
    if (success != SQLITE_OK) {
        NSLog(@"Error:%d failed to prepare select",success);
        return nil;
    }
    //绑定参数
    sqlite3_bind_text(statement, 1, [username UTF8String], -1, NULL);
    sqlite3_bind_int(statement, 2, (number-1)*size);
    sqlite3_bind_int(statement, 3, size);

    while (sqlite3_step(statement)==SQLITE_ROW) {
        NewsItem *newsItem=[[NewsItem alloc] init];
        
        newsItem.docId = sqlite3_column_int(statement, 1);
        newsItem.channelId = sqlite3_column_int(statement, 2);
        newsItem.topic = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
        newsItem.type = sqlite3_column_int(statement, 4);
        newsItem.createDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
        newsItem.discussNum = 0;
        newsItem.docSource = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
        newsItem.smallImageHref = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
        newsItem.abstract = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
        
        [newsItemMutableArray addObject:newsItem];
        [newsItem release];
        
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    
    return newsItemMutableArray;
}

//清除缓存，即删除所有新闻条目。
-(BOOL)deleteAll{
    if ([self openDatabase]==FALSE) {
        return NO;
    }
    
    NSString *sql = @"DELETE FROM NewsCollections";
    
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
