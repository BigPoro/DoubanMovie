//
//  LHInTheatersViewControlloer.m
//  DoubanMovie
//
//  Created by iDog on 2019/2/22.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHInTheatersViewControlloer.h"
#import "LHInTheatersViewModel.h"
@interface LHInTheatersViewControlloer ()
@property (nonatomic, strong) LHInTheatersViewModel *mainViewModel;
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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [SVProgressHUD show];
    [SVProgressHUD dismiss];
    [self bindViewModel];
}
- (void)bindViewModel
{
    [self.mainViewModel.getInTheatersMoives execute:nil];
    [self.mainViewModel.dataSignal subscribeNext:^(id x) {
        debug_NSLog(@"%@",x);
    }];
}
@end
