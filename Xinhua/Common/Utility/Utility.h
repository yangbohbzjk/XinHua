//
//  Utility.h
//  XinHuaInternational
//
//  Created by  miti on 13-1-24.
//  Copyright (c) 2013年  miti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsContent.h"

@interface Utility : NSObject{

}
+(NSMutableArray *)parseFromDataChannel:(NSData *)data;//栏目解析
+(NSMutableArray *)parseFromDataNews:(NSData *)data;//新闻解析
+(NSMutableArray *)parseFromDataContent:(NSData *)data;//新闻内容解析

+(UIImage *)scale:(UIImage *)image toSize:(CGSize)size;
+(UIImage *)scale:(UIImage *)image toHeight:(float)height;
+(UIImage *)scale:(UIImage *)image toWidth:(float)width;
+(UIImage *)cutImage:(UIImage *)image toSize:(CGSize)size;
//+(UIImage *)scaleWithNoTransform:(UIImage *)image toSize:(CGSize)size;

//根据图片http路径映射为本地文件名
+(NSString *)mapURLtoLocalFilename:(NSString *)url;
//根据图片httpURL获取本地图片，如果未找到返回nil
+(UIImage *)getLocalImageFileByURL:(NSString *)imageUrl;
//将该文件写入沙盒中对应的位置
+(BOOL)saveImage:(UIImage *)image localFileName:(NSString *)filename;
+(BOOL)getPicTag;
+(NSString*)getMiddleImageURL:(NewsContent*)newsContent;

+(NSInteger)getDefaultFontSize;
+(NSString*)getCurrentUsername;
+(NSUInteger)testConnection;
+(void)DeleteCache;//删除缓存

+(NSString*)FilterFormatOfNewsContent:(NSString*)contentStr;//将新闻正文的换行、空格等字符进行预处理

@end
