//
//  MusicDataManager.m
//  UISenior16_MusicPlayer
//
//  Created by lanou3g on 16/5/25.
//  Copyright © 2016年 ZF. All rights reserved.
//

#import "MusicDataManager.h"

static MusicDataManager *musicDataManager = nil;

@implementation MusicDataManager

+ (instancetype)shareMusicDataManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        musicDataManager = [MusicDataManager new];
        // 数组的初始化
        musicDataManager.musicArray = [NSMutableArray array];
    });
    return musicDataManager;
}

@end
