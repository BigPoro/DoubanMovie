//
//  LHMusicViewModel.m
//  DoubanMovie
//
//  Created by iDog on 2019/3/5.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHMusicViewModel.h"
#import "LHMusicList.h"
@interface LHMusicViewModel ()
@property (nonatomic, strong, readwrite) RACCommand *getSearchResult;
@property (nonatomic, strong, readwrite) RACCommand *getNextSearchResult;
@property (nonatomic, strong, readwrite) RACSubject *refreshEndSubject;
@property (nonatomic, strong, readwrite) RACSubject *getMusicDetail;

/// 记录下标
@property (nonatomic, assign) NSInteger currentPage;
@end
@implementation LHMusicViewModel
- (RACCommand *)getSearchResult
{
    if (!_getSearchResult) {
        _keywords = @"周杰伦";
        @weakify(self);
        _getSearchResult = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            self.currentPage = 0;
            return [RACSubject createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                NSMutableDictionary *params = [@{@"start":@(self.currentPage),@"count":@(kPageCount)} mutableCopy];
                [[[LHNetwork shared]executeURLRequest:[NSString stringWithFormat:@"/music/search?q=\"%@\"",self.keywords] methodType:LHNetworkMethodGET params:params] subscribeNext:^(id x) {
                    LHMusicList *musicList = [LHMusicList mj_objectWithKeyValues:x];
                    self.dataSource = [musicList.musics mutableCopy];
                    
                    if (musicList.count < musicList.total || musicList.count * musicList.start < musicList.total) {
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
                [[[LHNetwork shared]executeURLRequest:[NSString stringWithFormat:@"/music/search?q=\"%@\"",self.keywords] methodType:LHNetworkMethodGET params:params] subscribeNext:^(id x) {
                    LHMusicList *musicList = [LHMusicList mj_objectWithKeyValues:x];
                    [self.dataSource addObjectsFromArray:musicList.musics];
                    
                    if (musicList.count < musicList.total || musicList.count * musicList.start < musicList.total) {
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
- (RACSubject *)getMusicDetail
{
    if (!_getMusicDetail) {
        _getMusicDetail = [RACSubject subject];
    }
    return _getMusicDetail;
}
@end
