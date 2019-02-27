//
//  NSArray+Log.m
//  DoubanMovie
//
//  Created by iDog on 2019/2/27.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "NSArray+Log.h"

@implementation NSArray (Log)


- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *string = [NSMutableString stringWithString:@"(\n"];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        [string appendFormat:@"\t%@,\n", obj];
    }];
    if ([string hasSuffix:@",\n"]) {
        
        [string deleteCharactersInRange:NSMakeRange(string.length - 2, 1)]; // 删除最后一个逗号
    }
    [string appendString:@")\n"];
    
    return string;
}

@end
