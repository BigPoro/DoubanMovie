//
//  NSObject+ViewController.m
//  DoubanMovie
//
//  Created by iDog on 2019/2/28.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "NSObject+ViewController.h"

@implementation NSObject (ViewController)

- (UIViewController *)getAppRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

- (UIViewController *)getAppPresentingViewController
{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController)
    {
        result = result.presentedViewController;
    }
    
    // 处理tabbar导致的根视图获取不准确
    if ([result isKindOfClass:[UITabBarController class]])
    {
        result = [(UITabBarController *)result selectedViewController];
    }
    
    if ([result isKindOfClass:[UINavigationController class]])
    {
        result = [(UINavigationController *)result topViewController];
    }
    
    return result;
}

@end
