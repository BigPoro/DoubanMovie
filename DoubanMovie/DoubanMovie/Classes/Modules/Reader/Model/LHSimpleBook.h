#import "LHModel.h"
#import "LHImages.h"
@class LHSimpleBook;
@class LHTags;
@class LHRating;
NS_ASSUME_NONNULL_BEGIN

#pragma mark - Object interfaces

@interface LHSimpleBook : LHModel
@property (nonatomic, strong) LHRating *rating;
@property (nonatomic, copy)   NSString *subtitle;
@property (nonatomic, strong) NSArray<NSString *> *author;
@property (nonatomic, copy)   NSString *pubdate;
@property (nonatomic, strong) NSArray<LHTags *> *tags;
@property (nonatomic, copy)   NSString *originTitle;
@property (nonatomic, copy)   NSString *image;
@property (nonatomic, copy)   NSString *binding;
@property (nonatomic, copy)   NSArray *translator;
@property (nonatomic, copy)   NSString *catalog;
@property (nonatomic, copy)   NSString *pages;
@property (nonatomic, strong) LHImages *images;
@property (nonatomic, copy)   NSString *alt;
@property (nonatomic, copy)   NSString *identifier;
@property (nonatomic, copy)   NSString *publisher;
@property (nonatomic, copy)   NSString *isbn10;
@property (nonatomic, copy)   NSString *isbn13;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *url;
@property (nonatomic, copy)   NSString *altTitle;
@property (nonatomic, copy)   NSString *authorIntro;
@property (nonatomic, copy)   NSString *summary;
@property (nonatomic, copy)   NSString *price;
@end



NS_ASSUME_NONNULL_END
