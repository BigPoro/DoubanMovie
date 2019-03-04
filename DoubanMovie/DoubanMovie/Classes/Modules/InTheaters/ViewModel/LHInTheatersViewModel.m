//
//  LHInTheatersViewModel.m
//  DoubanMovie
//
//  Created by iDog on 2019/2/27.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHInTheatersViewModel.h"
#import "LHMovieList.h"
#import "LHMovieDetail.h"
@interface LHInTheatersViewModel()

@property (nonatomic, strong, readwrite) RACCommand *getInTheatersMovies;
@property (nonatomic, strong, readwrite) RACCommand *getComingSoonMovies;
@property (nonatomic, strong, readwrite) RACCommand *getNextComingSoonMovies;
@property (nonatomic, strong, readwrite) RACCommand *getMovieDeteil;

@property (nonatomic, strong, readwrite) RACSubject *refreshEndSubject;
@property (nonatomic, strong, readwrite) RACSubject *InTheatersCellSubject;
@property (nonatomic, strong, readwrite) RACSubject *ComingSoonCellSubject;
@property (nonatomic, strong, readwrite) RACSubject *movieItemSubject;
@property (nonatomic, strong, readwrite) RACSubject *buyTicketsSubject;


@property (nonatomic, strong, readwrite) NSMutableArray *inTheatersData;
@property (nonatomic, strong, readwrite) NSMutableArray *comingSoonData;

/// 记录下标
@property (nonatomic, assign) NSInteger currentPage;

@end
@implementation LHInTheatersViewModel
- (RACCommand *)getInTheatersMovies
{
    if (!_getInTheatersMovies) {
        _getInTheatersMovies = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
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
        
        [[_getInTheatersMovies.executing skip:1] subscribeNext:^(id x) {
            if ([x isEqualToNumber:@(YES)]) {
                [SVProgressHUD showWithStatus:@"正在加载"];
            }else{
                [SVProgressHUD dismiss];
            }
        }];
        
    }
    return _getInTheatersMovies;
}
- (RACCommand *)getComingSoonMovies
{
    if (!_getComingSoonMovies) {
        @weakify(self);
        _getComingSoonMovies = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            
            self.currentPage = 0;
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                NSMutableDictionary *params = [@{@"start":@(self.currentPage),@"count":@(kPageCount)} mutableCopy];
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
                    [SVProgressHUD dismiss];

                }];
                return nil;
            }];
        }];
        [[_getComingSoonMovies.executing skip:1] subscribeNext:^(id x) {
            if ([x isEqualToNumber:@(YES)]) {
                [SVProgressHUD showWithStatus:@"正在加载"];
            }else{
                [SVProgressHUD dismiss];
            }
        }];
    }
    return _getComingSoonMovies;
}
- (RACCommand *)getNextComingSoonMovies
{
    if (!_getNextComingSoonMovies) {
        @weakify(self);
        _getNextComingSoonMovies = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            self.currentPage++;

            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                NSMutableDictionary *params = [@{@"start":@(self.currentPage),@"count":@(kPageCount)} mutableCopy];
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
                    [SVProgressHUD dismiss];
                    
                }];
                return nil;
            }];
        }];
        [[_getNextComingSoonMovies.executing skip:1] subscribeNext:^(id x) {
            if ([x isEqualToNumber:@(YES)]) {
                [SVProgressHUD showWithStatus:@"正在加载"];
            }else{
                [SVProgressHUD dismiss];
            }
        }];
    }
    return _getNextComingSoonMovies;
}

- (RACCommand *)getMovieDeteil
{
    if (!_getMovieDeteil) {
        _getMovieDeteil = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [[[LHNetwork shared] executeURLRequest:[NSString stringWithFormat:@"movie/subject/%@",self.movieID] methodType:LHNetworkMethodGET params:nil] subscribeNext:^(id x) {
                    LHMovieDetail *movie = [LHMovieDetail mj_objectWithKeyValues:x];
                    [subscriber sendNext:movie.mobile_url];
                    [subscriber sendCompleted];
                } error:^(NSError *error) {
                    [subscriber sendError:error];
                    [SVProgressHUD dismiss];

                }];
                return nil;
            }];
        }];
        [[_getMovieDeteil.executing skip:1] subscribeNext:^(id x) {
            if ([x isEqualToNumber:@(YES)]) {
                [SVProgressHUD showWithStatus:@"正在加载"];
            }else{
                [SVProgressHUD dismiss];
            }
        }];
    }
    return _getMovieDeteil;
}

- (RACSubject *)refreshEndSubject
{
    if (!_refreshEndSubject) {
        _refreshEndSubject = [RACSubject subject];
    }
    return _refreshEndSubject;
}
- (RACSubject *)buyTicketsSubject
{
    if (!_buyTicketsSubject) {
        _buyTicketsSubject = [RACSubject subject];
    }
    return _buyTicketsSubject;
}

- (RACSubject *)movieItemSubject
{
    if (!_movieItemSubject) {
        _movieItemSubject = [RACSubject subject];
    }
    return _movieItemSubject;
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
