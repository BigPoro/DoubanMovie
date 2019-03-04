//
//  LHBooksViewModel.m
//  DoubanMovie
//
//  Created by iDog on 2019/3/4.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHBooksViewModel.h"
#import "LHBookList.h"
@interface LHBooksViewModel ()
@property (nonatomic, strong, readwrite) RACCommand *getSearchResult;
@property (nonatomic, strong, readwrite) RACCommand *getNextSearchResult;
@property (nonatomic, strong, readwrite) RACSubject *refreshEndSubject;
@property (nonatomic, strong, readwrite) RACSubject *getBookDetail;

/// 记录下标
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation LHBooksViewModel

- (RACCommand *)getSearchResult
{
    if (!_getSearchResult) {
        @weakify(self);
        _getSearchResult = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            self.currentPage = 0;
            return [RACSubject createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                NSMutableDictionary *params = [@{@"start":@(self.currentPage),@"count":@(kPageCount)} mutableCopy];
                [[[LHNetwork shared]executeURLRequest:[NSString stringWithFormat:@"/book/search?q=\"%@\"",self.keywords] methodType:LHNetworkMethodGET params:params] subscribeNext:^(id x) {
                    LHBookList *bookList = [LHBookList mj_objectWithKeyValues:x];
                    self.dataSource = [bookList.books mutableCopy];
                    [subscriber sendNext:x];
                    [subscriber sendCompleted];
                } error:^(NSError *error) {
                    [subscriber sendError:error];
                }];
                return nil;
            }];
        }];
        [[_getSearchResult.executing skip:1] subscribeNext:^(id x) {
            if ([x isEqualToNumber:@(YES)]) {
                [SVProgressHUD showWithStatus:@"正在加载"];
            }else{
                [SVProgressHUD dismiss];
            }
        }];
    }
    return _getSearchResult;
}

- (RACCommand *)getNextSearchResult
{
    if (!_getNextSearchResult) {
        @weakify(self);
        _getNextSearchResult = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            self.currentPage++;
            return [RACSubject createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                NSMutableDictionary *params = [@{@"start":@(self.currentPage),@"count":@(kPageCount)} mutableCopy];
                [[[LHNetwork shared]executeURLRequest:[NSString stringWithFormat:@"/book/search?q=\"%@\"",self.keywords] methodType:LHNetworkMethodGET params:params] subscribeNext:^(id x) {
                    LHBookList *bookList = [LHBookList mj_objectWithKeyValues:x];
                    
                    [self.dataSource addObjectsFromArray:bookList.books];
                    [subscriber sendNext:bookList];
                    if (bookList.count < bookList.total || bookList.count * bookList.start < bookList.total) {
                        [self.refreshEndSubject sendNext:@(LHFooterRefresh_HasMoreData)];
                    }else{
                        [self.refreshEndSubject sendNext:@(LHFooterRefresh_HasNoMoreData)];
                    }
                    [subscriber sendNext:x];
                    [subscriber sendCompleted];
                } error:^(NSError *error) {
                    [subscriber sendError:error];
                }];
                return nil;
            }];
        }];
        [[_getNextSearchResult.executing skip:1] subscribeNext:^(id x) {
            if ([x isEqualToNumber:@(YES)]) {
                [SVProgressHUD showWithStatus:@"正在加载"];
            }else{
                [SVProgressHUD dismiss];
            }
        }];
    }
    return _getNextSearchResult;
}

- (RACSubject *)refreshEndSubject
{
    if (!_refreshEndSubject) {
        _refreshEndSubject = [RACSubject subject];
    }
    return _refreshEndSubject;
}
- (RACSubject *)getBookDetail
{
    if (!_getBookDetail) {
        _getBookDetail = [RACSubject subject];
    }
    return _getBookDetail;
}
@end
