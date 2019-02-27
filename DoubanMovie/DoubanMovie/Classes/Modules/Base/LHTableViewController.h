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

NS_ASSUME_NONNULL_BEGIN

@interface LHTableViewController : LHViewController<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
// 初始化
- (instancetype)initWithStyle:(UITableViewStyle)style;
- (instancetype)init;

// 需要重写的网络加载方法
- (void)loadNewData;
- (void)loadMoreData;

// 添加拉动刷新
- (void)setupRefreshHeader;
- (void)setupRefreshFooter;
- (void)setupRefresh; //以上两者同时设置

@end

NS_ASSUME_NONNULL_END
