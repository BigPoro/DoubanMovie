#import "LHModel.h"

@class LHMovieDetail;
@class LHAttrs;
@class LHAuthor;
@class LHRating;
@class LHTag;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Object interfaces

@interface LHMovieDetail : NSObject
@property (nonatomic, strong) LHRating *rating;
@property (nonatomic, copy)   NSArray<LHAuthor *> *author;
@property (nonatomic, copy)   NSString *altTitle;
@property (nonatomic, copy)   NSString *image;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *summary;
@property (nonatomic, strong) LHAttrs *attrs;
@property (nonatomic, copy)   NSString *identifier;
@property (nonatomic, copy)   NSString *mobileLink;
@property (nonatomic, copy)   NSString *alt;
@property (nonatomic, copy)   NSArray<LHTag *> *tags;
@end

@interface LHAttrs : NSObject
@property (nonatomic, copy) NSArray<NSString *> *language;
@property (nonatomic, copy) NSArray<NSString *> *pubdate;
@property (nonatomic, copy) NSArray<NSString *> *title;
@property (nonatomic, copy) NSArray<NSString *> *country;
@property (nonatomic, copy) NSArray<NSString *> *writer;
@property (nonatomic, copy) NSArray<NSString *> *director;
@property (nonatomic, copy) NSArray<NSString *> *cast;
@property (nonatomic, copy) NSArray<NSString *> *movieDuration;
@property (nonatomic, copy) NSArray<NSString *> *year;
@property (nonatomic, copy) NSArray<NSString *> *movieType;
@end

@interface LHAuthor : NSObject
@property (nonatomic, copy) NSString *name;
@end



@interface LHTag : NSObject
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, copy)   NSString *name;
@end

NS_ASSUME_NONNULL_END
