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
    [super setCellData:data];
    LHSimpleMovie *movie = (LHSimpleMovie *)data;
    [_posterView sd_setImageWithURL:[NSURL URLWithString:movie.images.small]];
    _titleLabel.text = movie.title;
    LHCast *directors = movie.directors.firstObject;
    _directorsLabel.text = [@"导演：" stringByAppendingString:directors.name];
    
    _starRatingView.value = movie.rating.average / 2;
    _ratingLabel.text = [NSString stringWithFormat:@"%.1f",movie.rating.average];
    __block NSString *castsDesc = @"主演：";
    [movie.casts enumerateObjectsUsingBlock:^(LHCast * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == movie.casts.count - 1) {
            castsDesc = [castsDesc stringByAppendingString:[NSString stringWithFormat:@"%@",obj.name]];
        }else{
            castsDesc = [castsDesc stringByAppendingString:[NSString stringWithFormat:@"%@ /",obj.name]];
        }
    }];
    _castsLabel.text = castsDesc;
    CGFloat collection = movie.collectCount < 10000 ? movie.collectCount : movie.collectCount / 10000;
    
    _collectionLabel.text = movie.collectCount < 10000 ? [NSString stringWithFormat:@"%.0f人看过",collection] :[NSString stringWithFormat:@"%.1f万人看过",collection];
}

- (void)setupUI
{
    UIImageView *iv = [UIImageView new];
    [self.contentView addSubview:iv];
    _posterView = iv;
    [_posterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(16);
        make.size.mas_offset(CGSizeMake(80, 120));
        make.bottom.equalTo(self.contentView).offset(-16);
    }];
    UILabel *title = [UILabel new];
    [self.contentView addSubview:title];
    title.font = [UIFont boldSystemFontOfSize:20];
    title.textColor = kGray_five;
    _titleLabel = title;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_posterView);
        make.left.equalTo(_posterView.mas_right).offset(16);
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
    
    UILabel *directors = [UILabel new];
    [self.contentView addSubview:directors];
    directors.font = [UIFont systemFontOfSize:12];
    directors.textColor = kGray_four;
    _directorsLabel = directors;
    [_directorsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_starRatingView.mas_bottom).offset(kMargin);
        make.left.equalTo(_titleLabel);
    }];
    
    CGFloat maxWidth = kScreenW - 4 * 16 - 100 - 60;

    UILabel *casts = [UILabel new];
    [self.contentView addSubview:casts];
    casts.numberOfLines = 3;
    casts.preferredMaxLayoutWidth = maxWidth;
    casts.font = [UIFont systemFontOfSize:12];
    casts.textColor = kGray_four;
    _castsLabel = casts;
    [_castsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_directorsLabel.mas_bottom).offset(8);
        make.left.equalTo(_titleLabel);
    }];
    
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.layer.cornerRadius = 4;
    buyBtn.layer.borderWidth = 0.5;
    buyBtn.layer.borderColor = [UIColor redColor].CGColor;
    [buyBtn setTitle:@"购票" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    buyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.contentView addSubview:buyBtn];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 25));
        make.right.equalTo(self.contentView).offset(-2 * kMargin);
        make.centerY.equalTo(self.contentView);
    }];
    
    UILabel *collection = [UILabel new];
    collection.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:collection];
    collection.font = [UIFont systemFontOfSize:12];
    collection.textColor = [UIColor redColor];
    _collectionLabel = collection;
    [_collectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(buyBtn.mas_top).offset(-kMargin);
        make.centerX.equalTo(buyBtn);
    }];
    
}

@end
