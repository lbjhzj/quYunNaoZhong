//
//  SetClockMusicViewController.m
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/14.
//  Copyright © 2016年 趣云科技. All rights reserved.
//

#import "SetClockMusicViewController.h"


@interface SetClockMusicViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    GADMasterViewController *shared;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIImageView *ringBtnUnderLine;

@property (weak, nonatomic) IBOutlet UIImageView *recordBtnUnderLine;

@property (weak, nonatomic) IBOutlet UIImageView *musicLibraryBtnUnderLine;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property(nonatomic,strong)UIView * recordView;


@property (weak, nonatomic) IBOutlet UILabel *recordTimeDurationLabel;

@property(nonatomic,strong)NSMutableArray * musicList;

@property(nonatomic,strong)NSMutableArray * mengMengRingArray;

@property(nonatomic,strong)AVAudioPlayer * player;




@property(nonatomic,weak)NSString * selectedMusicName;


@end

@implementation SetClockMusicViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    shared = [GADMasterViewController singleton];
    [shared resetAdView:self];
}

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
    
//    关于录音模块的设置
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        //7.0第一次运行会提示，是否允许使用麦克风
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *sessionError;
        //AVAudioSessionCategoryPlayAndRecord用于录音和播放
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        if(session == nil)
            NSLog(@"Error creating session: %@", [sessionError description]);
        else
            [session setActive:YES error:nil];
    }
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    playName = [NSString stringWithFormat:@"%@/play.aac",docDir];
    //录音设置
    recorderSettingsDict =[[NSDictionary alloc] initWithObjectsAndKeys:
                           [NSNumber numberWithInt:kAudioFormatMPEG4AAC],AVFormatIDKey,
                           [NSNumber numberWithInt:1000.0],AVSampleRateKey,
                           [NSNumber numberWithInt:2],AVNumberOfChannelsKey,
                           [NSNumber numberWithInt:8],AVLinearPCMBitDepthKey,
                           [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                           [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                           nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 返回上级设置
- (IBAction)backToSetViewControllerAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
       [self.player stop];
    }];
    
}

#pragma mark 确认更改音乐铃声
- (IBAction)makeSureChangeAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(passingTheClockMusicToFront:)]) {
        [self.delegate passingTheClockMusicToFront:self.selectedMusicName];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self.player stop];
    }];
}

- (IBAction)ringBtnAction:(UIButton *)sender {
    
    if (self.ringBtnUnderLine.hidden) {
       self.ringBtnUnderLine.hidden = !self.ringBtnUnderLine.hidden;
    }
    
    self.musicLibraryBtnUnderLine.hidden = YES;
    self.recordBtnUnderLine.hidden = YES;
    [self.recordView removeFromSuperview];
}

- (IBAction)musicLibraryBtnAction:(UIButton *)sender {
    
    if (self.musicLibraryBtnUnderLine.hidden) {
        self.musicLibraryBtnUnderLine.hidden = !self.musicLibraryBtnUnderLine.hidden;
    }
    
    self.ringBtnUnderLine.hidden = YES;
    self.recordBtnUnderLine.hidden = YES;
}

- (IBAction)recordBtnAction:(UIButton *)sender {
    [self.player stop];
    


    if (self.recordBtnUnderLine.hidden) {
        self.recordBtnUnderLine.hidden = !self.recordBtnUnderLine.hidden;
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"recordView" owner:self options:nil];
        self.recordView = [nib objectAtIndex:0];
        _recordView.frame=CGRectMake(0, 79, self.view.frame.size.width, self.view.frame.size.height-50-79);

        [self.view addSubview:_recordView];
        
    }
    self.musicLibraryBtnUnderLine.hidden = YES;
    self.ringBtnUnderLine.hidden = YES;
    

}
#pragma mark 开始或停止录音
- (IBAction)stopRecordAction:(UIButton *)sender {
    //松开 结束录音
    NSLog(@"松开");
    //录音停止
    [recorder stop];
    recorder = nil;
    //结束定时器
    [timer invalidate];
    timer = nil;
    
    NSArray *array = [HYLocalNotication getFilenamelistOfType:@"aac" fromDirPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
    NSLog(@"%@",array);
    
}

- (IBAction)startRecordAction:(UIButton *)sender {
    NSLog(@"开始");
    //按下录音
    if ([self canRecord]) {
        
        NSError *error = nil;
        //必须真机上测试,模拟器上可能会崩溃
        recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:playName] settings:recorderSettingsDict error:&error];

        if (recorder) {
            recorder.meteringEnabled = YES;
            [recorder prepareToRecord];
            [recorder record];
            
            //启动定时器
            timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(levelTimer:) userInfo:nil repeats:YES];
            
        } else
        {
            int errorCode = CFSwapInt32HostToBig ([error code]);
            NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode);
            
        }
    }

}
- (IBAction)stopRecordActionTooAction:(UIButton *)sender {
    NSLog(@"照样算松开");
    //松开 结束录音
    
    //录音停止
    [recorder stop];
    recorder = nil;
    //结束定时器
    [timer invalidate];
    timer = nil;
}

#pragma mark tableView的协议方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

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
#pragma mark 判断是否允许使用麦克风7.0新增的方法requestRecordPermission
-(BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    bCanRecord = YES;
                }
                else {
                    bCanRecord = NO;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[UIAlertView alloc] initWithTitle:nil
                                                    message:@"app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风"
                                                   delegate:nil
                                          cancelButtonTitle:@"关闭"
                                          otherButtonTitles:nil] show];
                    });
                }
            }];
        }
    }
    
    return bCanRecord;
}
-(void)levelTimer:(NSTimer*)timer_
{
    //call to refresh meter values刷新平均和峰值功率,此计数是以对数刻度计量的,-160表示完全安静，0表示最大输入值
    [recorder updateMeters];
    const double ALPHA = 0.05;
    double peakPowerForChannel = pow(10, (0.05 * [recorder peakPowerForChannel:0]));
    lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults;
    
    NSLog(@"Average input: %f Peak input: %f Low pass results: %f", [recorder averagePowerForChannel:0], [recorder peakPowerForChannel:0], lowPassResults);
    
    
}


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
