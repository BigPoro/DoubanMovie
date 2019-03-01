//
//  LHTableViewController.h
//  DoubanMovie
//
//  Created by iDog on 2019/2/27.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHViewController.h"
#import <UIScrollView+EmptyDataSet.h>
#import <MJRefresh.h>
#import "LHViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LHTableViewController : LHViewController<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LHViewModel *viewModel;
// 初始化
- (instancetype)initWithStyle:(UITableViewStyle)style;


@end

NS_ASSUME_NONNULL_END
