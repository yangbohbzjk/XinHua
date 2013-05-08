//
//  Comment.m
//  XinHuaInternational
//
//  Created by  miti on 13-4-2.
//  Copyright (c) 2013年  miti. All rights reserved.
//

#import "Comment.h"



@implementation Comment
@synthesize cid,commenttext;

-(Comment*)init
{
    self=[super init];
	self.cid=@"";
    self.commenttext=@"";
    return self;
}
-(void)dealloc{
    [cid release];
    [commenttext release];
    [super dealloc];
}

@end
