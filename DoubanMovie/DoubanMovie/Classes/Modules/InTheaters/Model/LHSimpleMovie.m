#import "LHSimpleMovie.h"

@implementation LHSimpleMovie
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"identifier":@"id"};
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"genres": @"LHCast",
             @"directors": @"LHCast"
             };
}
@end

@implementation LHCast
@end

@implementation LHImages
@end

