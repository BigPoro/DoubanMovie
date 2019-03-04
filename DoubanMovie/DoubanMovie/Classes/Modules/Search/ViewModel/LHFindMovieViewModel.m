//
//  LHFindMovieViewModel.m
//  DoubanMovie
//
//  Created by iDog on 2019/3/2.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHFindMovieViewModel.h"
#import "LHMovieList.h"
#import "LHMovieDetail.h"
#import "LHMovieRankingList.h"

@interface LHFindMovieViewModel ()
@property (nonatomic, strong, readwrite) RACCommand *getAllData;
@property (nonatomic, strong, readwrite) RACCommand *getMovieDeteil;

@property (nonatomic, strong, readwrite) RACSubject *movieItemSubject;
@property (nonatomic, strong, readwrite) RACSubject *refreshSubject;
@property (nonatomic, strong, readwrite) NSMutableArray *weeklyRatingData;
@property (nonatomic, strong, readwrite) NSMutableArray *NewMovieRatingData;
@property (nonatomic, strong, readwrite) NSMutableArray *USBoxRatingData;
@property (nonatomic, strong, readwrite) NSMutableArray *top250Data;

@end
@implementation LHFindMovieViewModel

- (RACCommand *)getAllData
{
    if (!_getAllData) {
        @weakify(self);
        _getAllData = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self creatRequestSignal];
        }];
       
    }
    return _getAllData;
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
                }] ;
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
- (RACSignal *)creatRequestSignal
{
    @weakify(self);
    RACSignal *getWeeklyRating  = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [[[LHNetwork shared] executeURLRequest:[NSString stringWithFormat:@"movie/weekly?apikey=%@",apikey] methodType:LHNetworkMethodGET params:nil] subscribeNext:^(id x) {
            LHMovieRankingList *movieList = [LHMovieRankingList mj_objectWithKeyValues:x];
            self.weeklyRatingData = [movieList.subjects mutableCopy];
            [subscriber sendNext:x];
            [subscriber sendCompleted];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
    
    RACSignal *getUSBoxRating  = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [[[LHNetwork shared] executeURLRequest:@"/movie/us_box" methodType:LHNetworkMethodGET params:nil] subscribeNext:^(id x) {
            LHMovieRankingList *movieList = [LHMovieRankingList mj_objectWithKeyValues:x];
            self.USBoxRatingData = [movieList.subjects mutableCopy];
            [subscriber sendNext:x];
            [subscriber sendCompleted];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
    RACSignal *getNewMoviesRating  = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
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
    RACSignal *getTop250  = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSMutableDictionary *params = [@{@"start":@(0),@"count":@(20)} mutableCopy];
        [[[LHNetwork shared] executeURLRequest:@"/movie/us_box" methodType:LHNetworkMethodGET params:params] subscribeNext:^(id x) {
            LHMovieRankingList *movieList = [LHMovieRankingList mj_objectWithKeyValues:x];
            self.top250Data = [movieList.subjects mutableCopy];
            [subscriber sendNext:x];
            [subscriber sendCompleted];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
    return [self rac_liftSelector:@selector(reloadCollectionViewWithDataOne:dataTwo:dataThree:dataFour:) withSignals:getWeeklyRating,getUSBoxRating,getNewMoviesRating,getTop250, nil];
}
- (void)reloadCollectionViewWithDataOne:(id)dataOne dataTwo:(id)dataTwo dataThree:(id)dataThree dataFour:(id)dataFour
{
    [self.refreshSubject sendNext:@"refresh"];
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
- (RACSubject *)refreshSubject
{
    if (!_refreshSubject) {
        _refreshSubject = [RACSubject subject];
    }
    return _refreshSubject;
}
- (RACSubject *)movieItemSubject
{
    if (!_movieItemSubject) {
        _movieItemSubject = [RACSubject subject];
    }
    return _movieItemSubject;
}
@end
