//
//  SetClockMusicViewController.m
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/14.
//  Copyright © 2016年 趣云科技. All rights reserved.
//

#import "SetClockMusicViewController.h"


@interface SetClockMusicViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIImageView *ringBtnUnderLine;

@property (weak, nonatomic) IBOutlet UIImageView *recordBtnUnderLine;

@property (weak, nonatomic) IBOutlet UIImageView *musicLibraryBtnUnderLine;

//@property(nonatomic,assign)BOOL  isOpen;
//
//@property(nonatomic,retain)NSIndexPath * selectIndex;

@property(nonatomic,strong)NSMutableArray * musicList;

@property(nonatomic,strong)NSMutableArray * mengMengRingArray;

@property(nonatomic,strong)AVAudioPlayer * player;

@property(nonatomic,weak)NSString * selectedMusicName;


@end

@implementation SetClockMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:@"ringCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
    [self.tableView registerNib:[UINib nibWithNibName:@"sectionCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
//    self.isOpen = NO;
    
    NSArray *fileName = [HYLocalNotication getFilenamelistOfType:@"mp3" fromDirPath:[NSBundle mainBundle].resourcePath ];
    NSInteger count = fileName.count;
//    NSLog(@"I have %ld musics in DocumentsDir",count);
    for (int i = 0; i<count; i++) {
//        NSLog(@"NO.%d is %@",i+1,[fileName objectAtIndex:i]);
        NSString *musicName = [[fileName objectAtIndex:i]componentsSeparatedByString:@".mp3"][0] ;
        if ([[fileName objectAtIndex:i] hasSuffix:@").mp3"]) {
        [self.mengMengRingArray addObject:musicName];
        }else{
         [self.musicList addObject:musicName];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 返回上级设置
- (IBAction)backToSetViewControllerAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.player stop];
}

#pragma mark 确认更改音乐铃声
- (IBAction)makeSureChangeAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(passingTheClockMusicToFront:)]) {
        [self.delegate passingTheClockMusicToFront:self.selectedMusicName];
    }
    
    [self.player stop];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)ringBtnAction:(UIButton *)sender {
    self.ringBtnUnderLine.hidden = !self.ringBtnUnderLine.hidden;
    self.musicLibraryBtnUnderLine.hidden = YES;
    self.recordBtnUnderLine.hidden = YES;
}

- (IBAction)musicLibraryBtnAction:(UIButton *)sender {
    self.musicLibraryBtnUnderLine.hidden = !self.musicLibraryBtnUnderLine.hidden;
    self.ringBtnUnderLine.hidden = YES;
    self.recordBtnUnderLine.hidden = YES;
}

- (IBAction)recordBtnAction:(UIButton *)sender {
    self.recordBtnUnderLine.hidden = !self.recordBtnUnderLine.hidden;
    self.musicLibraryBtnUnderLine.hidden = YES;
    self.ringBtnUnderLine.hidden = YES;
}

#pragma mark tableView的协议方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.isOpen&&self.selectIndex.section == indexPath.section&&indexPath.row!=0) {
//        static NSString *cellID2 = @"cell2";
//        ringCell *cell = (ringCell *)[tableView dequeueReusableCellWithIdentifier:cellID2];
//        if (!cell) {
//            cell = [[[NSBundle mainBundle] loadNibNamed:@"ringCell" owner:self options:nil]objectAtIndex:0];
//        }
//        cell.textLabel.text = [self.musicList objectAtIndex:indexPath.row-1];
//        return cell;
//    }else{
//    static NSString *cellID1 = @"cell1";
//        sectionCell *cell = (sectionCell *)[tableView dequeueReusableCellWithIdentifier:cellID1];
//        if (!cell) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"sectionCell" owner:self options:nil] objectAtIndex:0];
//        }
//        if (indexPath.section == 0) {
//            cell.textLabel.text = @"段铃音";
//        }else{
//            cell.textLabel.text = @"铃音";
//        }
//        
//    return cell;  
//    }
    if (indexPath.row == 0) {
        static NSString *cell1 = @"cell1";
        sectionCell *cell = [tableView dequeueReusableCellWithIdentifier:cell1];
        cell.backgroundColor = [UIColor lightTextColor];
        if (indexPath.section == 0) {
          cell.textLabel.text = @"萌萌的铃声";
        }else{
            cell.textLabel.text = @"纯音乐";
        }
        return cell;
    }else{
        static NSString *cell2 = @"cell2";
        ringCell *cell = [tableView dequeueReusableCellWithIdentifier:cell2];
        if (indexPath.section == 0) {
          cell.textLabel.text = self.mengMengRingArray[indexPath.row-1];
        }else{
            cell.textLabel.text = self.musicList[indexPath.row - 1];
        }
       
        return cell;
    }
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *soundFilePath ;
    
    NSURL *fileURL ;
    
    if (indexPath.section == 0) {
     
        soundFilePath = [[NSBundle mainBundle] pathForResource:self.mengMengRingArray[indexPath.row-1] ofType:@"mp3"];
        
       fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath];
        
        self.selectedMusicName = self.mengMengRingArray[indexPath.row-1];

    }else{

        soundFilePath = [[NSBundle mainBundle] pathForResource:self.musicList[indexPath.row-1] ofType:@"mp3"];
        
        fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath];
        self.selectedMusicName = self.musicList[indexPath.row-1];

    }

    self.player=[[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    [_player prepareToPlay];
    _player.volume = 0.8;
    [_player play];
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 0) {
//        if ([indexPath isEqual:self.selectIndex]) {
//            self.isOpen = NO;
//            [self didSelectCellRowFirstDo:NO nextDo:NO];
//            self.selectIndex = nil;
//            
//        }else
//        {
//            if (!self.selectIndex) {
//                self.selectIndex = indexPath;
//                [self didSelectCellRowFirstDo:YES nextDo:NO];
//                
//            }else
//            {
//                
//                [self didSelectCellRowFirstDo:NO nextDo:YES];
//            }
//        }
//        
//    }else
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"success" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil] ;
//        [alert show];
//    }
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

//- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert
//{
//    self.isOpen = firstDoInsert;
//  
//    
//    [self.tableView beginUpdates];
//    
//    int section = (short)self.selectIndex.section;
//    int contentCount = (short)[self.musicList count];
//    NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
//    for (NSUInteger i = 1; i < contentCount + 1; i++) {
//        NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
//        [rowToInsert addObject:indexPathToInsert];
//    }
//    
//    if (firstDoInsert)
//    {   [self.tableView insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
//    }
//    else
//    {
//        [self.tableView deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
//    }
//    
//    [self.tableView endUpdates];
//    if (nextDoInsert) {
//        self.isOpen = YES;
//        self.selectIndex = [self.tableView indexPathForSelectedRow];
//        [self didSelectCellRowFirstDo:YES nextDo:NO];
//    }
//    if (self.isOpen) [self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
      return self.mengMengRingArray.count;
    }else{
        return self.musicList.count;
    }
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (self.isOpen) {
//        if (self.selectIndex.section == section) {
//            return [self.musicList count]+1;
//        }
//    }
//    return 1;
//}


- (NSMutableArray *)musicList{
    if (_musicList == nil) {
        _musicList = [NSMutableArray arrayWithCapacity:6];
    }
    return _musicList;
}

- (NSMutableArray *)mengMengRingArray{
    if (_mengMengRingArray == nil) {
        _mengMengRingArray = [NSMutableArray arrayWithCapacity:6];
    }
    return _mengMengRingArray;
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
