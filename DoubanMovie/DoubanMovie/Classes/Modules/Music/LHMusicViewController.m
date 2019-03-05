//
//  LHMusicViewController.m
//  DoubanMovie
//
//  Created by iDog on 2019/2/22.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHMusicViewController.h"
#import <UIScrollView+EmptyDataSet.h>
#import "Model/LHMusicList.h"
#import "ViewModel/LHMusicViewModel.h"
#import "View/LHMusicCell.h"
@interface LHMusicViewController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UISearchBarDelegate,
    DZNEmptyDataSetSource,
    DZNEmptyDataSetDelegate
>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) LHMusicViewModel *mainViewModel;
@end

@implementation LHMusicViewController

#pragma mark LazyLoad
- (LHMusicViewModel *)mainViewModel
{
    if (!_mainViewModel) {
        _mainViewModel = [[LHMusicViewModel alloc]init];
    }
    return _mainViewModel;
}

#pragma mark LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindViewModel];
}
- (void)bindViewModel
{
    @weakify(self);
    
    [self.mainViewModel.getSearchResult.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        [self.collectionView reloadData];
    }];
    [self.mainViewModel.getNextSearchResult.executionSignals.switchToLatest subscribeNext:^(id x) {
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView reloadData];
    }];
    
    // 控制刷新尾
    [self.mainViewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self);
        LHRefreshDataStatus status = [x integerValue];
        switch (status) {
            case LHFooterRefresh_HasMoreData:{
                
                self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    [self.mainViewModel.getNextSearchResult execute:nil];
                }];
                break;
            }
            case LHFooterRefresh_HasNoMoreData:
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                break;
        }
    }];
    
    [self.mainViewModel.getSearchResult execute:@(1)];
    [self.mainViewModel.getMusicDetail subscribeNext:^(id x) {
        @strongify(self);
        DBWebViewController *vc = [[DBWebViewController alloc]init];
        vc.URLString = x;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}
#pragma mark UI
- (void)setupUI
{
    [super setupUI];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 2 * kMargin;
    layout.minimumInteritemSpacing = 2 * kMargin;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    layout.itemSize = CGSizeMake(90, 120);
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 10, kScreenW, kScreenH - kNavigationBarHeight - kTabbarHeight) collectionViewLayout:layout];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.emptyDataSetSource = self;
    _collectionView.emptyDataSetDelegate = self;
    _collectionView.backgroundColor = kWhite_one;
    _collectionView.contentInset = UIEdgeInsetsMake(2 * kMargin, 2 * kMargin, 2 * kMargin, 2 * kMargin);
    [_collectionView registerClass:[LHMusicCell class] forCellWithReuseIdentifier:@"MusicCell"];
    [self.view addSubview:_collectionView];
    
    //MARK: 搜索栏
    UIView *titleView = [UIView new];
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.placeholder = @"歌名/曲风/歌手";
    [titleView addSubview:searchBar];
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(titleView);
        make.size.mas_equalTo(CGSizeMake(kScreenW - 50, 38));
    }];
    searchBar.delegate = self;
    self.navigationItem.titleView = titleView;
}
#pragma mark UISearchBar Delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"歌名/曲风/歌手" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        self.mainViewModel.keywords = searchText;
        [self.mainViewModel.getSearchResult execute:@(1)];
        [searchViewController.navigationController dismissViewControllerAnimated:YES completion:nil];
        searchBar.placeholder = searchText;
    }];
    searchViewController.showSearchHistory = NO;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav  animated:YES completion:nil];
    return NO;
}
#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.mainViewModel.dataSource.count;

}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LHMusicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MusicCell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.cellData = self.mainViewModel.dataSource[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LHMusicCell *cell = (LHMusicCell *)[collectionView cellForItemAtIndexPath:indexPath];
    LHSimpleMusic *music = [LHSimpleMusic mj_objectWithKeyValues:cell.cellData];
    [self.mainViewModel.getMusicDetail sendNext:music.alt];
}
#pragma mark ---- UICollectionViewDelegateFlowLayout
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return IMAGE_NAME(@"empty_124x136_");
}
// 返回详情文字
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无数据";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName: [UIColor lightGrayColor], NSParagraphStyleAttributeName: paragraph};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}


@end
