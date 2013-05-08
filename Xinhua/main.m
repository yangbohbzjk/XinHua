//
//  main.m
//  Xinhua
//
//  Created by zyq on 13-4-28.
//  Copyright (c) 2013年 zyq. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        if (![[NSUserDefaults standardUserDefaults]objectForKey:AppLanguage]) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSLocale preferredLanguages][0] forKey:AppLanguage];
        }
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
