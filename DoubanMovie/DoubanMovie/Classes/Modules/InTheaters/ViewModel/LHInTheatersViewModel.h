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

@property(nonatomic, strong, readonly) RACCommand *getInTheatersMoives;
@property(nonatomic, strong, readonly) RACCommand *getComingSoonMoives;

@end

NS_ASSUME_NONNULL_END
