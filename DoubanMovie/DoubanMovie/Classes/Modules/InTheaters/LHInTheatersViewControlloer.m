//
//  LHInTheatersViewControlloer.m
//  DoubanMovie
//
//  Created by iDog on 2019/2/22.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHInTheatersViewControlloer.h"
#import "DBWebViewController.h"
#import "LHInTheatersViewModel.h"
#import "LHInTheatersCell.h"
#import "View/LHComingSoonCell.h"
#import "View/HMSegmentedControl.h"
#import <PYSearch.h>
#import "LHSimpleMovie.h"

@interface LHInTheatersViewControlloer ()
<
    UITableViewDelegate,
    UITableViewDataSource,
    UISearchBarDelegate
>
@property (nonatomic, strong) LHInTheatersViewModel *mainViewModel;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, weak) UITableView *inTheatersTableView;
@property (nonatomic, weak) UITableView *comingSoonTableView;

@end

@implementation LHInTheatersViewControlloer

- (LHInTheatersViewModel *)mainViewModel
{
    if (!_mainViewModel) {
        _mainViewModel = [LHInTheatersViewModel new];
    }
    return _mainViewModel;
}
//MARK: LifeCircle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self bindViewModel];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)bindViewModel
{
    @weakify(self);
    
    [self.mainViewModel.getInTheatersMovies.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        [self.inTheatersTableView reloadData];
        
    }] ;
    [self.mainViewModel.getComingSoonMovies.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        [self.comingSoonTableView.mj_header endRefreshing];
        [self.comingSoonTableView reloadData];
    }];
    [self.mainViewModel.getNextComingSoonMovies.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        [self.comingSoonTableView.mj_footer endRefreshing];
        [self.comingSoonTableView reloadData];
    }];
    [self.mainViewModel.getMovieDeteil.executionSignals.switchToLatest subscribeNext:^(id x) {
       @strongify(self);
        DBWebViewController *vc = [[DBWebViewController alloc]init];
        vc.URLString = x ;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.mainViewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self);
        LHRefreshDataStatus status = [x integerValue];
        switch (status) {
            case LHFooterRefresh_HasMoreData:{
            
                self.comingSoonTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    [self.mainViewModel.getNextComingSoonMovies execute:nil];
                }];
                break;
            }
            case LHFooterRefresh_HasNoMoreData:
                [self.comingSoonTableView.mj_footer endRefreshingWithNoMoreData];
                break;
        }
    }];
    [self.mainViewModel.getInTheatersMovies execute:@(1)];
    [self.mainViewModel.getComingSoonMovies execute:@(1)];

    [self.mainViewModel.MovieItemSubject subscribeNext:^(id x) {
        @strongify(self);
        self.mainViewModel.movieID = x;
        [self.mainViewModel.getMovieDeteil execute:@(0)];
    }];
}
//MARK: -- UI
- (void)setupUI
{
    CGFloat maxHeight = kScreenH - kNavigationBarHeight - kTabbarHeight - 58;
    UIScrollView *containerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 58, kScreenW, maxHeight)];
    containerView.contentSize = CGSizeMake(kScreenW, maxHeight);
    [self.view addSubview:containerView];
    
    UITableView *leftView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, maxHeight) style:UITableViewStylePlain];
    [containerView addSubview:leftView];
    _inTheatersTableView = leftView;
    _inTheatersTableView.delegate = self;
    _inTheatersTableView.dataSource = self;
    _inTheatersTableView.tableFooterView = [UIView new];
    UITableView *rightView = [[UITableView alloc]initWithFrame:CGRectMake(kScreenW, 0, kScreenW, maxHeight) style:UITableViewStylePlain];
    [containerView addSubview:rightView];
    _comingSoonTableView = rightView;
    _comingSoonTableView.delegate = self;
    _comingSoonTableView.dataSource = self;
    _comingSoonTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_mainViewModel.getComingSoonMovies execute:nil];
    }];
    _comingSoonTableView.tableFooterView = [UIView new];

    //MARK: SegmentedControl
    _segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 48)];
    _segmentedControl.sectionTitles = @[@"正在热映", @"即将上映"];
    _segmentedControl.selectedSegmentIndex = 0;
    _segmentedControl.backgroundColor = kWhite_one;
    _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : kGray_three, NSFontAttributeName : [UIFont boldSystemFontOfSize:16]};
    _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : kGray_five, NSFontAttributeName : [UIFont boldSystemFontOfSize:16]};
    _segmentedControl.selectionIndicatorColor = kGray_five;
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentedControl.type = HMSegmentedControlTypeText;
    _segmentedControl.selectionIndicatorHeight = 2;
    [[_segmentedControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        HMSegmentedControl *segmentedControl = x;
        containerView.contentOffset = CGPointMake(segmentedControl.selectedSegmentIndex * kScreenW, 0);
    }];
    _segmentedControl.userDraggable = YES;
    _segmentedControl.verticalDividerEnabled = NO;
    [self.view addSubview:_segmentedControl];
    //MARK: 搜索栏
    UIView *titleView = [UIView new];
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.placeholder = @"电影/电视剧/影人";
    [titleView addSubview:searchBar];
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(titleView);
        make.size.mas_equalTo(CGSizeMake(kScreenW - 50, 38));
    }];
    searchBar.delegate = self;
    self.navigationItem.titleView = titleView;
    
}
//MARK: UISearchBar Delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{

    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"电影/电视剧/影人" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        [searchViewController.navigationController pushViewController:[[UIViewController alloc] init] animated:YES];
        
    }];
    // 3. present the searchViewController
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav  animated:YES completion:nil];
    return NO;
}
//MARK: TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.inTheatersTableView) {
        return self.mainViewModel.inTheatersData.count;
    }
    return self.mainViewModel.comingSoonData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self tableView:tableView cellForRowAtIndexPath:indexPath].contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.inTheatersTableView) {
        LHInTheatersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InTheatersCell"];
        if (!cell) {
            cell = [[LHInTheatersCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InTheatersCell"];
        }
        [cell setCellData:self.mainViewModel.inTheatersData[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        LHComingSoonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ComingSoonCell"];
        if (!cell) {
            cell = [[LHComingSoonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ComingSoonCell"];
        }
        [cell setCellData:self.mainViewModel.comingSoonData[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LHTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    LHSimpleMovie *movie = [LHSimpleMovie mj_objectWithKeyValues:cell.cellData];
    [self.mainViewModel.MovieItemSubject sendNext:movie.identifier];
}

@end
