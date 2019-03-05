//
//  LHMusicCell.m
//  DoubanMovie
//
//  Created by iDog on 2019/3/5.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHMusicCell.h"
#import "LHSimpleMusic.h"
@interface LHMusicCell ()
@property (nonatomic, weak) UIImageView *posterView;
@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation LHMusicCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setCellData:(id)data
{
    _cellData = data;
    LHSimpleMusic *music = (LHSimpleMusic *)data;
    [_posterView sd_setImageWithURL:[NSURL URLWithString:music.image]];
    _titleLabel.text = music.title;
}

- (void)setupUI
{
    UIImageView *iv = [UIImageView new];
    [self.contentView addSubview:iv];
    _posterView = iv;
    [_posterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(90, 120));
    }];
    UIView *maskView = [UIView new];
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f];
    [self.contentView addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(40);
    }];
    UILabel *title = [UILabel new];
    title.backgroundColor = [UIColor clearColor];
    title.preferredMaxLayoutWidth = 70;
    title.numberOfLines = 0;
    title.font = [UIFont boldSystemFontOfSize:14];
    title.textColor = kWhite_one;
    [maskView addSubview:title];
    _titleLabel = title;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(maskView).offset(4);
        make.bottom.right.equalTo(maskView).offset(-4);
    }];
}
@end
