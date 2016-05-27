//
//  MusicModel.m
//  UISenior16_MusicPlayer
//
//  Created by lanou3g on 16/5/25.
//  Copyright © 2016年 ZF. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel

- (instancetype)initWithMusicName:(NSString *)musicName
                    withMusicType:(NSString *)musicType
{
    self = [super init];
    if (self) {
        self.musicName = musicName;
        self.musicType = musicType;
    }
    return self;
}

@end
