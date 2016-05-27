//
//  MusicModel.h
//  UISenior16_MusicPlayer
//
//  Created by lanou3g on 16/5/25.
//  Copyright © 2016年 ZF. All rights reserved.
//

#import <Foundation/Foundation.h>

// 用于处理音乐数据的model
@interface MusicModel : NSObject

/// 音乐名字
@property (nonatomic, copy) NSString *musicName;

/// 音乐的类型
@property (nonatomic, copy) NSString *musicType;

- (instancetype)initWithMusicName:(NSString *)musicName
                    withMusicType:(NSString *)musicType;

@end
