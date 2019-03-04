//
//  LHInTheatersCell.h
//  DoubanMovie
//
//  Created by iDog on 2019/2/28.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface LHInTheatersCell : LHTableViewCell

@property (nonatomic, copy) void(^buyTicketsBlock)(NSString *identifier);

@end

NS_ASSUME_NONNULL_END
