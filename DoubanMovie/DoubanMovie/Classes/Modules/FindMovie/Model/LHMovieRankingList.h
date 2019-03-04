//
//  LHMovieRankingList.h
//  DoubanMovie
//
//  Created by iDog on 2019/3/4.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHModel.h"
#import "LHSimpleMovie.h"
@class LHSimpleMovieRanking;
NS_ASSUME_NONNULL_BEGIN

@interface LHMovieRankingList : LHModel
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray<LHSimpleMovieRanking *> *subjects;

@end

NS_ASSUME_NONNULL_END

@interface LHSimpleMovieRanking : LHModel
@property (nonatomic, assign) NSInteger box;
@property (nonatomic, assign) NSInteger isnNew;
@property (nonatomic, assign) NSInteger rank;
@property (nonatomic, assign) NSInteger delta;
@property (nonatomic, strong) LHSimpleMovie *subject;

@end
