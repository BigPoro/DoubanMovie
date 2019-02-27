#import "LHModel.h"

@class LHSimpleMovie;
@class LHCast;
@class LHImages;
@class LHRating;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Object interfaces

@interface LHSimpleMovie : LHModel
@property (nonatomic, strong) LHRating *rating;
@property (nonatomic, copy)   NSArray<NSString *> *genres;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSArray<LHCast *> *casts;
@property (nonatomic, assign) NSInteger collectCount;
@property (nonatomic, copy)   NSString *originalTitle;
@property (nonatomic, copy)   NSString *subtype;
@property (nonatomic, copy)   NSArray<LHCast *> *directors;
@property (nonatomic, copy)   NSString *year;
@property (nonatomic, strong) LHImages *images;
@property (nonatomic, copy)   NSString *alt;
@property (nonatomic, copy)   NSString *identifier;
@end

@interface LHCast : LHModel
@property (nonatomic, copy)   NSString *alt;
@property (nonatomic, strong) LHImages *avatars;
@property (nonatomic, copy)   NSString *name;
@property (nonatomic, copy)   NSString *identifier;
@end

@interface LHImages : LHModel
@property (nonatomic, copy) NSString *small;
@property (nonatomic, copy) NSString *large;
@property (nonatomic, copy) NSString *medium;
@end


NS_ASSUME_NONNULL_END
