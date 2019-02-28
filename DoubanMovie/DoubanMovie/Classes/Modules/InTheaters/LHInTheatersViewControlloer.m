//
//  LHInTheatersViewControlloer.m
//  DoubanMovie
//
//  Created by iDog on 2019/2/22.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHInTheatersViewControlloer.h"
#import "LHInTheatersViewModel.h"
#import "LHInTheatersCell.h"
@interface LHInTheatersViewControlloer ()
<
    UITableViewDelegate,
    UITableViewDataSource
>
@property (nonatomic, strong) LHInTheatersViewModel *mainViewModel;

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
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [SVProgressHUD show];
    [SVProgressHUD dismiss];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self bindViewModel];
}
- (void)bindViewModel
{
    @weakify(self);
    
    [self.mainViewModel.getInTheatersMoives.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        [self.inTheatersTableView reloadData];
        
    }];
    [self.mainViewModel.getComingSoonMoives.executionSignals.switchToLatest subscribeNext:^(id x) {
        debug_NSLog(@"%@",x);
    }];
    [self.mainViewModel.refreshEndSubject subscribeNext:^(id x) {
        
    }];
    [self.mainViewModel.getInTheatersMoives execute:@(1)];
//    [self.mainViewModel.getComingSoonMoives execute:@(1)];
}
//Mark: -- UI
- (void)setupUI
{
    UITableView *leftView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:leftView];
    _inTheatersTableView = leftView;
    _inTheatersTableView.delegate = self;
    _inTheatersTableView.dataSource = self;
}
//MARK: TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mainViewModel.inTheatersData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self tableView:tableView cellForRowAtIndexPath:indexPath].contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LHInTheatersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InTheatersCell"];
    if (!cell) {
        cell = [[LHInTheatersCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InTheatersCell"];
    }
    [cell setCellData:self.mainViewModel.inTheatersData[indexPath.row]];
    return cell;
}

@end
