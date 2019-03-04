//
//  LHTags.h
//  DoubanMovie
//
//  Created by iDog on 2019/3/4.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LHTags : LHModel
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, copy)   NSString *name;
@property (nonatomic, copy)   NSString *title;
@end

NS_ASSUME_NONNULL_END
