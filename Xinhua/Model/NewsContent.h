//
//  NewsContent.h
//  XinHuaInternational
//
//  Created by zh ch on 13-1-22.
//  Copyright (c) 2013年  miti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsContent : NSObject{
}

@property (nonatomic,assign) NSInteger docId;
@property (nonatomic,assign) NSInteger channelId;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,assign) NSInteger discussNum;

@property (nonatomic,copy) NSString *topic;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *authors;
@property (nonatomic,copy) NSString *createDate;
@property (nonatomic,copy) NSString *middleImageURL;
@property (nonatomic,copy) NSString *largeImageURL;
@property (nonatomic,copy) NSString *docSource;
@property (nonatomic,copy) NSString *videoURL;
@property (nonatomic,copy) NSString *imageList;

@end
