//
//  NewsCollection.h
//  XinHuaInternational
//
//  类说明:新闻收藏。用于保存用户收藏的新闻的内容。属性基本上与NewsContent类属性相同 
//
//  Created by zh ch on 13-1-22.
//  Copyright (c) 2013年  miti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsCollection : NSObject{

}


@property (nonatomic,copy) NSString *username;      //收藏用户名。

@property (nonatomic,assign) NSInteger docId;       //新闻文档标识
@property (nonatomic,assign) NSInteger channelId;   //与栏目类的标识对应
@property (nonatomic,assign) NSInteger type;        //

@property (nonatomic,copy) NSString *topic;         //
@property (nonatomic,copy) NSString *smallImageHref;//
@property (nonatomic,copy) NSString *docSource;
@property (nonatomic,copy) NSString *createDate;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *largeImageURL;
@property (nonatomic,copy) NSString *videoURL;
@property (nonatomic,copy) NSString *middleImageURL;
@property (nonatomic,copy) NSString *abstract;
@property (nonatomic,copy) NSString *authors;
@property (nonatomic,copy) NSString *imagelist;
@end
