//
//  LHViewModel.m
//  DoubanMovie
//
//  Created by iDog on 2019/2/27.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHViewModel.h"

@interface LHViewModel ()

@end

@implementation LHViewModel

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (RACSubject *)successSignal {
    if (!_successSignal) {
        _successSignal = [RACSubject subject];
    }
    return _successSignal;
}

- (RACSubject *)dataSignal {
    if (!_dataSignal) {
        _dataSignal = [RACSubject subject];
    }
    return _dataSignal;
}

- (RACSubject *)errorSignal {
    if (!_errorSignal) {
        _errorSignal = [RACSubject subject];
    }
    return _errorSignal;
}

/**
 取消获取数据
 */
- (void)cancelData
{
    
}

/**
 准备数据
 
 @param dataModel json
 */
-(void)handDataSource:(id )dataModel
{
    
}

@end
