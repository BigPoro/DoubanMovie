//
//  LHFindMovieViewModel.m
//  DoubanMovie
//
//  Created by iDog on 2019/3/2.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHFindMovieViewModel.h"
#import "LHMovieList.h"

@interface LHFindMovieViewModel ()
@property (nonatomic, strong, readwrite) RACCommand *getAllData;
@property (nonatomic, strong, readwrite) RACCommand *getWeeklyRating;
@property (nonatomic, strong, readwrite) RACCommand *getUSBoxRating;
@property (nonatomic, strong, readwrite) RACCommand *getNewMoviesRating;
@property (nonatomic, strong, readwrite) RACCommand *getTop250;

@property (nonatomic, strong, readwrite) RACSubject *MovieItemSubject;

@property (nonatomic, strong, readwrite) NSMutableArray *weeklyRatingData;
@property (nonatomic, strong, readwrite) NSMutableArray *NewMovieRatingData;
@property (nonatomic, strong, readwrite) NSMutableArray *USBoxRatingData;
@property (nonatomic, strong, readwrite) NSMutableArray *top250Data;

@end
@implementation LHFindMovieViewModel


- (RACCommand *)getWeeklyRating
{
    if (!_getWeeklyRating) {
        @weakify(self);
        _getWeeklyRating = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [[[LHNetwork shared] executeURLRequest:[NSString stringWithFormat:@"movie/weekly?apikey=%@",apikey] methodType:LHNetworkMethodGET params:nil] subscribeNext:^(id x) {
                    LHMovieList *movieList = [LHMovieList mj_objectWithKeyValues:x];
                    self.weeklyRatingData = [movieList.subjects mutableCopy];
                    [subscriber sendNext:x];
                    [subscriber sendCompleted];
                } error:^(NSError *error) {
                    [subscriber sendError:error];
                }];
                return nil;
            }];
        }];
        [[_getWeeklyRating.executionSignals skip:1] subscribeNext:^(id x) {
            if ([x isEqualToNumber:@(YES)]) {
                [SVProgressHUD showWithStatus:@"正在加载"];
            }else{
                [SVProgressHUD dismiss];
            }
        }];
    }
    return _getWeeklyRating;
}
- (RACCommand *)getUSBoxRating
{
    if (!_getUSBoxRating) {
        @weakify(self);
        _getUSBoxRating = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [[[LHNetwork shared] executeURLRequest:@"/movie/us_box" methodType:LHNetworkMethodGET params:nil] subscribeNext:^(id x) {
                    LHMovieList *movieList = [LHMovieList mj_objectWithKeyValues:x];
                    self.USBoxRatingData = [movieList.subjects mutableCopy];
                    [subscriber sendNext:x];
                    [subscriber sendCompleted];
                } error:^(NSError *error) {
                    [subscriber sendError:error];
                }];
                return nil;
            }];
        }];
        [[_getUSBoxRating.executionSignals skip:1] subscribeNext:^(id x) {
            if ([x isEqualToNumber:@(YES)]) {
                [SVProgressHUD showWithStatus:@"正在加载"];
            }else{
                [SVProgressHUD dismiss];
            }
        }];
    }
    return _getUSBoxRating;
}
- (RACCommand *)getNewMoviesRating
{
    if (!_getNewMoviesRating) {
        @weakify(self);
        _getNewMoviesRating = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [[[LHNetwork shared] executeURLRequest:[NSString stringWithFormat:@"movie/new_movies?apikey=%@",apikey] methodType:LHNetworkMethodGET params:nil] subscribeNext:^(id x) {
                    LHMovieList *movieList = [LHMovieList mj_objectWithKeyValues:x];
                    self.NewMovieRatingData = [movieList.subjects mutableCopy];
                    [subscriber sendNext:x];
                    [subscriber sendCompleted];
                } error:^(NSError *error) {
                    [subscriber sendError:error];
                }];
                return nil;
            }];
        }];
        [[_getNewMoviesRating.executionSignals skip:1] subscribeNext:^(id x) {
            if ([x isEqualToNumber:@(YES)]) {
                [SVProgressHUD showWithStatus:@"正在加载"];
            }else{
                [SVProgressHUD dismiss];
            }
        }];
    }
    return _getNewMoviesRating;
}
- (RACCommand *)getTop250
{
    if (!_getTop250) {
        @weakify(self);
        _getTop250 = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                NSMutableDictionary *params = [@{@"start":@(0),@"count":@(20)} mutableCopy];
                [[[LHNetwork shared] executeURLRequest:@"/movie/us_box" methodType:LHNetworkMethodGET params:params] subscribeNext:^(id x) {
                    LHMovieList *movieList = [LHMovieList mj_objectWithKeyValues:x];
                    self.top250Data = [movieList.subjects mutableCopy];
                    [subscriber sendNext:x];
                    [subscriber sendCompleted];
                } error:^(NSError *error) {
                    [subscriber sendError:error];
                }];
                return nil;
            }];
        }];
        [[_getTop250.executionSignals skip:1] subscribeNext:^(id x) {
            if ([x isEqualToNumber:@(YES)]) {
                [SVProgressHUD showWithStatus:@"正在加载"];
            }else{
                [SVProgressHUD dismiss];
            }
        }];
    }
    return _getTop250;
}
- (void)createRequestSignal
{
    
}
#pragma mark DataInit
- (NSMutableArray *)weeklyRatingData
{
    if (!_weeklyRatingData) {
        _weeklyRatingData = [NSMutableArray array];
    }
    return _weeklyRatingData;
}
- (NSMutableArray *)NewMovieRatingData
{
    if (!_NewMovieRatingData) {
        _NewMovieRatingData = [NSMutableArray array];
    }
    return _NewMovieRatingData;
}
- (NSMutableArray *)USBoxRatingData
{
    if (!_USBoxRatingData) {
        _USBoxRatingData = [NSMutableArray array];
    }
    return _USBoxRatingData;
}
- (NSMutableArray *)top250Data
{
    if (!_top250Data) {
        _top250Data = [NSMutableArray array];
    }
    return _top250Data;
}

@end
