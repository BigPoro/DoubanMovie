//
//  LHReaderPlusBtn.m
//  DoubanMovie
//
//  Created by iDog on 2019/2/22.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHReaderPlusBtn.h"
#import "LHTabBarControllerConfig.h"
#import "LHReaderViewController.h"
#import "LHNavigationController.h"
@interface LHReaderPlusBtn ()

@end
@implementation LHReaderPlusBtn

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}
#pragma mark - CYLPlusButtonSubclassing Methods
/*
 Create a custom UIButton with title and add it to the center of our tab bar
 */
+ (id)plusButton
{
    LHReaderPlusBtn *button = [[LHReaderPlusBtn alloc] init];
    UIImage *normalButtonImage = [UIImage imageNamed:@"douban_reader_logo"];
    UIImage *hlightButtonImage = [UIImage imageNamed:@"douban_reader_logo_seleted"];

    [button setBackgroundImage:normalButtonImage forState:UIControlStateNormal];
    [button setBackgroundImage:hlightButtonImage forState:UIControlStateSelected];
    button.imageEdgeInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    button.titleLabel.font = [UIFont systemFontOfSize:9.5];
    
    [button sizeToFit]; // or set frame in this way `button.frame = CGRectMake(0.0, 0.0, 250, 100);`
//    button.frame = CGRectMake(0.0, 0.0, 40, 40);
    
    // if you use `+plusChildViewController` , do not addTarget to plusButton.
    [button addTarget:button action:@selector(clickPublish) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
#pragma mark - Event Response

- (void)clickPublish
{
    CYLTabBarController *tabBarController = [self cyl_tabBarController];
    UIViewController *viewController = tabBarController.selectedViewController;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"自定义操作" message:@"自定义" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"first" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"second" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"cancle" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [viewController presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - CYLPlusButtonSubclassing
//  重写此方法 自定义的按钮操作就无效了
+ (UIViewController *)plusChildViewController
{
    LHReaderViewController *plusChildViewController = [[LHReaderViewController alloc] init];
    UIViewController *plusChildNavigationController = [[LHNavigationController alloc]
                                                       initWithRootViewController:plusChildViewController];
    return plusChildNavigationController;
}
// 所处的位置
+ (NSUInteger)indexOfPlusButtonInTabBar
{
    return 2;
}
// 是否选中PlusBtn
+ (BOOL)shouldSelectPlusChildViewController
{
    BOOL isSelected = CYLExternPlusButton.selected;
    if (isSelected) {
        
    } else {
        
    }
    return YES;
}

+ (CGFloat)multiplierOfTabBarHeight:(CGFloat)tabBarHeight
{
    return  0.3;
}

+ (CGFloat)constantOfPlusButtonCenterYOffsetForTabBarHeight:(CGFloat)tabBarHeight
{
    return (CYL_IS_IPHONE_X ? - 6 : 4);
}
@end
