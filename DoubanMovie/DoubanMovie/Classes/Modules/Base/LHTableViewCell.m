//
//  LHTableViewCell.m
//  DoubanMovie
//
//  Created by iDog on 2019/2/27.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHTableViewCell.h"

@implementation LHTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        self.selectionStyle = UITableViewCellAccessoryNone;
    }
    
    return self;
}

- (void)setupUI
{
    
}
- (void)setCellData:(id)data
{
    
}



@end
