//
//  LHViewModel.h
//  DoubanMovie
//
//  Created by iDog on 2019/2/27.
//  Copyright © 2019 iDog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHNetwork.h"
typedef NS_ENUM(NSInteger,LHRefreshDataStatus){
    LHFooterRefresh_HasMoreData = 1, ///上拉还有更多数据
    LHFooterRefresh_HasNoMoreData = 2 ///上拉没有更多数据
};
NS_ASSUME_NONNULL_BEGIN

@interface LHViewModel : NSObject

@property (nonatomic, strong, nullable) NSMutableArray *dataSource;

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
