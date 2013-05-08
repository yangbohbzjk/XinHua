//
//  NewsCollection.m
//  XinHuaInternational
//
//  Created by zh ch on 13-1-22.
//  Copyright (c) 2013年  miti. All rights reserved.
//

#import "NewsCollection.h"

@implementation NewsCollection

@synthesize username,docId,channelId,topic,type,smallImageHref,docSource,createDate,content,largeImageURL,videoURL,middleImageURL,abstract,authors,imagelist;

-(NewsCollection*)init
{
    self=[super init];
	self.username = @"";
    self.docId = 0;
    self.channelId = 0;
    self.topic = @"";
    self.type = 0;
    self.smallImageHref = @"";
    self.docSource = @"";
    self.createDate = @"";
    self.content = @"";
    self.largeImageURL = @"";
    self.videoURL = @"";
    self.middleImageURL = @"";
    self.abstract = @"";
    self.imagelist = @"";
    self.authors = @"";
    
    return self;
}
-(void)dealloc{
    [username release];
    [topic release];
    [smallImageHref release];
    [docSource release];
    [createDate release];
    [content release];
    [largeImageURL release];
    [videoURL release];
    [middleImageURL release];
    [abstract release];
    [authors release];
    [imagelist release];
    [super dealloc];
}

@end
