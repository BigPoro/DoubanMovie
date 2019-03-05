//
//  LHFindMovieViewController.m
//  DoubanMovie
//
//  Created by iDog on 2019/2/22.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHFindMovieViewController.h"
#import <UIScrollView+EmptyDataSet.h>

#import "View/LHFindMovieCell.h"
#import "ViewModel/LHFindMovieViewModel.h"
#import "Model/LHMovieRankingList.h"

@interface LHFindMovieViewController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UISearchBarDelegate,
    DZNEmptyDataSetSource,
    DZNEmptyDataSetDelegate
>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) LHFindMovieViewModel *mainViewModel;
@end

@implementation LHFindMovieViewController

#pragma mark LazyLoad
- (LHFindMovieViewModel *)mainViewModel
{
    if (!_mainViewModel) {
        _mainViewModel = [[LHFindMovieViewModel alloc]init];
    }
    return _mainViewModel;
}

#pragma mark LifeCircle
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self bindViewModel];
}
- (void)bindViewModel
{
    @weakify(self);
    [self.mainViewModel.getAllData.executionSignals.switchToLatest subscribeNext:^(id x) {
    }];
    [self.mainViewModel.getAllData execute:@(1)];
    [[self.mainViewModel.getAllData.executing skip:1] subscribeNext:^(id x) {
        @strongify(self);
        if ([x isEqualToNumber: @(YES)]) {
            [SVProgressHUD showWithStatus:@"正在加载推荐的电影"];
            self.collectionView.hidden = YES;
        }else{
            [SVProgressHUD dismiss];
            self.collectionView.hidden = NO;
        }
    }];
    [self.mainViewModel.refreshSubject subscribeNext:^(id x) {
        @strongify(self);
        [self.collectionView reloadData];
    }];
    [self.mainViewModel.getMovieDeteil.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        DBWebViewController *vc = [[DBWebViewController alloc]init];
        vc.URLString = x ;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.mainViewModel.movieItemSubject subscribeNext:^(id x) {
        @strongify(self);
        self.mainViewModel.movieID = x;
        [self.mainViewModel.getMovieDeteil execute:@(1)];
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
    layout.footerReferenceSize = CGSizeMake(kScreenW, 10);
    
    layout.itemSize = CGSizeMake(90, 160);
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 10, kScreenW, kScreenH - kNavigationBarHeight - kTabbarHeight) collectionViewLayout:layout];

    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.emptyDataSetSource = self;
    _collectionView.emptyDataSetDelegate = self;
    _collectionView.backgroundColor = kWhite_one;
    _collectionView.contentInset = UIEdgeInsetsMake(2 * kMargin, 2 * kMargin, 2 * kMargin, 2 * kMargin);
    [_collectionView registerClass:[LHFindMovieCell class] forCellWithReuseIdentifier:@"MovieCell"];
     [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeaderView"];
    [self.view addSubview:_collectionView];
    
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
#pragma mark UISearchBar Delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"电影/电视剧/影人" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        [searchViewController.navigationController pushViewController:[[UIViewController alloc] init] animated:YES];
        
    }];
    searchViewController.showSearchHistory = NO;

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav  animated:YES completion:nil];
    return NO;
}
#pragma mark UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return self.mainViewModel.weeklyRatingData.count;
            break;
            
        case 1:
            return self.mainViewModel.NewMovieRatingData.count;
            break;
        case 2:
            return self.mainViewModel.USBoxRatingData.count;
            break;
        case 3:
            return self.mainViewModel.top250Data.count;
            break;
        default:
            return 0;
            break;
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeaderView" forIndexPath:indexPath];
    
    for (UIView *subView in headerView.subviews) {
        [subView removeFromSuperview];
    }
    UILabel *sectionLabel = [UILabel new];
    sectionLabel.textColor = kGray_five;
    sectionLabel.font = [UIFont boldSystemFontOfSize:20];
    [headerView addSubview:sectionLabel];
    [sectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView);
        make.left.equalTo(headerView);
    }];
    if (indexPath.section == 0) {
        sectionLabel.text = @"豆瓣口碑榜";
        
    }else if (indexPath.section == 2){
        sectionLabel.text = @"豆瓣新片榜";
        
    }else if (indexPath.section == 3){
        sectionLabel.text = @"北美票房榜";
        
    }else{
        sectionLabel.text = @"豆瓣Top250";
    }
    return headerView;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LHFindMovieCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        LHSimpleMovieRanking *movie = self.mainViewModel.weeklyRatingData[indexPath.row];
        [cell setCellData:movie.subject];
    }else if (indexPath.section == 1){
        [cell setCellData:self.mainViewModel.NewMovieRatingData[indexPath.row]];
    }else if (indexPath.section == 2){
        LHSimpleMovieRanking *movie = self.mainViewModel.USBoxRatingData[indexPath.row];
        [cell setCellData:movie.subject];
    }else if (indexPath.section == 3){
        LHSimpleMovieRanking *movie = self.mainViewModel.top250Data[indexPath.row];
        [cell setCellData:movie.subject];
    }
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LHFindMovieCell *cell = (LHFindMovieCell *)[collectionView cellForItemAtIndexPath:indexPath];
    LHSimpleMovie *movie = [LHSimpleMovie mj_objectWithKeyValues:cell.cellData];
    [self.mainViewModel.movieItemSubject sendNext:movie.identifier];
}
#pragma mark ---- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kScreenW, 50);
}

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
