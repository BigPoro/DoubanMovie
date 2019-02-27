#import <Foundation/Foundation.h>

@class LHSimpleMovie;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Object interfaces

@interface LHMoiveList : NSObject
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger start;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, copy)   NSArray <LHSimpleMovie *>*subjects;
@property (nonatomic, copy)   NSString *title;
@end

NS_ASSUME_NONNULL_END
