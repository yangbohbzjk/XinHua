//
//  NewsItem.m
//  XinHuaInternational
//
//  新闻列表项类
//
//  Created by zh ch on 13-1-22.
//  Copyright (c) 2013年  miti. All rights reserved.
//

#import "NewsItem.h"

@implementation NewsItem

@synthesize docId,channelId,topic,type,createDate,discussNum,docSource,smallImageHref,abstract;


-(NewsItem*)init
{
    self=[super init];
	self.docId = 0;
    self.channelId = 0;
    self.topic = @"";
    self.type = 0;
    self.createDate = @"";
    self.discussNum = 0;
    self.docSource = @"";
    self.smallImageHref = @"";
    self.abstract = @"";
    
    return self;
}
-(void)dealloc{
    [topic release];
    [createDate release];
    [docSource release];
    [smallImageHref release];
    [abstract release];
    [super dealloc];
}


@end
