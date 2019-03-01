//
//  LHView.h
//  DoubanMovie
//
//  Created by iDog on 2019/2/27.
//  Copyright © 2019 iDog. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LHView : UIView

- (instancetype)initWithViewModel:(id)viewModel;

- (void)setupUI;

- (void)bindViewModel;

@end

NS_ASSUME_NONNULL_END
