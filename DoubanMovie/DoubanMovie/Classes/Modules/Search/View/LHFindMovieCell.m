//
//  LHFindMovieCell.m
//  DoubanMovie
//
//  Created by iDog on 2019/3/2.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHFindMovieCell.h"
#import <HCSStarRatingView.h>
#import "LHSimpleMovie.h"
@interface LHFindMovieCell ()
@property (nonatomic, weak) UIImageView *posterView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *ratingLabel;

@property (nonatomic, weak) HCSStarRatingView *starRatingView;
@end

@implementation LHFindMovieCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setCellData:(id)data
{
    _cellData = data;
    LHSimpleMovie *movie = (LHSimpleMovie *)data;
    [_posterView sd_setImageWithURL:[NSURL URLWithString:movie.images.small]];
    _titleLabel.text = movie.title;
    
    _starRatingView.value = movie.rating.average / 2;
    _ratingLabel.text = [NSString stringWithFormat:@"%.1f",movie.rating.average];
}


- (void)setupUI
{
    UIImageView *iv = [UIImageView new];
    [self.contentView addSubview:iv];
    _posterView = iv;
    [_posterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
    }];
    UILabel *title = [UILabel new];
    [self.contentView addSubview:title];
    title.font = [UIFont boldSystemFontOfSize:16];
    title.textColor = kGray_five;
    _titleLabel = title;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_posterView).offset(kMargin);
        make.left.equalTo(_posterView);
        make.right.equalTo(self.contentView);
    }];
    
    HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc] init];
    starRatingView.maximumValue = 5;
    starRatingView.minimumValue = 0;
    starRatingView.allowsHalfStars = YES;
    
    starRatingView.tintColor = [UIColor orangeColor];
    [self.contentView addSubview:starRatingView];
    _starRatingView = starRatingView;
    [_starRatingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel);
        make.top.equalTo(_titleLabel.mas_bottom).offset(8);
        make.size.mas_equalTo(CGSizeMake(80, 15));
    }];
    
    UILabel *rating = [UILabel new];
    [self.contentView addSubview:rating];
    rating.font = [UIFont systemFontOfSize:12];
    rating.textColor = kGray_four;
    _ratingLabel = rating;
    [_ratingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_starRatingView);
        make.left.equalTo(_starRatingView.mas_right);
    }];
    
}
@end
