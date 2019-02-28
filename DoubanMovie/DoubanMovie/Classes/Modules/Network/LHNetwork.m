//
//  LHNetwork.m
//  DoubanMovie
//
//  Created by iDog on 2019/2/27.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHNetwork.h"
#import <AFNetworking.h>
static NSString * const kWebHostHeader = @"https://api.douban.com/v2";

static LHNetwork *_instance = nil;
static dispatch_once_t onceToken;

@interface LHNetwork()
@property (strong, nonatomic) AFHTTPSessionManager *manager;

@end

@implementation LHNetwork
/**
 初始化
 
 @return self
 */
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html", @"charset=utf-8", nil];
        _manager.requestSerializer.timeoutInterval = 30.f; // 写在前面会导致 AFNetworking 3.0 设置超时时间不起作用。
        // https 此处关闭证书验证
        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        //单向验证  请求处加上一下代码 就OK
        [policy setValidatesDomainName:NO];
        policy.allowInvalidCertificates = YES; //还是必须设成YES
        _manager.securityPolicy = policy;
        
    }
    return self;
}
/**
 单例方法
 
 @return 单例方法
 */
+ (LHNetwork *)shared
{
    
    dispatch_once(&onceToken, ^{
        if (!_instance)
        {
            _instance = [[LHNetwork alloc] init];
        }
    });
    return _instance;
}

- (RACSignal *)executeURLRequest:(NSString *)service methodType:(LHNetworkMethodType)networkMethodType params:(NSDictionary *__nullable)params
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self executeURLRequest:service methodType:networkMethodType params:params subscriber:subscriber];
        return nil;
    }];
}
#pragma mark - core function , private method
/**
 核心网络URL请求函数 (需要对返回结果进行处理)
 
 @param service 资源层(非接口字段)
 @param networkMethodType 请求类型:GET/POST/PUT/DELETE
 @param params 所需传递参数
 @param subscriber 返回结果的信号
 */
- (void)executeURLRequest:(NSString *)service methodType:(LHNetworkMethodType)networkMethodType params:(NSDictionary *)params subscriber:(id <RACSubscriber>)subscriber
{
    //设置url
    NSString *url = [kWebHostHeader stringByAppendingString:@"/"];
    
    url = [url stringByAppendingString:service];
    debug_NSLog(@"网络请求的接口 <--> %@",url);
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    debug_NSLog(@"网络请求的接口 <--> %@",url);
    
    NSMutableDictionary *paramsDictionary = [[NSMutableDictionary alloc] initWithDictionary:params];
    
    //设置方法
    switch (networkMethodType)
    {
        case LHNetworkMethodGET:
        {
            [self.manager GET:url parameters:paramsDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
                [subscriber sendNext:jsonDic];
                [subscriber sendCompleted];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                debug_NSLog(@"error:%@,error.description:%@", error, error.description);
                 [self handleTheFailurefullNetWorkResult];
                [subscriber sendError:error];
            }];
        }
            break;
        case LHNetworkMethodPOST:
        {
            [self.manager POST:url parameters:paramsDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
                [subscriber sendNext:jsonDic];
                [subscriber sendCompleted];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                debug_NSLog(@"error:%@,error.description:%@", error, error.description);
                [self handleTheFailurefullNetWorkResult];

                [subscriber sendError:error];

            }];
        }
            break;
        case LHNetworkMethodPUT:
        {
            [self.manager PUT:url parameters:paramsDictionary success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
                [subscriber sendNext:jsonDic];
                [subscriber sendCompleted];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                debug_NSLog(@"error:%@,error.description:%@", error, error.description);
                [self handleTheFailurefullNetWorkResult];
                [subscriber sendError:error];
            }];
        }
            break;
        case LHNetworkMethodDELETE:
        {
            [self.manager DELETE:url parameters:paramsDictionary success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
                [subscriber sendNext:jsonDic];
                [subscriber sendCompleted];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                debug_NSLog(@"error:%@,error.description:%@", error, error.description);
                [subscriber sendError:error];
                [self handleTheFailurefullNetWorkResult];
            }];
        }
            break;
        default:
            break;
    }
}
- (void)handleTheFailurefullNetWorkResult
{
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"Surprise" message:@"The request failed" preferredStyle:UIAlertControllerStyleAlert];
    [vc addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [[self getAppPresentingViewController] presentViewController:vc animated:YES completion:nil];
}
/**
 取消网络请求
 */
- (void)cancelRequest
{
    if (self.manager.tasks.count > 0) {
        [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    }
}
@end
