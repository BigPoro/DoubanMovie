//
//  LHBooksViewModel.h
//  DoubanMovie
//
//  Created by iDog on 2019/3/4.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LHBooksViewModel : LHViewModel
@property (nonatomic, copy) NSString *keywords; // 搜索的关键字

@property (nonatomic, strong, readonly) RACCommand *getSearchResult;
@property (nonatomic, strong, readonly) RACCommand *getNextSearchResult;
@property (nonatomic, strong, readonly) RACSubject *refreshEndSubject;

@property (nonatomic, strong, readonly) RACSubject *getBookDetail;
@end

NS_ASSUME_NONNULL_END
