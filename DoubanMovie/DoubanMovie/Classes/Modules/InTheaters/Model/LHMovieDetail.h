#import "LHModel.h"

@class LHMovieDetail;
@class LHMovieAttrs;
@class LHAuthor;
@class LHRating;
@class LHTag;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Object interfaces

@interface LHMovieDetail : NSObject
@property (nonatomic, strong) LHRating *rating;
@property (nonatomic, assign) NSInteger reviews_count;
@property (nonatomic, assign) NSInteger wish_count;
@property (nonatomic, copy)   NSString *douban_site;
@property (nonatomic, copy)   NSString *year;
@property (nonatomic, copy)   NSString *mobile_url;
@property (nonatomic, copy)   NSString *do_count;
@property (nonatomic, copy)   NSString *share_url;

@property (nonatomic, strong) NSArray<LHAuthor *> *author;
@property (nonatomic, copy)   NSString *alt;
@property (nonatomic, copy)   NSString *image;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *summary;
@property (nonatomic, strong) LHMovieAttrs *attrs;
@property (nonatomic, copy)   NSString *identifier;
@property (nonatomic, copy)   NSString *mobileLink;
@property (nonatomic, copy)   NSString *altTitle;
@property (nonatomic, strong) NSArray<LHTag *> *tags;
@end

@interface LHMovieAttrs : NSObject
@property (nonatomic, strong) NSArray<NSString *> *language;
@property (nonatomic, strong) NSArray<NSString *> *pubdate;
@property (nonatomic, strong) NSArray<NSString *> *title;
@property (nonatomic, strong) NSArray<NSString *> *country;
@property (nonatomic, strong) NSArray<NSString *> *writer;
@property (nonatomic, strong) NSArray<NSString *> *director;
@property (nonatomic, strong) NSArray<NSString *> *cast;
@property (nonatomic, strong) NSArray<NSString *> *movieDuration;
@property (nonatomic, strong) NSArray<NSString *> *year;
@property (nonatomic, strong) NSArray<NSString *> *movieType;
@end

NS_ASSUME_NONNULL_END
