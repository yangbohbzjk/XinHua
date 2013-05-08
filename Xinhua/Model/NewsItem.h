//
//  NewsItem.h
//  XinHuaInternational
//
//  Created by zh ch on 13-1-22.
//  Copyright (c) 2013年  miti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsItem : NSObject{
}

@property (nonatomic,assign) NSInteger docId;
@property (nonatomic,assign) NSInteger channelId;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,assign) NSInteger discussNum;

@property (nonatomic,copy) NSString *topic;
@property (nonatomic,copy) NSString *createDate;
@property (nonatomic,copy) NSString *docSource;
@property (nonatomic,copy) NSString *smallImageHref;
@property (nonatomic,copy) NSString *abstract;

@end
