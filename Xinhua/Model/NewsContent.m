//
//  NewsContent.m
//  XinHuaInternational
//
//  新闻正文类
//
//  Created by zh ch on 13-1-22.
//  Copyright (c) 2013年  miti. All rights reserved.
//

#import "NewsContent.h"

@implementation NewsContent

@synthesize docId,channelId,topic,content,type,authors,createDate,discussNum,middleImageURL,largeImageURL,docSource,videoURL,imageList;

-(NewsContent*)init
{
    self=[super init];
	self.docId = 0;
    self.channelId = 0;
    self.topic = @"";
    self.content = @"";
    self.type = 0;
    self.authors = @"";
    self.createDate = @"";
    self.discussNum = 0;
    self.middleImageURL = @"";
    self.largeImageURL = @"";
    self.videoURL = @"";
    self.docSource = @"";
    self.imageList = @"";
    
    return self;
}
-(void)dealloc{
    [topic release];
    [content release];
    [authors release];
    [createDate release];
    [middleImageURL release];
    [largeImageURL release];
    [videoURL release];
    [docSource release];
    [imageList release];
    [super dealloc];
}


@end
