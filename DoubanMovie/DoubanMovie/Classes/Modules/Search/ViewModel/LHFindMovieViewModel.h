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

/// 口碑榜
@property (nonatomic, strong, readonly) RACCommand *getWeeklyRating;
/// 北美票房榜
@property (nonatomic, strong, readonly) RACCommand *getUSBoxRating;
/// 新片榜
@property (nonatomic, strong, readonly) RACCommand *getNewMoviesRating;
/// Top250
@property (nonatomic, strong, readonly) RACCommand *getTop250;
/// 点击了Cell
@property (nonatomic, strong, readonly) RACSubject *MovieItemSubject;

@property (nonatomic, strong, readonly) NSMutableArray *weeklyRatingData;
@property (nonatomic, strong, readonly) NSMutableArray *NewMovieRatingData;
@property (nonatomic, strong, readonly) NSMutableArray *USBoxRatingData;
@property (nonatomic, strong, readonly) NSMutableArray *top250Data;

@property (nonatomic, copy) NSString *movieID;

@end

NS_ASSUME_NONNULL_END
