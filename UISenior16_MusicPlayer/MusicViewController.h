//
//  MusicViewController.h
//  UISenior16_MusicPlayer
//
//  Created by lanou3g on 16/5/25.
//  Copyright © 2016年 ZF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicViewController : UIViewController

/// 背景图片
@property (weak, nonatomic) IBOutlet UIImageView *backGroundImageView;
/// 控制音量
@property (weak, nonatomic) IBOutlet UISlider *volumnSlider;
/// 进度
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
/// 歌词
@property (weak, nonatomic) IBOutlet UITableView *showLyricsTableView;
/// 播放按钮
@property (weak, nonatomic) IBOutlet UIButton *playerButton;
/// 上一首
@property (weak, nonatomic) IBOutlet UIButton *backButton;
/// 下一首
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
/// 开始时间
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
/// 结束时间
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
/// 记录播放的是那首歌
@property (nonatomic, assign) NSInteger playIndex;

//@property (nonatomic, strong) NSTimer *timer;

@end
