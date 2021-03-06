//
//  HXTagAttribute.h
//  HXTagsView https://github.com/huangxuan518/HXTagsView
//  博客地址 http://blog.libuqing.com/
//  Created by Love on 16/6/30.
//  Copyright © 2016年 IT小子. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HXTagAttribute : NSObject

@property (nonatomic,assign) CGFloat borderWidth;// 标签边框宽度
@property (nonatomic,strong) UIColor *normalBorderColor;// 默认标签边框颜色
@property (nonatomic,strong) UIColor *selectedBorderColor;// 选中标签边框颜色
@property (nonatomic,assign) CGFloat cornerRadius;//标签圆角大小
@property (nonatomic,strong) UIColor *normalBackgroundColor;// 标签默认背景颜色
@property (nonatomic,strong) UIColor *selectedBackgroundColor;// 标签选中背景颜色
@property (nonatomic,assign) CGFloat titleSize;// 标签字体大小
@property (nonatomic,strong) UIColor *normalTextColor;// 标签默认字体颜色
@property (nonatomic,strong) UIColor *selectedTextColor;// 标签选中字体颜色

@property (nonatomic,strong) UIColor *keyColor;// 搜索关键词颜色
@property (nonatomic,assign) CGFloat tagSpace;// 标签内部左右间距(标题距离边框2边的距离和)

@property (nonatomic,assign) CGFloat itemWidth;// 固定的标签宽度
@end
