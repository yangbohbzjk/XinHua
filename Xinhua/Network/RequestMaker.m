//
//  RequestMaker.m
//  NetworkDemo
//
//  Created by Haoran Yu on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RequestMaker.h"
#import "NetworkManager.h"
#import "ASIHTTPRequest.h"
#import "NetWorkConfig.h"
#import "JSONKit.h"
@implementation RequestMaker


+ (void)getChannels:(NSString *)ClientID LanguageType:(NSInteger)languageType delegate:(id)delegate action:(SEL)action
{
    //http://202.84.17.194/cm/vipapi/tree?id=141
    NSString *url;
    
    NSString *currentLanguage = [[NSUserDefaults standardUserDefaults]objectForKey:AppLanguage];
    if ([currentLanguage isEqualToString: @"en"]) {
        languageType = EnglishLanguage;
    }else
    {
        languageType = ChineseLanguage;
    }
    switch (languageType) {
        case ChineseLanguage:
            url = [NSString stringWithFormat:@"%@%@/tree?languageType=%d",kBaseRequestUrl,clientID,languageType];
            break;
        case EnglishLanguage:
            url = [NSString stringWithFormat:@"%@%@/tree?languageType=%d",kBaseRequestUrl,clientID,languageType];
            break;
        default:
            url = [NSString stringWithFormat:@"%@%@/tree",kBaseRequestUrl,clientID];
            break;
    }
    NSLog(@"%@",url);
   
    NSMutableDictionary *requestInfo = [[NSMutableDictionary alloc] init];
    [requestInfo setObject:url forKey:RequestUrl];
    [requestInfo setObject:GetChannels forKey:RequestTYPE];
    [[NetworkManager sharedManager] requestDataWithDelegate:delegate info:requestInfo selfaction:action];
    [requestInfo release];requestInfo = nil;
}

@end