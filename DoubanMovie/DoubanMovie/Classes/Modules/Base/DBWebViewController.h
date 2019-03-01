//
//  DBWebViewController.h
//  doSchool
//
//  Created by chengzhang Yan on 17/11/20.
//  Copyright (c) 2017年 doBell. All rights reserved.
//

#import "LHViewController.h"
@interface DBWebViewController : LHViewController

@property (nonatomic, copy) NSString *URLString;

- (void)loadWebRequestWithUrlString:(NSString *)urlString;

- (void)refreshData;

@end
