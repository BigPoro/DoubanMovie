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

@property(nonatomic, strong, readwrite) RACCommand *getInTheatersMoives;
@property(nonatomic, strong, readwrite) RACCommand *getComingSoonMoives;

@end
@implementation LHInTheatersViewModel
- (RACCommand *)getInTheatersMoives
{
    if (!_getInTheatersMoives) {
        @weakify(self);
        _getInTheatersMoives = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                [[[LHNetwork shared] executeURLRequest:@"movie/in_theaters" methodType:LHNetworkMethodGET params:nil] subscribeNext:^(id x) {
                    [subscriber sendError:x];
                    [self handDataSource:x];
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
        _getComingSoonMoives = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [[[LHNetwork shared] executeURLRequest:@"movie/coming_soon" methodType:LHNetworkMethodGET params:nil] subscribeNext:^(id x) {
                    [subscriber sendError:x];
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
- (void)handDataSource:(id)dataModel
{
    LHMovieList *movieList = [LHMovieList mj_objectWithKeyValues:dataModel];
    [self.dataSignal sendNext:movieList];
}
@end
