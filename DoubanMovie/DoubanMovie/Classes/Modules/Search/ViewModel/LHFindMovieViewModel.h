//
//  LHFindMovieViewModel.h
//  DoubanMovie
//
//  Created by iDog on 2019/3/2.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LHFindMovieViewModel : LHViewModel

@property (nonatomic, strong, readonly) RACCommand *getAllData;
@property (nonatomic, strong, readonly) RACCommand *getMovieDeteil;

/// 点击了Cell
@property (nonatomic, strong, readonly) RACSubject *movieItemSubject;
/// 刷新
@property (nonatomic, strong, readonly) RACSubject *refreshSubject;

@property (nonatomic, strong, readonly) NSMutableArray *weeklyRatingData;
@property (nonatomic, strong, readonly) NSMutableArray *NewMovieRatingData;
@property (nonatomic, strong, readonly) NSMutableArray *USBoxRatingData;
@property (nonatomic, strong, readonly) NSMutableArray *top250Data;

@property (nonatomic, copy) NSString *movieID;

@end

NS_ASSUME_NONNULL_END
