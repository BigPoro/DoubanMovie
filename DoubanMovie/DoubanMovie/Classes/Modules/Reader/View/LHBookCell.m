//
//  LHBookCell.m
//  DoubanMovie
//
//  Created by iDog on 2019/3/4.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHBookCell.h"
#import "LHSimpleBook.h"

@interface LHBookCell ()
@property (nonatomic, weak) UIImageView *posterView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *authorLabel;
@property (nonatomic, weak) UILabel *descLabel;
@end
@implementation LHBookCell

- (void)setCellData:(id)cellData
{
    [super setCellData:cellData];
    LHSimpleBook *book = (LHSimpleBook *)cellData;
    [_posterView sd_setImageWithURL:[NSURL URLWithString:book.images.small]];
     _titleLabel.text = book.title;
    __block NSString *author = @"";
    [book.author enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == book.author.count - 1) {
            author = [author stringByAppendingString:obj];
        }else{
            author = [author stringByAppendingString:[NSString stringWithFormat:@"%@ /",obj]];
        }
    }];
    _authorLabel.text = author;
    _descLabel.text = book.summary;
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
    title.font = [UIFont boldSystemFontOfSize:18];
    title.textColor = kGray_five;
    _titleLabel = title;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_posterView);
        make.left.equalTo(_posterView.mas_right).offset(16);
        make.right.equalTo(self.contentView).offset(-16);
    }];
    
    UILabel *author = [UILabel new];
    [self.contentView addSubview:author];
    author.font = [UIFont systemFontOfSize:14];
    author.textColor = kGray_four;
    _authorLabel = author;
    [_authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(4);
        make.left.equalTo(_titleLabel);
        make.right.equalTo(self.contentView).offset(-16);

    }];
    CGFloat width = kScreenW - 6 * kMargin - 80;
    UILabel *desc = [UILabel new];
    [self.contentView addSubview:desc];
    desc.preferredMaxLayoutWidth = width;
    desc.numberOfLines = 4;
    desc.font = [UIFont systemFontOfSize:16];
    desc.textColor = kGray_five;
    _descLabel = desc;
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_authorLabel.mas_bottom).offset(4);
        make.left.equalTo(_titleLabel);
    }];
}
@end
