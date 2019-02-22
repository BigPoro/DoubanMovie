//
//  StaticSettings.h
//  DoubanMovie
//
//  Created by iDog on 2019/2/21.
//  Copyright © 2019 iDog. All rights reserved.
//

#ifndef StaticSettings_h
#define StaticSettings_h


/**
 一些常量
 @return return value description
 */

#define kUserDefaults [NSUserDefaults standardUserDefaults]

#define kVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] //外部版本号

#define kBuild [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] //内部版本号

#define kUDID [[UIDevice currentDevice].identifierForVendor UUIDString]  //iPhone的UDID

#define kUniqueUUID [[NSUUID UUID].UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@""]  //UUID生成的方法(去掉-的)

#define kScreenH  [[UIScreen mainScreen] bounds].size.height
#define kScreenW  [[UIScreen mainScreen] bounds].size.width
#define KScale kScreenH/667.0
#define kKeyWindow  [UIApplication sharedApplication].keyWindow
#define kMargin 8

// 刘海屏 宏定义
#define iPhoneX ((kScreenH == 812.f || kScreenH == 896.f)? YES : NO)
// 适配刘海屏状态栏高度
#define kStatusBarHeight (iPhoneX ? 44.f : 20.f)
// 适配iPhone X 导航栏高度
#define kNavigationBarHeight (iPhoneX ? 88.f : 64.f)

// 适配iPhone X Tabbar距离底部的距离
#define kTabbarSafeBottomMargin (iPhoneX ? 34.f : 0.f)
// 适配iPhone X Tabbar高度
#define kTabbarHeight (iPhoneX ? (49.f + 34.f) : 49.f)


#define kWeakSelf __weak __typeof__(self) weakSelf = self;

/**
 关于颜色的方法和项目中的固定配色
 
 @param r red
 @param g green
 @param b blue
 @param a alpha
 @return color
 */

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/1]
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#define kGray_one      RGBCOLOR(147,147,147)
#define kGgray_tow     RGBCOLOR(49,49,49)

#define kWhite_one      RGBCOLOR(255,255,255)
#define kWhite_two      RGBCOLOR(251,251,251)
/**
 宏定义的固定方法
 
 @param NAME NAME为一个静态常量的String ,否则会报错
 @return UIImage对象
 注意:该方法为静态方法,NAME为一个静态常量的String,否则语法报错
 */
#define IMAGE_NAME(NAME) [UIImage imageNamed:NAME]

#ifdef DEBUG

#define debug_NSLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define debug_NSLog(format, ...)
#endif

#endif /* StaticSettings_h */
