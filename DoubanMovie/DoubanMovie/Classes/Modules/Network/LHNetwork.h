//
//  LHNetwork.h
//  DoubanMovie
//
//  Created by iDog on 2019/2/27.
//  Copyright © 2019 iDog. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kWebHostHeader = @"https://api.douban.com/v2";
static NSString * const apikey = @"0df993c66c0c636e29ecbb5344252a4a";

typedef NS_ENUM(NSInteger, LHNetworkMethodType) {
    LHNetworkMethodGET = 0,
    LHNetworkMethodPOST,
    LHNetworkMethodPUT,
    LHNetworkMethodDELETE
};

static NSInteger const kPageCount = 20;

NS_ASSUME_NONNULL_BEGIN

@interface LHNetwork : NSObject

/**
 单例初始化
 
 @return network sharedInstance
 */
+ (LHNetwork *)shared;

/**
 发出网络请求

 @param service 资源路径
 @param networkMethodType 请求方式
 @param params 请求参数
 @return 返回信号 订阅后发送结果
 */
- (RACSignal *)executeURLRequest:(NSString *)service methodType:(LHNetworkMethodType)networkMethodType params:(NSDictionary * __nullable)params;
/**
 取消网络请求
 */
- (void)cancelRequest;
@end

NS_ASSUME_NONNULL_END
