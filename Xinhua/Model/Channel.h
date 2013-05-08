//
//  Channel.h
//  XinHuaInternational
//
//  Created by zh ch on 13-1-22.
//  Copyright (c) 2013年  miti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Channel : NSObject{

}
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,assign) NSInteger channelId;      //栏目标识，主键。

@property (nonatomic,copy) NSString *text;              //栏目名称
@property (nonatomic,copy) NSString *group;             //栏目组 ？暂时未用
@property (nonatomic,copy) NSString *version;           //栏目版本

@property (nonatomic,assign) NSInteger level;           //栏目级别
@property (nonatomic,assign) NSInteger sortFlag;        //排序
@property (nonatomic,assign) NSInteger type;            //类别,1.普通栏目 2.天气预报 3.快讯 4.网页 5.首页 6.置顶 7.专题 8.爆料
@property (nonatomic,assign) NSInteger leaf;            ////1标识是叶子节点，无子栏目
@property (nonatomic,assign) NSInteger parentId;        //父栏目标识//0标识无父栏目，即顶级栏目

@property (nonatomic,copy) NSString *icon;              //栏目图标文件名
@property (nonatomic,copy) NSString *language;          //栏目语种。中文：CH；英文：EN

@end
