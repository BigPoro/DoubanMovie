#import "LHSimpleMusic.h"

@implementation LHSimpleMusic
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"identifier":@"id"
             };
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"tags": @"LHTags",
             @"author":@"LHAuthor"
             };
}
@end

@implementation LHMusicAttrs
@end



