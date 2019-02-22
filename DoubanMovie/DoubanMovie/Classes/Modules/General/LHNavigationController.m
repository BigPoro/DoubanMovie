//
//  LHNavigationController.m
//  DoubanMovie
//
//  Created by iDog on 2019/2/21.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHNavigationController.h"
@interface LHNavigationController ()

@end

@implementation LHNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBar.frame = CGRectMake(0, 0,kScreenW, kNavigationBarHeight);
    
    self.navigationBar.translucent = NO;
    self.navigationBar.shadowImage = [UIImage new];
    // 设置导航控制器背景图片
    self.navigationBar.tintColor = [UIColor blackColor];
    [self.navigationBar setBackgroundImage:[UIImage jk_imageWithColor:kWhite_one] forBarMetrics:UIBarMetricsDefault];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) { // 如果viewController不是最早push进来的子控制器
        // 左上角
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:IMAGE_NAME(@"ic_arrow_back_subject_24x24_") forState:UIControlStateNormal];
        [backButton sizeToFit];
        // 这句代码放在sizeToFit后面
        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        [backButton addTarget:self action:@selector(goBackBtnAction) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)goBackBtnAction
{
    [self popViewControllerAnimated:YES];
}
@end
