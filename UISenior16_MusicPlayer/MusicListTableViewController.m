//
//  MusicListTableViewController.m
//  UISenior16_MusicPlayer
//
//  Created by lanou3g on 16/5/25.
//  Copyright © 2016年 ZF. All rights reserved.
//

#import "MusicListTableViewController.h"

#import "MusicModel.h"
#import "MusicDataManager.h"
#import "MusicViewController.h"

@interface MusicListTableViewController ()

@end

@implementation MusicListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MusicListCell"];
}

#pragma mark - 初始化数据
- (void)initData
{
    MusicModel *musicModel1 = [[MusicModel alloc] initWithMusicName:@"情非得已" withMusicType:@"mp3"];
    MusicModel *musicModel2 = [[MusicModel alloc] initWithMusicName:@"林俊杰-背对背拥抱" withMusicType:@"mp3"];
    MusicModel *musicModel3 = [[MusicModel alloc] initWithMusicName:@"梁静茹-偶阵雨" withMusicType:@"mp3"];
    
    // 将音乐model对象存入数组中
    NSArray *array = @[musicModel1, musicModel2, musicModel3];
    [[MusicDataManager shareMusicDataManager].musicArray addObjectsFromArray:array];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [MusicDataManager shareMusicDataManager].musicArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MusicListCell" forIndexPath:indexPath];
    
    MusicModel *model = [MusicDataManager shareMusicDataManager].musicArray[indexPath.row];
    
    cell.textLabel.text = model.musicName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicViewController *musicVC = [MusicViewController new];
    
    musicVC.playIndex = indexPath.row;
    
    [self.navigationController pushViewController:musicVC animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
