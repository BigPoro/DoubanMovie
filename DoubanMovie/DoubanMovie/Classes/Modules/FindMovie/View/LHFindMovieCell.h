//
//  LHFindMovieCell.h
//  DoubanMovie
//
//  Created by iDog on 2019/3/2.
//  Copyright © 2019 iDog. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LHFindMovieCell : UICollectionViewCell
/// 记录下标
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) id cellData;

@end

NS_ASSUME_NONNULL_END
