//
//  LHRating.h
//  DoubanMovie
//
//  Created by iDog on 2019/2/27.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LHRating : LHModel
@property (nonatomic, assign) NSInteger max;
@property (nonatomic, copy)   NSString *average;
@property (nonatomic, assign) NSInteger numRaters;
@property (nonatomic, assign) NSInteger min;
@end

NS_ASSUME_NONNULL_END
