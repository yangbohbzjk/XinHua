//
//  Channel.m
//  XinHuaInternational
//
//  Created by zh ch on 13-1-22.
//  Copyright (c) 2013年  miti. All rights reserved.
//

#import "Channel.h"

@implementation Channel

@synthesize channelId,text,version,group,level,sortFlag,type,leaf,parentId,icon,language,userName;

-(Channel*)init
{
    self=[super init];
	self.channelId = 0;
    self.text = @"";
    self.version = @"";
    self.group = @"";
    self.level = 0;
    self.sortFlag = 0;
    self.type = 0;
    self.leaf = 0;
    self.parentId = 0;
    self.icon = @"";
    self.language = @"";
    self.userName= @"";
    return self;
}
-(void)dealloc{
    [text release];
    [version release];
    [group release];
    [icon release];
    [language release];
    [super dealloc];
}

@end
