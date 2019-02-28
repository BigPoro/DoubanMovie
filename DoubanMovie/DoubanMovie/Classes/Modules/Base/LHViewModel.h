//
//  LHViewModel.h
//  DoubanMovie
//
//  Created by iDog on 2019/2/27.
//  Copyright © 2019 iDog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>
#import "LHNetwork.h"
typedef NS_ENUM(NSInteger,LHRefreshDataStatus){
    LHHeaderRefresh_HasMoreData, ///下拉还有更多数据
    LHHeaderRefresh_HasNoMoreData, ///下拉没有更多数据
    LHFooterRefresh_HasMoreData, ///上拉还有更多数据
    LHFooterRefresh_HasNoMoreData, ///上拉没有更多数据
    LHRefreshError, ///刷新出错
    LHRefreshUI ///仅仅刷新UI布局
};
NS_ASSUME_NONNULL_BEGIN

@interface LHViewModel : NSObject

@property (nonatomic, strong, nullable) NSMutableArray *dataSource;

@property (nonatomic, strong, readonly, nullable) RACSubject *dataSignal;

@property (nonatomic, strong, readonly, nullable) RACSubject *errorSignal;
@property (nonatomic, strong, readonly, nullable) RACSubject *successSignal;

/**
 取消获取数据
 */
- (void)cancelData;

/**
 准备数据
 
 @param dataModel json
 */
-(void)handDataSource:(id )dataModel;

@end

NS_ASSUME_NONNULL_END
