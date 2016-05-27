//
//  MusicViewController.m
//  UISenior16_MusicPlayer
//
//  Created by lanou3g on 16/5/25.
//  Copyright © 2016年 ZF. All rights reserved.
//

#import "MusicViewController.h"

// 第一步引入系统框架
#import <AVFoundation/AVFoundation.h>

#import "MusicModel.h"
#import "MusicDataManager.h"

static NSTimer *timer = nil;

@interface MusicViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    // 进行音乐播放
    AVAudioPlayer *audioPlayer;
    BOOL isPlayer; // 判断是否正在播放
}
/// 时间数组
@property (nonatomic, strong) NSMutableArray *timeArray;

/// 歌词字典
@property (nonatomic, strong) NSMutableDictionary *lyricsDict;

@end

@implementation MusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    isPlayer = YES;
    
    self.timeArray = [NSMutableArray array];
    self.lyricsDict = [NSMutableDictionary dictionary];
    
    // 经分析：具体播放那首歌曲，需要上个界面传过来
    // 初始化音乐
    [self initMusic];
    
    // 获取歌词
    [self getLyrics];
    
    // 注册cell
    [self.showLyricsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MusicCell"];
    
    // 设置歌词的代理
    self.showLyricsTableView.dataSource = self;
    self.showLyricsTableView.delegate = self;
    
//    // 判断计时器是否存在，存在就讲原来的关闭
//    if ([MusicDataManager shareMusicDataManager].timer != nil) {
//        [[MusicDataManager shareMusicDataManager].timer invalidate];
//    }
//    
//    // 设置定时器，0.1秒之后刷新，播放时间的刷新，整首播放完成后，是否进入下一首
//    [MusicDataManager shareMusicDataManager].timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(showTime) userInfo:nil repeats:YES];
    
    if (timer != nil) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(showTime) userInfo:nil repeats:YES];
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [self.timer invalidate];
//}

#pragma mark - 定时刷新所有数据
- (void)showTime
{
    // 刷新进度条的数据
    int currentHour = (int)audioPlayer.currentTime / 60;
    int currentMinute = (int)audioPlayer.currentTime % 60;
    if (currentMinute < 10) {
        self.startTimeLabel.text =  [NSString stringWithFormat:@"%d:0%d", currentHour, currentMinute];
    } else {
        self.startTimeLabel.text =  [NSString stringWithFormat:@"%d:%d", currentHour, currentMinute];
    }
    
    int durationHour = (int)audioPlayer.duration / 60;
    int durationMinute = (int)audioPlayer.duration % 60;
    if (durationMinute < 10) {
        self.endTimeLabel.text =  [NSString stringWithFormat:@"%d:0%d", durationHour, durationMinute];
    } else {
        self.endTimeLabel.text =  [NSString stringWithFormat:@"%d:%d", durationHour, durationMinute];
    }
    
    // 设置slider的value值
    self.progressSlider.value = audioPlayer.currentTime / audioPlayer.duration;
    
    // 动态显示歌词
//    [self dynamicSoundWord:audioPlayer.currentTime];
    
    
    if (self.progressSlider.value < 0.99) {
        //动态显示歌词
        [self dynamicSoundWord:audioPlayer.currentTime];
    }
    
    // 在播放完毕后，自动播放下一首
#warning bug修正：数字的比较不能太精确
    if (self.progressSlider.value > 0.999) {
        NSLog(@"%s__%d", __FUNCTION__, __LINE__);
        [self autoPlay];
    }
}

#pragma mark - 自动播放
- (void)autoPlay
{
    NSLog(@"%s__%d", __FUNCTION__, __LINE__);
    // 判断
    if (self.playIndex == [[MusicDataManager shareMusicDataManager].musicArray count] - 1) {
        self.playIndex = -1;
    }
    self.playIndex++;
    [self updatePlayerSetting];
}

#pragma mark - 动态显示歌词
- (void)dynamicSoundWord:(NSUInteger)time
{
    for (int i = 0; i < self.timeArray.count; i++) {
        
        NSArray *array = [self.timeArray[i] componentsSeparatedByString:@":"];
        // 把数组中存在的时间转换成秒
        NSUInteger currentTime = [array[0] intValue] * 60 + [array[1] intValue];
        
        if (i == [self.timeArray count] - 1) {
            // 求出最后一句歌词的时间点
            NSArray *array1 = [self.timeArray[self.timeArray.count - 1] componentsSeparatedByString:@":"];
            NSUInteger currentTime1 = [array1[0] intValue] * 60 + [array1[1] intValue];
            if (time > currentTime1) {
                // 刷新歌词界面
                [self updateLyricsTableView:i];
                break;
            }
        } else {
            // 求出歌词的时间点
            NSArray *array2 = [self.timeArray[0] componentsSeparatedByString:@":"];
            NSUInteger currentTime2 = [array2[0] intValue] * 60 + [array2[1] intValue];
            if (time < currentTime2) {
                [self updateLyricsTableView:0];
                // NSLog(@"马上到第一句");
                break;
            }
            // 求出下一步的歌词时间点，然后计算区间
            NSArray *array3 = [self.timeArray[i+1] componentsSeparatedByString:@":"];
            NSUInteger currentTime3 = [array3[0] intValue] * 60 + [array3[1] intValue];
            if (time >= currentTime && time <= currentTime3) {
                // 动态更新歌词表中的歌词
                [self updateLyricsTableView:i];
                break;
            }
        }
    }
}

