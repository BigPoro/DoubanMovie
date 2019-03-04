//
//  LHReaderViewController.m
//  DoubanMovie
//
//  Created by iDog on 2019/2/22.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHReaderViewController.h"
#import "LHBooksViewModel.h"
#import "HXTagsView.h"
#import "View/LHBookCell.h"
#import "LHSimpleBook.h"
@interface LHReaderViewController ()
@property (nonatomic, strong) LHBooksViewModel *mainViewModel;
@property (nonatomic, strong) NSArray <NSString *> *keywordsArr;

@end

@implementation LHReaderViewController

- (LHBooksViewModel *)mainViewModel
{
    if (!_mainViewModel) {
        _mainViewModel = [[LHBooksViewModel alloc]init];
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
    self.mainViewModel.keywords = self.keywordsArr.firstObject;
    @weakify(self);
    [self.mainViewModel.getSearchResult.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    [self.mainViewModel.getSearchResult execute:@(1)];
    [self.mainViewModel.getBookDetail subscribeNext:^(id x) {
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
    self.keywordsArr = @[@"小说",@"文学",@"人文社科",@"经济管理",@"科技科普",@"计算机与互联网",@"成功励志",@"生活",@"少儿",@"艺术设计",@"漫画绘本",@"教育考试",@"杂志"];
    self.navigationTitle = @"豆瓣读书";
    self.tableView.frame = CGRectMake(0, 170, kScreenW, kScreenH - kNavigationBarHeight - kTabbarHeight);
    
    HXTagsView *tagsView = [[HXTagsView alloc] initWithFrame:CGRectMake(0, 10, kScreenW, 150)];
    [self.view addSubview:tagsView];
    
    tagsView.hx_backgroundColor = kGray_one;
    tagsView.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    tagsView.tagAttribute.normalBorderColor = kGray_four;
    tagsView.tagAttribute.normalBackgroundColor = kWhite_one;
    tagsView.tagAttribute.selectedBackgroundColor = [UIColor orangeColor];
    tagsView.tagAttribute.selectedTextColor = kWhite_one;
    tagsView.tagAttribute.normalTextColor = kGray_four;
    kWeakSelf;
    tagsView.completion = ^(NSArray *selectTags,NSInteger currentIndex) {
        weakSelf.mainViewModel.keywords = weakSelf.keywordsArr[currentIndex];
        [weakSelf.mainViewModel.getSearchResult execute:@(1)];
    };
    tagsView.tags = self.keywordsArr;
    
    [tagsView reloadData];

}
#pragma mark UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainViewModel.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LHBookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookCell"];
    if (!cell) {
        cell = [[LHBookCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BookCell"];
    }
    [cell setCellData:self.mainViewModel.dataSource[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LHBookCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    LHSimpleBook *book = [LHSimpleBook mj_objectWithKeyValues:cell.cellData];
    [self.mainViewModel.getBookDetail sendNext:book.alt];
}
@end
