//
//  DataBase.h
//  WeiPai
//
//  Created by Haoran Yu on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class Media;
@interface DataBase : NSObject{
    sqlite3 *database;
    NSString *path;
}

- (void)readyDatabse;
- (void)getPath;

+(DataBase*)sharedDB;

+(void)relaseDataBase;
-(BOOL)openDatabase;
-(void)beginTransaction;
-(void)commitTransaction;
-(int)prepareSql:(NSString *)sql sqlStatement:(sqlite3_stmt **)statement;

@end
