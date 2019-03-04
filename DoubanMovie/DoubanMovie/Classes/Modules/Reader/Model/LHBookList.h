//
//  LHBookList.h
//  DoubanMovie
//
//  Created by iDog on 2019/3/4.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHModel.h"
#import "LHSimpleBook.h"
NS_ASSUME_NONNULL_BEGIN

@interface LHBookList : LHModel
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger start;
@property (nonatomic, assign) NSInteger total;

@property (nonatomic, strong) NSArray <LHSimpleBook *>* books;

@end

NS_ASSUME_NONNULL_END
