//
//  LHMusicList.h
//  DoubanMovie
//
//  Created by iDog on 2019/3/5.
//  Copyright © 2019 iDog. All rights reserved.
//

#import "LHModel.h"
#import "LHSimpleMusic.h"
NS_ASSUME_NONNULL_BEGIN

@interface LHMusicList : LHModel
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger start;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, strong) NSArray <LHSimpleMusic *>*musics;
@end

NS_ASSUME_NONNULL_END
