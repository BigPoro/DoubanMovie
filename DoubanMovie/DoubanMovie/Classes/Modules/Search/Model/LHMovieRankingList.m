//
//  LHMovieRankingList.m
//  DoubanMovie
//
//  Created by iDog on 2019/3/4.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHMovieRankingList.h"

@implementation LHMovieRankingList
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"subjects": @"LHSimpleMovieRanking"
             };
}
@end

@implementation LHSimpleMovieRanking
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"isnNew":@"new"
             };
}
@end
