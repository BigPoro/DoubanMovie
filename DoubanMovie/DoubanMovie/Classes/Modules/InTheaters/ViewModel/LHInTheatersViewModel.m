//
//  LHInTheatersViewModel.m
//  DoubanMovie
//
//  Created by iDog on 2019/2/27.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHInTheatersViewModel.h"
#import "LHMovieList.h"
@interface LHInTheatersViewModel()

@property (nonatomic, strong, readwrite) RACCommand *getInTheatersMoives;
@property (nonatomic, strong, readwrite) RACCommand *getComingSoonMoives;
@property (nonatomic, strong, readwrite) RACCommand *getNextComingSoonMoives;
@property (nonatomic, strong, readwrite) RACSubject  *refreshEndSubject;

@property (nonatomic, strong, readwrite) NSMutableArray *inTheatersData;
@property (nonatomic, strong, readwrite) NSMutableArray *comingSoonData;

/// 记录下标
@property (nonatomic, assign) NSInteger currentPage;

@end
@implementation LHInTheatersViewModel
- (RACCommand *)getInTheatersMoives
{
    if (!_getInTheatersMoives) {
        _getInTheatersMoives = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [[[LHNetwork shared] executeURLRequest:@"movie/in_theaters" methodType:LHNetworkMethodGET params:nil] subscribeNext:^(id x) {
                    LHMovieList *movieList = [LHMovieList mj_objectWithKeyValues:x];
                    /// 添加数据
                    self.inTheatersData = [movieList.subjects mutableCopy];
                    [subscriber sendNext:movieList];
                    [subscriber sendCompleted];
                }error:^(NSError *error) {
                    [subscriber sendError:error];
                }];
                return nil;
            }];
        }];
    }
    return _getInTheatersMoives;
}
- (RACCommand *)getComingSoonMoives
{
    if (!_getComingSoonMoives) {
        @weakify(self);
        _getComingSoonMoives = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            
            self.currentPage = 0;
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                NSMutableDictionary *params = [@{@"start":@(self.currentPage),@"count":@(kCount)} mutableCopy];
                [[[LHNetwork shared] executeURLRequest:@"movie/coming_soon" methodType:LHNetworkMethodGET params:params] subscribeNext:^(id x) {
                    LHMovieList *movieList = [LHMovieList mj_objectWithKeyValues:x];
                    /// 添加数据
                    self.comingSoonData = [movieList.subjects mutableCopy];
                    [subscriber sendNext:movieList];
                    if (movieList.count < movieList.total || movieList.count * movieList.start < movieList.total) {
                        [self.refreshEndSubject sendNext:@(LHFooterRefresh_HasMoreData)];
                    }else{
                        [self.refreshEndSubject sendNext:@(LHFooterRefresh_HasNoMoreData)];
                    }
                    [subscriber sendCompleted];
                }error:^(NSError *error) {
                    [subscriber sendError:error];
                }];
                return nil;
            }];
        }];
    }
    return _getInTheatersMoives;
}
- (RACCommand *)getNextComingSoonMoives
{
    if (!_getNextComingSoonMoives) {
        @weakify(self);
        _getNextComingSoonMoives = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            self.currentPage++;
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                NSMutableDictionary *params = [@{@"start":@(self.currentPage),@"count":@(kCount)} mutableCopy];
                [[[LHNetwork shared] executeURLRequest:@"movie/coming_soon" methodType:LHNetworkMethodGET params:params] subscribeNext:^(id x) {
                    LHMovieList *movieList = [LHMovieList mj_objectWithKeyValues:x];
                    /// 添加数据
                    [self.comingSoonData addObjectsFromArray:movieList.subjects];
                    [subscriber sendNext:movieList];
                    if (movieList.count < movieList.total || movieList.count * movieList.start < movieList.total) {
                        [self.refreshEndSubject sendNext:@(LHFooterRefresh_HasMoreData)];
                    }else{
                        [self.refreshEndSubject sendNext:@(LHFooterRefresh_HasNoMoreData)];
                    }
                    [subscriber sendCompleted];
                }error:^(NSError *error) {
                    [subscriber sendError:error];
                }];
                return nil;
            }];
        }];
    }
    return _getNextComingSoonMoives;
}

- (RACSubject *)refreshEndSubject
{
    if (!_refreshEndSubject) {
        _refreshEndSubject = [RACSubject subject];
    }
    return _refreshEndSubject;
}
- (NSMutableArray *)inTheatersData
{
    if (!_inTheatersData) {
        _inTheatersData = [NSMutableArray array];
    }
    return _inTheatersData;
}
- (NSMutableArray *)comingSoonData
{
    if (!_comingSoonData) {
        _comingSoonData = [NSMutableArray array];
    }
    return _comingSoonData;
}
@end
