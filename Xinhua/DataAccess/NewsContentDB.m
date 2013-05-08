//
//  NewsContent.m
//  XinHuaInternational
//
//  Created by zh ch on 13-1-22.
//  Copyright (c) 2013年  miti. All rights reserved.
//

#import "NewsContentDB.h"

@implementation NewsContentDB


//添加一条新记录，返回该新闻条目的id。
//在添加之前，先基于docid和channelid判断是否应经存在，如果有，则不添加并返回0。
//如果出现异常，则返回-1
-(NSInteger)add:(NewsContent*)newsContent
{
    NSInteger hasExist = [self hasExist:newsContent.docId channelId:newsContent.channelId];
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
    
    NSString *sql = @"INSERT INTO NewsContents (docId,channelId,topic,content,type,authors,createDate,discussNum,middleImageURL,largeImageURL,docSource,videoURL,imagelist) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";
    
    sqlite3_stmt *statement = nil;
    int success = [self prepareSql:sql sqlStatement:&statement];
    if (success != SQLITE_OK) {
        NSLog(@"Error:%d failed to prepare insert",success);
        return -1;
    }
    
    //绑定参数
    sqlite3_bind_int(statement, 1, newsContent.docId);
    sqlite3_bind_int(statement, 2, newsContent.channelId);
    sqlite3_bind_text(statement, 3, [newsContent.topic UTF8String], -1, NULL);
    sqlite3_bind_text(statement, 4, [newsContent.content UTF8String], -1, NULL);
	sqlite3_bind_int(statement, 5, newsContent.type);
    sqlite3_bind_text(statement, 6, [newsContent.authors UTF8String], -1, NULL);
    sqlite3_bind_text(statement, 7, [newsContent.createDate UTF8String], -1, NULL);
	sqlite3_bind_int(statement, 8, newsContent.discussNum);
    sqlite3_bind_text(statement, 9, [newsContent.middleImageURL UTF8String], -1, NULL);
    sqlite3_bind_text(statement, 10, [newsContent.largeImageURL UTF8String], -1, NULL);
    sqlite3_bind_text(statement, 11,[newsContent.docSource UTF8String], -1, NULL);
    sqlite3_bind_text(statement, 12,[newsContent.videoURL UTF8String], -1, NULL);
    sqlite3_bind_text(statement, 13,[newsContent.imageList UTF8String], -1, NULL);
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
    return newsContent.docId;

}

//基于docid和channelid判断是否已经存在
//0--不存在；1--存在；-1--程序错误
-(NSInteger)hasExist:(NSInteger)docId channelId:(NSInteger)cId{
    if ([self openDatabase]==FALSE) {
        return -1;
    }
    
    NSString *sqlSelect = @" SELECT * FROM NewsContents WHERE docId=? and channelId=? ";
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
    sqlite3_finalize(statement);
    sqlite3_close(database);
    return 0;
}

//根据栏目id和新闻条目id，得到一条新闻的详细信息
-(NewsContent*)getNewsContent:(NSInteger)channelId docId:(NSInteger)dId{
    NewsContent *news = [[[NewsContent alloc] init] autorelease];
    
    if ([self openDatabase]==FALSE) {
        return nil;
    }
    
    NSString *sql = @"SELECT * FROM NewsContents where channelId = ? and docId = ?";
    sqlite3_stmt *statement = nil;
    int success = [self prepareSql:sql sqlStatement:&statement];
    if (success != SQLITE_OK) {
        NSLog(@"Error:%d failed to prepare select",success);
        return nil;
    }
    
    //绑定参数
	sqlite3_bind_int(statement, 1, channelId);
    sqlite3_bind_int(statement, 2, dId);
    
    while (sqlite3_step(statement)==SQLITE_ROW) {
        news.docId = sqlite3_column_int(statement, 0);
        news.channelId = sqlite3_column_int(statement, 1);
        news.topic = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
        news.content = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
        news.type = sqlite3_column_int(statement, 4);
        news.authors = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
        news.createDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
        news.discussNum = sqlite3_column_int(statement, 7);
        news.middleImageURL = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
        news.largeImageURL = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
        news.docSource = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
        news.videoURL = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
        news.imageList = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    
    return news;
}

//清除缓存，即删除所有新闻正文内容。
-(BOOL)deleteAll{
    if ([self openDatabase]==FALSE) {
        return NO;
    }
    
    NSString *sql = @"DELETE FROM NewsContents";
    
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
