//
//  DataBase.m
//  WeiPai
//
//  Created by Haoran Yu on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DataBase.h"
//#import "Media.h"
#define kDBFileName @"xhgj.db"

@implementation DataBase

static DataBase *sharedDB = nil;

-(id)init {
    self = [super init];
    if(self){
    }
    return self;
}

+(DataBase*)sharedDB
{
    @synchronized(self)
    {
        if(sharedDB==nil){
            sharedDB = [[DataBase alloc] init];
        }
    }
    
    return sharedDB;
}

+(void)relaseDataBase
{
    @synchronized(self)
    {
        if (sharedDB) {
            [sharedDB release],sharedDB=nil;
        }
    }
}

#pragma mark －准备数据库
- (void)readyDatabse {
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
	[self getPath];
    success = [fileManager fileExistsAtPath:path];
    if (success) return;
    //若document中数据库文件不存在，则复制一份
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kDBFileName];
    NSLog(@"%@",defaultDBPath);
    success = [fileManager copyItemAtPath:defaultDBPath toPath:path error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

#pragma mark －路径
- (void)getPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    path = [documentsDirectory stringByAppendingPathComponent:kDBFileName];
	NSLog(@"%@",path);
}

#pragma mark － 操作

//open database
-(BOOL)openDatabase{
	[self readyDatabse];
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
		return TRUE;
	}else {
		return FALSE;
	}
	
}

//prepare sql
-(int)prepareSql:(NSString *)sql sqlStatement:(sqlite3_stmt **)statement{
    NSLog(@"%@",sql);
	int success=sqlite3_prepare_v2(database, [sql cStringUsingEncoding:NSUTF8StringEncoding], -1, statement, NULL);
	return success;
}

//显式的开启一个事务
-(void)beginTransaction
{
    sqlite3_stmt* stmt2 = NULL;
    const char* beginSQL = "BEGIN TRANSACTION";
    if (sqlite3_prepare_v2(database,beginSQL,strlen(beginSQL),&stmt2,NULL) != SQLITE_OK) {
        if (stmt2)
            sqlite3_finalize(stmt2);
        sqlite3_close(database);
        return;
    }
    if (sqlite3_step(stmt2) != SQLITE_DONE) {
        sqlite3_finalize(stmt2);
        sqlite3_close(database);
        return;
    }
    sqlite3_finalize(stmt2);
}

//提交之前的事物
-(void)commitTransaction
{
    const char* commitSQL = "COMMIT";
    sqlite3_stmt* stmt4 = NULL;
    if (sqlite3_prepare_v2(database,commitSQL,strlen(commitSQL),&stmt4,NULL) != SQLITE_OK) {
        if (stmt4)
            sqlite3_finalize(stmt4);
        sqlite3_close(database);
        return;
    }
    if (sqlite3_step(stmt4) != SQLITE_DONE) {
        sqlite3_finalize(stmt4);
        sqlite3_close(database);
        return;
    }
    sqlite3_finalize(stmt4);
}


//close database
-(void)closeDatabase{
	sqlite3_close(database);
}

@end
