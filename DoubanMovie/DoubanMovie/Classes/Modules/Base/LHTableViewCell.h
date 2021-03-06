//
//  LHTableViewCell.h
//  DoubanMovie
//
//  Created by iDog on 2019/2/27.
//  Copyright © 2019 iDog. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LHTableViewCell : UITableViewCell

/// 记录下标
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) id cellData;

- (void)setupUI;

@end

NS_ASSUME_NONNULL_END
