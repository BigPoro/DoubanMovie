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


@property (nonatomic, strong, readonly) RACCommand *getInTheatersMoives;
@property (nonatomic, strong, readonly) RACCommand *getComingSoonMoives;
@property (nonatomic, strong, readonly) RACCommand *getNextComingSoonMoives;
@property (nonatomic, strong, readonly) RACSubject *refreshEndSubject;

@property (nonatomic, strong, readonly) NSMutableArray *inTheatersData;
@property (nonatomic, strong, readonly) NSMutableArray *comingSoonData;

@end

NS_ASSUME_NONNULL_END
