#import "LHModel.h"

@class LHSimpleMusic;
@class LHMusicAttrs;
@class LHAuthor;
@class LHRating;
@class LHTags;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Object interfaces

@interface LHSimpleMusic : LHModel
@property (nonatomic, strong) LHRating *rating;
@property (nonatomic, strong) NSArray<LHAuthor *> *author;
@property (nonatomic, copy)   NSString *altTitle;
@property (nonatomic, copy)   NSString *image;
@property (nonatomic, strong) NSArray<LHTags *> *tags;
@property (nonatomic, copy)   NSString *mobileLink;
@property (nonatomic, strong) LHMusicAttrs *attrs;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *alt;
@property (nonatomic, copy)   NSString *identifier;
@end

@interface LHMusicAttrs : NSObject
@property (nonatomic, strong) NSArray<NSString *> *publisher;
@property (nonatomic, strong) NSArray<NSString *> *singer;
@property (nonatomic, strong) NSArray<NSString *> *version;
@property (nonatomic, strong) NSArray<NSString *> *pubdate;
@property (nonatomic, strong) NSArray<NSString *> *title;
@property (nonatomic, strong) NSArray<NSString *> *media;
@property (nonatomic, strong) NSArray<NSString *> *tracks;
@property (nonatomic, strong) NSArray<NSString *> *discs;
@end




NS_ASSUME_NONNULL_END
