//
//  NetWorkConfig.h
//  Demo
//
//  Created by zyq on 13-1-23.
//  Copyright (c) 2013年 zyq. All rights reserved.
//

typedef enum
{
    DEFAULT,
    GETCHANNELS,
    GETNEWSITEM,
    GETNEWSCONTENT,
    GETAPPWRAPPER,
}OpeType;

typedef enum
{
    ChineseLanguage=1,
    EnglishLanguage=2,
    
}LanguageType;


#ifndef Demo_NetWorkConfig_h
#define Demo_NetWorkConfig_h

#define Username                @"xhgj"
#define Password                @"xhgj"
#define kMaxClientCount 5   //允许的最大上传进程数

#define advertRequestUrl @"http://202.84.17.194/cm/aic/advert"
#define advertType @"0"

#define kTimeoutInterval        20.0f
#define kTimeoutInterval2       15.0f
#define RequestUrl              @"url"
#define RequestMethod           @"requestMethod"
#define POST                    @"POST"
#define GET                     @"GET"
#define POST_BODY               @"postBody"
#define FileData                @"fileData"
#define XmlData                 @"xmlData"
#define FilePath                @"filePath"
#define XmlPath                 @"xmlPath"
#define MainScriptGuid          @"MainScriptGuid"
#define ReNewsId                @"ReNewsId"//回传的稿件id
#define ManuscriptInfo          @"ManuscriptInfo"
#define AttachmentPath          @"AttachmentPath"
#define clienttag               @"clienttag"
#define postContent             @"postcontent"

#define RequestStatus           @"requestStatus"
#define RequestSuccess          @"requestSuccess"
#define LastFail                @"LastFail"//最后一次失败
#define LastSucess              @"LastSucess"//最后一次成功
#define RequestFail             @"requestFail"
#define ResponseData            @"responseData"
#define ResponseError           @"responseError"

//上传原始文件名
#define UploadFileName          @"uploadFileName"

//上传文件类型
#define UploadFileType          @"uploadFileType"
#define XmlFile                 @"xmlFile"
#define MediaFile               @"mediaFile"
#define LogFile                 @"logFile"

//请求类型
#define RequestTYPE             @"requestTYPE"
#define Template                @"Template"
#define Login                   @"login"
#define Logout                  @"logout"
#define GetUrl                  @"geturl"
//#define GetUserInfo             @"getuserinfo"
#define SaveMultimediaFile      @"saveMultimediaFile"
#define DeleteUploadedFile      @"deleteUploadedFile"

#define GetChannels             @"getChannels"
#define GetNewsItems            @"getNewsItems"
#define GetNewsContent          @"getNewsContent"
#define GetAppWrapper           @"getAppWrapper"
#define GetSmallImage           @"getSmallImage"
#define GetMiddleImage          @"getMiddleImage"
#define GetBigImage             @"getBigImage"

#define kBaseRequestUrl @"http://202.84.17.194/cm/aic/app/v1/"
//#define kBaseRequestUrl @"http://203.192.12.8:8082/cm/aic/app/v1/"
#define wBaseRequestUrl @"http://202.84.17.80/rnews/rnew_reportNoFile.do"
#define picBaseRequestUrl @"http://202.84.17.80/rnews/rnew_report.do"//报道有附件的文件
#define commentRequestUrl @"http://202.84.17.59/cnews/comment_list.do"
#define cBaseRequestUrl @"http://202.84.17.59/cnews/comment_save.do"//评论接口
#define clientID        @"221"

//上传的参数
#define NewsTitle    @"news_title"    //标题
#define NewsDes      @"news_des"      //正文或者附件的描述
#define NewsFilename @"news_filename" //文件存放的路径
#define NewsFiledata @"news_filedata" //multipart/form-data 核心部分，二进制数据
#define ClientMark   @"client_mark"   //app+手机号
#define ClientId     @"client_id"     //新华国际在爆料中的编号
#define ClientDes    @"client_des"    //XhgjIphone

#endif
