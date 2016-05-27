//
//  MusicDataManager.h
//  UISenior16_MusicPlayer
//
//  Created by lanou3g on 16/5/25.
//  Copyright © 2016年 ZF. All rights reserved.
//

#import <Foundation/Foundation.h>

// 音乐的数据管理类，主要用于实现数组的相关操作
@interface MusicDataManager : NSObject

/// 存储音乐的数组
@property (nonatomic, strong) NSMutableArray *musicArray;
/// 计时器
//@property (nonatomic, strong) NSTimer *timer;

// 单例
+ (instancetype)shareMusicDataManager;

@end
