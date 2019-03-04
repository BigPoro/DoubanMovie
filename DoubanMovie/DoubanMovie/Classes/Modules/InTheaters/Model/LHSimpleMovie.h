#import "LHModel.h"
#import "LHRating.h"
#import "LHImages.h"

@class LHSimpleMovie;
@class LHCast;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Object interfaces

@interface LHSimpleMovie : LHModel
@property (nonatomic, strong) LHRating *rating;
@property (nonatomic, copy)   NSArray<NSString *> *genres;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, strong) NSArray<LHCast *> *casts;
@property (nonatomic, assign) NSInteger collectCount;
@property (nonatomic, copy)   NSString *originalTitle;
@property (nonatomic, copy)   NSString *subtype;
@property (nonatomic, strong) NSArray<LHCast *> *directors;
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




NS_ASSUME_NONNULL_END
