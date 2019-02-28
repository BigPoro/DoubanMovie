//
//  LHInTheatersCell.m
//  DoubanMovie
//
//  Created by iDog on 2019/2/28.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHInTheatersCell.h"
#import <HCSStarRatingView.h>
#import "LHSimpleMovie.h"

@interface LHInTheatersCell ()
@property (nonatomic, weak) UIImageView *posterView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *directorsLabel;
@property (nonatomic, weak) UILabel *castsLabel;
@property (nonatomic, weak) UILabel *collectionLabel;
@property (nonatomic, weak) UILabel *ratingLabel;

@property (nonatomic, weak) HCSStarRatingView *starRatingView;
@end

@implementation LHInTheatersCell


- (void)setCellData:(id)data
{
    LHSimpleMovie *movie = (LHSimpleMovie *)data;
    [_posterView sd_setImageWithURL:[NSURL URLWithString:movie.images.small]];
    _titleLabel.text = movie.title;
    LHCast *directors = movie.directors.firstObject;
    _directorsLabel.text = directors.name;
    
    _starRatingView.value = [movie.rating.average floatValue];
    _ratingLabel.text = movie.rating.average;
    __block NSString *castsDesc = @"";
    [movie.casts enumerateObjectsUsingBlock:^(LHCast * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        castsDesc = [castsDesc stringByAppendingString:[NSString stringWithFormat:@"%@ /",obj.name]];
    }];
    _castsLabel.text = castsDesc;
}

- (void)setupUI
{
    UIImageView *iv = [UIImageView new];
    [self.contentView addSubview:iv];
    _posterView = iv;
    [_posterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(16);
        make.size.mas_offset(CGSizeMake(100, 150));
        make.bottom.equalTo(self.contentView).offset(-16);
    }];
    CGFloat maxWidth = kScreenW - 4 * 16 - 100 - 80;
    UILabel *title = [UILabel new];
    [self.contentView addSubview:title];
    title.font = [UIFont boldSystemFontOfSize:20];
    title.textColor = kGray_five;
    _titleLabel = title;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_posterView);
        make.left.equalTo(_posterView.mas_right).offset(16);
    }];
    
    UILabel *directors = [UILabel new];
    [self.contentView addSubview:directors];
    directors.font = [UIFont systemFontOfSize:12];
    directors.textColor = kGray_four;
    _directorsLabel = directors;
    [_directorsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom);
        make.left.equalTo(_titleLabel);
    }];
    
    HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc] init];
    starRatingView.maximumValue = 10;
    starRatingView.minimumValue = 0;
    starRatingView.tintColor = [UIColor redColor];
    [self.contentView addSubview:starRatingView];
    _starRatingView = starRatingView;
    [_starRatingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_directorsLabel);
        make.top.equalTo(_directorsLabel.mas_bottom).offset(8);
        make.size.mas_equalTo(CGSizeMake(100, 20));
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
    
    UILabel *casts = [UILabel new];
    [self.contentView addSubview:casts];
    casts.numberOfLines = 2;
    casts.preferredMaxLayoutWidth = maxWidth;
    casts.font = [UIFont systemFontOfSize:12];
    casts.textColor = kGray_four;
    _castsLabel = casts;
    [_castsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_starRatingView.mas_bottom).offset(8);
        make.left.equalTo(_titleLabel);
    }];
}

@end
