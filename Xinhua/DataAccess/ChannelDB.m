//
//  ChannelDB.m
//  XinHuaInternational
//
//  Created by zh ch on 13-1-22.
//  Copyright (c) 2013年  miti. All rights reserved.
//

#import "ChannelDB.h"

@implementation ChannelDB

//根据栏目id和语言类别，判断该栏目是否已经存在
-(BOOL)hasExist:(NSInteger)channelId languageType:(NSString *)languageType
{
    if ([self openDatabase]==FALSE) {
        return NO;
    }
    
    NSString *sqlSelect = @" SELECT * FROM Channels WHERE id=? and language=? ";
    sqlite3_stmt *statement = nil;
    int success = [self prepareSql:sqlSelect sqlStatement:&statement];
    if (success != SQLITE_OK) {
        NSLog(@"Error:%d failed to prepare to check",success);
        return NO;
    }
    //绑定参数
    sqlite3_bind_int(statement, 1, channelId);
    sqlite3_bind_text(statement, 2,[languageType UTF8String], -1, NULL);
    
    while (sqlite3_step(statement)==SQLITE_ROW)
    {
        sqlite3_finalize(statement);
        sqlite3_close(database);
        return YES;
    }
    
    return NO;

}

//添加一条新栏目记录，返回该栏目的id；不成功返回-1
-(NSInteger)add:(Channel*)channel
{
    if ([self openDatabase]==FALSE) {
        return -1;
    }
    
    NSString *sql = @"INSERT INTO Channels (id,text,channelVersion,channelGroup,level,sortFlag,channelType,leaf,parentID,channelIcon,language) VALUES (?,?,?,?,?,?,?,?,?,?,?)";
    
    sqlite3_stmt *statement = nil;
    int success = [self prepareSql:sql sqlStatement:&statement];
    if (success != SQLITE_OK) {
        NSLog(@"Error:%d failed to prepare insert",success);
        return -1;
    }
    NSLog(@"%@",channel);
    
    //绑定参数
    sqlite3_bind_int(statement, 1, channel.channelId);
    sqlite3_bind_text(statement, 2, [channel.text UTF8String], -1, NULL);
	sqlite3_bind_text(statement, 3, [channel.version UTF8String], -1, NULL);
    sqlite3_bind_text(statement, 4, [channel.group UTF8String], -1, NULL);
	sqlite3_bind_int(statement, 5, channel.level);
    sqlite3_bind_int(statement, 6, channel.sortFlag);
    sqlite3_bind_int(statement, 7, channel.type);
    sqlite3_bind_int(statement, 8, channel.leaf);
    sqlite3_bind_int(statement, 9, channel.parentId);
    sqlite3_bind_text(statement, 10,[channel.icon UTF8String], -1, NULL);
    sqlite3_bind_text(statement, 11,[channel.language UTF8String], -1, NULL);
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
    return channel.channelId;
}
//批量插入多条新闻条目。成功返回1；部分成功（有部分已经存在）返回0；异常返回-1.
-(NSInteger)addList:(NSMutableArray*)channelItems
{
    
    if ([self openDatabase]==FALSE) {
        return -1;
    }
    NSInteger count = 0;
    //开启事务
    [self beginTransaction];
    //首先循环判断是否已经存在。对于已经存在的暂时不做处理，只插入不存在的新闻条目
    sqlite3_stmt *statement = nil;
    //对去重过的新闻条目列表插入到数据库
    NSString *sql = @"INSERT INTO Channels (id,text,channelVersion,channelGroup,level,sortFlag,channelType,leaf,parentID,channelIcon,language) VALUES (?,?,?,?,?,?,?,?,?,?,?)";
    int  success = [self prepareSql:sql sqlStatement:&statement];
    if (success != SQLITE_OK) {
        NSLog(@"Error:%d failed to prepare insert",success);
        return -1;
    }
    for(int i = 0;i<[channelItems count];i++)
    {
        Channel *channel = [channelItems objectAtIndex:i];
        //绑定参数
        sqlite3_bind_int(statement, 1, channel.channelId);
        sqlite3_bind_text(statement, 2, [channel.text UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 3, [channel.version UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 4, [channel.group UTF8String], -1, NULL);
        sqlite3_bind_int(statement, 5, channel.level);
        sqlite3_bind_int(statement, 6, channel.sortFlag);
        sqlite3_bind_int(statement, 7, channel.type);
        sqlite3_bind_int(statement, 8, channel.leaf);
        sqlite3_bind_int(statement, 9, channel.parentId);
        sqlite3_bind_text(statement, 10,[channel.icon UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 11,[channel.language UTF8String], -1, NULL);
        success = sqlite3_step(statement);
        if (success == SQLITE_ERROR) {
            NSLog(@"Error: failed to insert into the database");
            sqlite3_finalize(statement);
            sqlite3_close(database);
            return -1;
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
    return count;
    
}



//基于栏目id删除该栏目。删除成功返回YES，否则为NO。
-(BOOL)deleteById:(NSInteger)channelId{
    if ([self openDatabase]==FALSE) {
        return NO;
    }
    
    NSString *sql = @"DELETE FROM Channels WHERE id = ?";
    sqlite3_stmt *statement = nil;
    int success = [self prepareSql:sql sqlStatement:&statement];
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to prepare");
        return NO;
    }
    
    //绑定参数
    sqlite3_bind_int(statement,1,channelId);
    
    success = sqlite3_step(statement);
    
    if (success == SQLITE_ERROR) {
        NSLog(@"Error: failed to delete record");
        sqlite3_finalize(statement);
        sqlite3_close(database);
        return NO;
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(database);
    
    return YES;
}

//根据传入的栏目id，更新该栏目信息。如果未找到该栏目或更新不成功，则返回NO;否则为YES
-(BOOL)update:(Channel*)channel{
    if ([self openDatabase]==FALSE) {
        return NO;
    }
    
    NSString *sql = @"UPDATE Channels SET text=?,channelVersion=?,channelGroup=?,level=?,sortFlag=?,channelType=?,leaf=?,parentID=?,channelIcon=?,language=? Where id=?";
    sqlite3_stmt *statement = nil;
    int success = [self prepareSql:sql sqlStatement:&statement];
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to prepare");
        return NO;
    }
    
    //绑定参数
    sqlite3_bind_text(statement, 1, [channel.text UTF8String], -1, NULL);
	sqlite3_bind_text(statement, 2, [channel.version UTF8String], -1, NULL);
    sqlite3_bind_text(statement, 3, [channel.group UTF8String], -1, NULL);
	sqlite3_bind_int(statement, 4, channel.level);
    sqlite3_bind_int(statement, 5, channel.sortFlag);
    sqlite3_bind_int(statement, 6, channel.type);
    sqlite3_bind_int(statement, 7, channel.leaf);
    sqlite3_bind_int(statement, 8, channel.parentId);
    sqlite3_bind_text(statement, 9,[channel.icon UTF8String], -1, NULL);
    sqlite3_bind_text(statement, 10,[channel.language UTF8String], -1, NULL);
    sqlite3_bind_int(statement, 11, channel.channelId);
    
    success = sqlite3_step(statement);
    
    if (success == SQLITE_ERROR) {
        NSLog(@"Error: failed to update record");
        sqlite3_finalize(statement);
        sqlite3_close(database);
        return NO;
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    
    return YES;
}

//根据栏目id，返回该栏目下一级的子栏目列表（其中包含栏目的详细信息）
//如果传入的id为0，则返回第一级栏目列表
-(NSMutableArray*)getList:(NSInteger)channelId languageType:(NSString *)languageType{
    NSMutableArray *channelMutableArray=[[[NSMutableArray alloc] init] autorelease];
    
    if ([self openDatabase]==FALSE) {
        return nil;
    }
    
    NSString *sql = @"SELECT * FROM Channels where parentID = ? and language=? order by sortFlag ";
    sqlite3_stmt *statement = nil;
    int success = [self prepareSql:sql sqlStatement:&statement];
    if (success != SQLITE_OK) {
        NSLog(@"Error:%d failed to prepare select",success);
        return nil;
    }
    
    //绑定参数
    sqlite3_bind_int(statement, 1, channelId);
    sqlite3_bind_text(statement, 2,[languageType UTF8String], -1, NULL);
    
    while (sqlite3_step(statement)==SQLITE_ROW) {
        Channel *channel=[[Channel alloc] init];
        
        channel.channelId = sqlite3_column_int(statement, 0);
        channel.text = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
        channel.version = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
        channel.group = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
        channel.level = sqlite3_column_int(statement, 4);
        channel.sortFlag = sqlite3_column_int(statement, 5);
        channel.type = sqlite3_column_int(statement, 6);
        channel.leaf = sqlite3_column_int(statement, 7);
        channel.parentId = sqlite3_column_int(statement, 8);
        channel.icon = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
 		channel.language = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
        [channelMutableArray addObject:channel];
        [channel release];
        
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    
    return channelMutableArray;
}

-(NSMutableArray*)getListByType:(NSInteger)type languageType:(NSString *)languageType level:(NSInteger)level{
    NSMutableArray *channelMutableArray=[[[NSMutableArray alloc] init] autorelease];
    
    if ([self openDatabase]==FALSE) {
        return nil;
    }
    
    NSString *sql = @"SELECT * FROM Channels where channelType = ? and language=? and level=? order by sortFlag ";
    sqlite3_stmt *statement = nil;
    int success = [self prepareSql:sql sqlStatement:&statement];
    if (success != SQLITE_OK) {
        NSLog(@"Error:%d failed to prepare select",success);
        return nil;
    }
    
    //绑定参数
    sqlite3_bind_int(statement, 1, type);
    sqlite3_bind_text(statement, 2,[languageType UTF8String], -1, NULL);
    sqlite3_bind_int(statement, 3,level);
    
    while (sqlite3_step(statement)==SQLITE_ROW) {
        Channel *channel=[[Channel alloc] init];
        
        channel.channelId = sqlite3_column_int(statement, 0);
        channel.text = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
        channel.version = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
        channel.group = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
        channel.level = sqlite3_column_int(statement, 4);
        channel.sortFlag = sqlite3_column_int(statement, 5);
        channel.type = sqlite3_column_int(statement, 6);
        channel.leaf = sqlite3_column_int(statement, 7);
        channel.parentId = sqlite3_column_int(statement, 8);
        channel.icon = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
 		channel.language = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
        [channelMutableArray addObject:channel];
        [channel release];
        
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    
    return channelMutableArray;
}
-(NSMutableArray *)getAllChannelByLanguage:(NSString *)languageType
{
    NSMutableArray *channelMutableArray=[[[NSMutableArray alloc] init] autorelease];
    
    if ([self openDatabase]==FALSE) {
        return nil;
    }
    
    NSString *sql = @"SELECT * FROM Channels where language=?";
    sqlite3_stmt *statement = nil;
    int success = [self prepareSql:sql sqlStatement:&statement];
    if (success != SQLITE_OK) {
        NSLog(@"Error:%d failed to prepare select",success);
        return nil;
    }
    //绑定参数
    sqlite3_bind_text(statement, 1,[languageType UTF8String], -1, NULL);
    
    while (sqlite3_step(statement)==SQLITE_ROW) {
        Channel *channel=[[Channel alloc] init];
        channel.channelId = sqlite3_column_int(statement, 0);
        channel.text = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
        channel.version = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
        channel.group = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
        channel.level = sqlite3_column_int(statement, 4);
        channel.sortFlag = sqlite3_column_int(statement, 5);
        channel.type = sqlite3_column_int(statement, 6);
        channel.leaf = sqlite3_column_int(statement, 7);
        channel.parentId = sqlite3_column_int(statement, 8);
        channel.icon = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
 		channel.language = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
        [channelMutableArray addObject:channel];
        [channel release];
        
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    
    return channelMutableArray;

}

//清除缓存，即删除所有新闻正文内容。
-(BOOL)deleteAll{
    if ([self openDatabase]==FALSE) {
        return NO;
    }
    
    NSString *sql = @"DELETE FROM Channels";
    
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
-(Channel *)getChannel:(NSInteger)channelId
{
    if ([self openDatabase]==FALSE) {
        return nil;
    }
    
    NSString *sql = @"SELECT * FROM Channels where id = ?";
    sqlite3_stmt *statement = nil;
    int success = [self prepareSql:sql sqlStatement:&statement];
    if (success != SQLITE_OK) {
        NSLog(@"Error:%d failed to prepare select",success);
        return nil;
    }
     Channel *channel=[[[Channel alloc] init] autorelease];
    //绑定参数
    sqlite3_bind_int(statement, 1, channelId);
        while (sqlite3_step(statement)==SQLITE_ROW) {
        channel.channelId = sqlite3_column_int(statement, 0);
        channel.text = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
        channel.version = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
        channel.group = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
        channel.level = sqlite3_column_int(statement, 4);
        channel.sortFlag = sqlite3_column_int(statement, 5);
        channel.type = sqlite3_column_int(statement, 6);
        channel.leaf = sqlite3_column_int(statement, 7);
        channel.parentId = sqlite3_column_int(statement, 8);
        channel.icon = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
 		channel.language = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];

    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    
    return channel;

}

@end
