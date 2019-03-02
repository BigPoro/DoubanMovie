//
//  LHFindMovieViewController.m
//  DoubanMovie
//
//  Created by iDog on 2019/2/22.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHFindMovieViewController.h"
#import "View/LHFindMovieCell.h"
#import "ViewModel/LHFindMovieViewModel.h"
@interface LHFindMovieViewController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource
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

    [self setupUI];
    [self bindViewModel];
}
- (void)bindViewModel
{
    RACSignal *signalOne = self.mainViewModel.getWeeklyRating.executionSignals.switchToLatest;
    
    RACSignal *signalTwo = self.mainViewModel.getNewMoviesRating.executionSignals.switchToLatest;
    
    RACSignal *signalThree = self.mainViewModel.getUSBoxRating.executionSignals.switchToLatest;
    
    RACSignal *signalFour = self.mainViewModel.getTop250.executionSignals.switchToLatest;
  

    [self.mainViewModel.getWeeklyRating execute:@(0)];
    [self.mainViewModel.getNewMoviesRating execute:@(0)];
    [self.mainViewModel.getUSBoxRating execute:@(0)];
    [self.mainViewModel.getTop250 execute:@(0)];

//    RACSignal *combineSignal = [[[signalOne combineLatestWith:signalTwo] combineLatestWith:signalThree] combineLatestWith:signalFour];
    
    [self rac_liftSelector:@selector(reloadCollectionViewWithDataOne:dataTwo:dataThree:dataFour:) withSignalsFromArray:@[signalOne, signalTwo, signalThree, signalFour]];

//
//    [combineSignal subscribeNext:^(id x) {
//        debug_NSLog(@"%@",x);
//    }];
}
- (void)reloadCollectionViewWithDataOne:(id)dataOne dataTwo:(id)dataTwo dataThree:(id)dataThree dataFour:(id)dataFour
{
    [self.collectionView reloadData];
}
#pragma mark UI
- (void)setupUI
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 2 * kMargin;
    layout.minimumInteritemSpacing = 2 * kMargin;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.footerReferenceSize = CGSizeMake(kScreenW, 10);
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 10, kScreenW, kScreenH - kNavigationBarHeight - kTabbarHeight) collectionViewLayout:layout];

    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = kWhite_one;
    [_collectionView registerClass:[LHFindMovieCell class] forCellWithReuseIdentifier:@"MovieCell"];
     [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeaderView"];
    [self.view addSubview:_collectionView];
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
            make.left.equalTo(headerView).offset(2 * kMargin);
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
        [cell setCellData:self.mainViewModel.weeklyRatingData[indexPath.row]];
    }else if (indexPath.section == 1){
        [cell setCellData:self.mainViewModel.NewMovieRatingData[indexPath.row]];
    }else if (indexPath.section == 2){
        [cell setCellData:self.mainViewModel.USBoxRatingData[indexPath.row]];
    }else if (indexPath.section == 3){
        [cell setCellData:self.mainViewModel.top250Data[indexPath.row]];
    }
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
}
#pragma mark ---- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kScreenW, 50);
}

@end