#pragma mark - 动态更新歌词表中的歌词
- (void)updateLyricsTableView:(NSInteger)index
{
    // 重载tableView的
    [self.showLyricsTableView reloadData];
    
    // 如果被选中某一行，移动到相关的位置
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    // 获取选中的cell，并更改字体颜色和大小【在tableView的返回cell的方法中必须将cell的字体颜色和大小设置为非默认字体】
    UITableViewCell *cell = [self.showLyricsTableView cellForRowAtIndexPath:indexPath];
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    cell.textLabel.textColor = [UIColor purpleColor];
    
    [self.showLyricsTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

// 初始化音乐
- (void)initMusic
{
    [self setMusic];
    
    // 设置音量[最小值 最大值]
    self.volumnSlider.minimumValue = 0;
    self.volumnSlider.maximumValue = 5;
    // 设置默认的音量
    audioPlayer.volume = 0.5;
    self.volumnSlider.value = audioPlayer.volume;
    
    // 设置音量按钮的图片
    [self.volumnSlider setThumbImage:[UIImage imageNamed:@"sliderThumb_small"] forState:UIControlStateNormal];
    [self.volumnSlider setThumbImage:[UIImage imageNamed:@"soundSlider"] forState:UIControlStateHighlighted];
    // 设置进度按钮的图片
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"sliderThumb_small"] forState:UIControlStateNormal];
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"soundSlider"] forState:UIControlStateHighlighted];
}

- (void)setMusic
{
    // 获取当前音乐的model类
    MusicModel *model = [MusicDataManager shareMusicDataManager].musicArray[_playIndex];
    // 初始化音乐播放器对象
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:model.musicName ofType:model.musicType]];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
}

#pragma mark - 获取歌词
- (void)getLyrics
{
    // 获取当前音乐的model类
    MusicModel *model = [MusicDataManager shareMusicDataManager].musicArray[_playIndex];
    // 初始化音乐播放器对象
    NSString *lyricsPath = [[NSBundle mainBundle] pathForResource:model.musicName ofType:@"lrc"];
    // 编码
    NSString *lyricUTF8 = [NSString stringWithContentsOfFile:lyricsPath encoding:NSUTF8StringEncoding error:nil];
    // 以"\n"分割，最后使用数组存取
    NSArray *array = [lyricUTF8 componentsSeparatedByString:@"\n"];
    
    for (NSString *lineStr in array) {

        // 获取每一行的内容
        NSArray *lineArray = [lineStr componentsSeparatedByString:@"]"];
        
        if (lineArray.count > 1) {
            
            //取出：和.进行比较
            NSString *str1 = [lineStr substringWithRange:NSMakeRange(3, 1)];
            NSString *str2 = [lineStr substringWithRange:NSMakeRange(6, 1)];
            
            // 将时间戳作为判断条件
            if ([str1 isEqualToString:@":"] && [str2 isEqualToString:@"."]) {
//                NSLog(@"%@", lineArray[1]);
                // 获取要求时间
                NSString *timeStr = [lineArray[0] substringWithRange:NSMakeRange(1, 5)];
                
//                NSLog(@"%@", timeStr);
                
                // 将时间存入时间数组
                [self.timeArray addObject:timeStr];
                // 将歌词存入字典
                [self.lyricsDict setObject:lineArray[1] forKey:timeStr];
            }
              // 按歌词进行判断
//            if ([lineArray[1] length] > 1) {
//                
//                NSLog(@"%@", lineArray[1]);
//                // 获取要求时间
//                NSString *timeStr = [lineArray[0] substringWithRange:NSMakeRange(1, 5)];
//                
//                NSLog(@"%@", timeStr);
//                
//                // 将时间存入时间数组
//                [self.timeArray addObject:timeStr];
//                // 将歌词存入字典
//                [self.lyricsDict setObject:lineArray[1] forKey:timeStr];
//            }
        }
    }
//    [self.showLyricsTableView reloadData];
//    NSLog(@"%@ %@",self.timeArray, self.lyricsDict);
}

#pragma mark - 控制音量
- (IBAction)volumeChangeAction:(UISlider *)sender
{
    audioPlayer.volume = sender.value;
}
#pragma mark - 控制进度
- (IBAction)progressChangeAction:(UISlider *)sender
{
    audioPlayer.currentTime = self.progressSlider.value * audioPlayer.duration;
}


#pragma mark - 点击按钮
// 播放按钮的响应方法
- (IBAction)playButtonAction:(UIButton *)sender
{
    // 判断是否正在播放，然后修改相关的内容
    if (isPlayer) {
        [audioPlayer play];
        [self.playerButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        isPlayer = NO;
    } else {
        [audioPlayer pause];
        [self.playerButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        isPlayer = YES;
    }
}
// 上一首按钮的响应方法
- (IBAction)backButtonAction:(id)sender
{
    if (_playIndex == 0) {
        _playIndex = [MusicDataManager shareMusicDataManager].musicArray.count;
    }
    _playIndex--;
    
    // 更新播放器
    [self updatePlayerSetting];
}
// 下一首按钮的响应方法
- (IBAction)nextButtonAction:(UIButton *)sender
{
    if (_playIndex == [MusicDataManager shareMusicDataManager].musicArray.count - 1) {
        _playIndex = -1;
    }
    _playIndex++;
    [self updatePlayerSetting];
}

#pragma mark - 更新播放器
- (void)updatePlayerSetting
{
    // 更改播放按钮的状态
    [self.playerButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    isPlayer = YES;
    
    // 更新曲目
    [self setMusic];
    
    // 音量的重置
    audioPlayer.volume = self.volumnSlider.value;
    // 更新歌词

    self.timeArray = [NSMutableArray array];
    self.lyricsDict = [NSMutableDictionary dictionary];
    
    [self getLyrics];
    
    [audioPlayer play];
}

#pragma mark - tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.timeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MusicCell" forIndexPath:indexPath];
    
    // 设置选中样式
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.textLabel.text = [self.lyricsDict objectForKey:self.timeArray[indexPath.row]];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = [UIColor blackColor];
    
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
