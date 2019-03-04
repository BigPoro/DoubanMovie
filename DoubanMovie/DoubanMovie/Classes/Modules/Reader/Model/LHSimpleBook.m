#import "LHSimpleBook.h"

@implementation LHSimpleBook
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"identifier":@"id"
             };
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"tags": @"LHTag"
             };
}
@end

