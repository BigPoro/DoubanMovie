//
//  LHComingSoonCell.m
//  DoubanMovie
//
//  Created by iDog on 2019/2/28.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHComingSoonCell.h"

#import "LHSimpleMovie.h"

@interface LHComingSoonCell ()

@property (nonatomic, weak) UIImageView *posterView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *directorsLabel;
@property (nonatomic, weak) UILabel *castsLabel;
@property (nonatomic, weak) UILabel *collectionLabel;

@end

@implementation LHComingSoonCell


- (void)setCellData:(id)data
{
    [super setCellData:data];

    LHSimpleMovie *movie = (LHSimpleMovie *)data;
    [_posterView sd_setImageWithURL:[NSURL URLWithString:movie.images.small]];
    _titleLabel.text = movie.title;
    LHCast *directors = movie.directors.firstObject;
    _directorsLabel.text = [@"导演：" stringByAppendingString:directors.name];
    
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
    
    _collectionLabel.text = movie.collectCount < 10000 ? [NSString stringWithFormat:@"%.0f人想看",collection] :[NSString stringWithFormat:@"%.1f万人想看",collection];
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
    
    UILabel *directors = [UILabel new];
    [self.contentView addSubview:directors];
    directors.font = [UIFont systemFontOfSize:12];
    directors.textColor = kGray_four;
    _directorsLabel = directors;
    [_directorsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(kMargin);
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
    buyBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    [buyBtn setTitle:@"想看" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
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
    collection.textColor = [UIColor orangeColor];
    _collectionLabel = collection;
    [_collectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(buyBtn.mas_top).offset(-kMargin);
        make.centerX.equalTo(buyBtn);
    }];
    
}
@end

