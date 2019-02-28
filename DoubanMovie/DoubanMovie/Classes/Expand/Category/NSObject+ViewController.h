//
//  NSObject+ViewController.h
//  DoubanMovie
//
//  Created by iDog on 2019/2/28.
//  Copyright © 2019 iDog. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ViewController)
/// 获取当前App的根视图控制器
- (UIViewController *)getAppRootViewController;
/// 获取当前显示的视图
- (UIViewController *)getAppPresentingViewController;
@end

NS_ASSUME_NONNULL_END
