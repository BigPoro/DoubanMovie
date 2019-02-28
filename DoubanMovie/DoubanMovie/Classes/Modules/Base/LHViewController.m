//
//  LHViewController.m
//  DoubanMovie
//
//  Created by iDog on 2019/2/22.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHViewController.h"

@interface LHViewController ()

@end

@implementation LHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kWhite_one;
    /// 设置按钮的排他性
    [[UIButton appearance] setExclusiveTouch:YES];
    
    [self adapterTheScrollViewAndTableView];
    
    [self setupUI];
}
- (void)adapterTheScrollViewAndTableView
{
    //解决iOS11，仅实现heightForHeaderInSection，没有实现viewForHeaderInSection方法时,section间距大的问题
    [UITableView appearance].estimatedRowHeight = 0;
    [UITableView appearance].estimatedSectionHeaderHeight = 0;
    [UITableView appearance].estimatedSectionFooterHeight = 0;
    //iOS11 解决SafeArea的问题，同时能解决pop时上级页面scrollView抖动的问题
    if (@available(iOS 11, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}
// MARK: -- 导航栏设置
- (void)setNavigationTitle:(NSString *)navigationTitle
{
    _navigationTitle = navigationTitle;
    if (navigationTitle.length) {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 100, 44)];
        title.font = [UIFont systemFontOfSize:18];
        title.textColor = [UIColor blackColor];
        title.backgroundColor = [UIColor clearColor];
        title.textAlignment = NSTextAlignmentCenter;
        title.text = navigationTitle;
        
        self.navigationItem.titleView = title;
    }
}

- (void)setNavigationAttrTitle:(NSAttributedString *)navigationAttrTitle
{
    _navigationAttrTitle = navigationAttrTitle;
    if (_navigationAttrTitle.length) {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 100, 44)];
        title.font = [UIFont systemFontOfSize:18];
        title.backgroundColor = [UIColor clearColor];
        title.textAlignment = NSTextAlignmentCenter;
        title.attributedText = navigationAttrTitle;
        self.navigationItem.titleView = title;
    }
}

- (void)bindViewModel
{
    
}
- (void)setupUI
{
    
}

@end
