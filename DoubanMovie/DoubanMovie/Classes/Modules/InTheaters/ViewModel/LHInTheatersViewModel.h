//
//  LHInTheatersViewModel.h
//  DoubanMovie
//
//  Created by iDog on 2019/2/27.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LHInTheatersViewModel : LHViewModel


@property (nonatomic, strong, readonly) RACCommand *getInTheatersMovies;
@property (nonatomic, strong, readonly) RACCommand *getComingSoonMovies;
@property (nonatomic, strong, readonly) RACCommand *getNextComingSoonMovies;
@property (nonatomic, strong, readonly) RACCommand *getMovieDeteil;

@property (nonatomic, strong, readonly) RACSubject *refreshEndSubject;
@property (nonatomic, strong, readonly) RACSubject *MovieItemSubject;

@property (nonatomic, strong, readonly) NSMutableArray *inTheatersData;
@property (nonatomic, strong, readonly) NSMutableArray *comingSoonData;

@property (nonatomic, copy) NSString *movieID;
@end

NS_ASSUME_NONNULL_END
