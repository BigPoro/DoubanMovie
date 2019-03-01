#import "LHSimpleMovie.h"

@implementation LHSimpleMovie
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"identifier":@"id",
             @"collectCount":@"collect_count",
             @"originalTitle":@"original_title"
             };
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"casts": @"LHCast",
             @"directors": @"LHCast"
             };
}
@end

@implementation LHCast
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"identifier":@"id"};
}
@end

@implementation LHImages
@end

