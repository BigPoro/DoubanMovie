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
    
    /// 设置按钮的排他性
    [[UIButton appearance] setExclusiveTouch:YES];
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
@end
