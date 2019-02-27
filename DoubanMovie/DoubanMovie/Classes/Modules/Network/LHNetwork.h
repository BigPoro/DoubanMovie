//
//  LHNetwork.h
//  DoubanMovie
//
//  Created by iDog on 2019/2/27.
//  Copyright © 2019 iDog. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LHNetworkMethodType) {
    LHNetworkMethodGET = 0,
    LHNetworkMethodPOST,
    LHNetworkMethodPUT,
    LHNetworkMethodDELETE
};

NS_ASSUME_NONNULL_BEGIN

@interface LHNetwork : NSObject

/**
 单例初始化
 
 @return network sharedInstance
 */
+ (LHNetwork *)shared;

/**
 核心网络URL请求函数 (需要对返回结果进行处理)
 
 @param service 资源层(非接口字段)
 @param networkMethodType 请求类型:GET/POST/PUT/DELETE
 @param params 所需传递参数
 @param callback 返回结果的回调
 */
- (void)executeURLRequest:(NSString *)service methodType:(LHNetworkMethodType)networkMethodType params:(NSDictionary *)params callback:(void(^)(id response))callback;

@end

NS_ASSUME_NONNULL_END
