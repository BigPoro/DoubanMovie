//
//  LHViewController.h
//  DoubanMovie
//
//  Created by iDog on 2019/2/22.
//  Copyright © 2019 iDog. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LHViewController : UIViewController
/// 导航栏设置
@property (nonatomic, copy) NSString *navigationTitle;
@property (nonatomic, copy) NSAttributedString *navigationAttrTitle;

- (void)setupUI;

- (void)bindViewModel;

@end

NS_ASSUME_NONNULL_END
