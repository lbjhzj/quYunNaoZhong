
//
//  SetClockViewController.m
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/8.
//  Copyright © 2016年 趣云科技. All rights reserved.
//
@import GoogleMobileAds;
#import "SetClockViewController.h"

@interface SetClockViewController ()<GADBannerViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,PassingTheClockTimeDelegate,PassingTheClockModeDelegate,PassingTheClockMusicDelegate>
{
    GADMasterViewController *shared;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic)UILabel *valueLabel;

@property (strong, nonatomic)UIImageView *clockSwitchBtn;

@property(nonatomic,strong)UIImageView * forceSwitchBtn;

@property(nonatomic,strong)UIImageView * shockSwitchBtn;




@end

@implementation SetClockViewController


static NSString *cellID_2 = @"sliderID";


+ (instancetype)sharedSetClockViewController{
   SetClockViewController *setClockViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SetClockID"];
 
    return setClockViewController;
}


#pragma mark 谷歌广告协议
- (void)adView:(GADBannerView *)bannerView didReceiveAppEvent:(NSString *)name withInfo:(NSString *)info{
    if (shared.view.tag == 1999) {
        [shared removeFromParentViewController];
        shared = [GADMasterViewController singleton];
        [shared resetAdView:self];
    }
    shared.view.tag = 1999;
}

#pragma mark 返回按键方法
- (IBAction)backToMyClockVCAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated{

    shared = [GADMasterViewController singleton];
    [shared resetAdView:self];
    
    UITableViewCell *cell1 = [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITableViewCell *cell2 = [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UITableViewCell *cell3 = [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];

    //    判断开关状态
    self.clockSwitchBtn = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-30, cell1.frame.size.height * 0.5 - 8, 16, 16)];
    _clockSwitchBtn.tag = 1000;
    
    self.forceSwitchBtn = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-30, cell2.frame.size.height * 0.5 - 8, 16, 16)];
    _forceSwitchBtn.tag = 2000;
    
    self.shockSwitchBtn = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-30, cell3.frame.size.height * 0.5 - 8, 16, 16)];
    _shockSwitchBtn.tag = 3000;
    
    if (self.Alert.clockState) {
        _clockSwitchBtn.image = [UIImage imageNamed:@"开关（开）"];
    }else{
        _clockSwitchBtn.image = [UIImage imageNamed:@"开关（关）"];
    }
    if (self.Alert.clockForce) {
        _forceSwitchBtn.image = [UIImage imageNamed:@"开关（开）"];
    }else{
        _forceSwitchBtn.image = [UIImage imageNamed:@"开关（关）"];
    }
    if (self.Alert.clockShock) {
        _shockSwitchBtn.image = [UIImage imageNamed:@"开关（开）"];
    }else{
        _shockSwitchBtn.image = [UIImage imageNamed:@"开关（关）"];
    }
//    每次进入设置页都要刷新页面内容
    [self.tableView reloadData];

#pragma mark如果是新建闹钟，那么alert属性一定为空

    if (!self.Alert) {
        self.Alert = [alert new];
        self.Alert.clockState = NO;
        self.Alert.clockForce = NO;
        self.Alert.clockShock = NO;
        self.clockNameLabel.text = @"未命名";
        self.clockTimeLabel.text = @"07:30";
        self.clockModeLabel.text = @"未设置";
        self.valueLabel.text = [NSString stringWithFormat:@"50"];
        self.clockSoundValueLabel.value = 50.0f;
        self.clockMusicLabel.text = @"未设置";
        self.clockExtendLabel.text = @"未设置";
    }else{
        if (!self.passingFlag) {
            self.clockNameLabel.text = self.Alert.clockName;
            self.clockTimeLabel.text = self.Alert.clockTime;
            self.clockModeLabel.text = self.Alert.clockMode;
            self.valueLabel.text = [NSString stringWithFormat:@"%ld",self.Alert.clockSoundValue];
            self.clockSoundValueLabel.value = self.Alert.clockSoundValue;
            self.clockMusicLabel.text = self.Alert.clockMusic;
        }
        
    }


    
    [super viewWillAppear:animated];

}

- (void)dealloc{
    setClockTimeController.delegate = nil;
    setClockModeController.delegate = nil;
    setClockMusicController.delegate = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self addViews];

    
    setClockTimeController = [[SetClockTimeController alloc]initWithNibName:@"SetClockTimeController" bundle:nil];
    setClockModeController = [[SetClockModeController alloc]initWithNibName:@"SetClockModeController" bundle:nil];
    setClockMusicController = [[SetClockMusicViewController alloc]initWithNibName:@"SetClockMusicViewController" bundle:nil];
    
    setClockTimeController.delegate = self;
    setClockModeController.delegate = self;
    setClockMusicController.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID_2];

}

- (void)addViews{

    self.clockNameLabel = [[UITextField alloc] initWithFrame:CGRectMake(150, 0, self.view.frame.size.width-150, 44)];
    self.clockTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, self.view.frame.size.width-150, 44)];
    self.clockModeLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, self.view.frame.size.width-150, 44)];
    self.clockMusicLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, self.view.frame.size.width-150, 44)];
    self.clockExtendLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, self.view.frame.size.width-150, 44)];
    self.clockSoundValueLabel = [[UISlider alloc] initWithFrame:CGRectMake(150, 0, self.view.frame.size.width-220, 44)];
    _clockSoundValueLabel.maximumValue = 100.f;
    
    [_clockSoundValueLabel addTarget:self action:@selector(soundValueChangeAction:) forControlEvents:UIControlEventValueChanged];
    
    [_clockSoundValueLabel setMinimumTrackImage:[UIImage imageNamed:@"下划线"] forState:UIControlStateNormal];
    _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50 , 0, 50, 44)];
    _valueLabel.textAlignment = NSTextAlignmentCenter;
}

#pragma mark 删除闹钟信息
- (IBAction)deleteclockData:(UIButton *)sender {
    [[HYLocalNotication shareHYLocalNotication] removeClockDataWithClockID:self.clockID];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 确认添加或修改闹钟
- (IBAction)makeSureAddOrChangeClockInformation:(UIButton *)sender {

//    数据永久化
    
        NSString *nameStr = self.clockNameLabel.text;
        self.Alert.clockName = nameStr;

        NSLog(@"111111textField=======%@",self.Alert.clockName);
    
    self.Alert.clockTime = self.clockTimeLabel.text;
    self.Alert.clockMode = self.clockModeLabel.text;
    self.Alert.clockMusic = self.clockMusicLabel.text;
    self.Alert.clockSoundValue = self.clockSoundValueLabel.value;

        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        self.clockCount = [[userDefault objectForKey:@"ClockCount"] intValue];
        if (!self.clockID) {
            if (![self.clickTheFirstOrAddBtnFlag isEqualToString:ClickTheFirstClockFlag]) {
                _clockID = _clockCount++;
                  self.Alert.clockID = [NSString stringWithFormat:@"%d",_clockID];
                [userDefault setObject:[NSNumber numberWithInt:self.clockCount] forKey:@"ClockCount"];
            }
        }
    
  
    //    NSLog(@"clockID======%d",_clockID);
    [[HYLocalNotication shareHYLocalNotication] saveClockData:self.Alert];
    
    if (self.Alert.clockState) {
        
        [[HYLocalNotication shareHYLocalNotication]startLocalNoticationClockID:self.clockID];
    }else{
        [[HYLocalNotication shareHYLocalNotication]cancelLocalNotication:self.clockID];
    }
 
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 闹钟数据永久化
//- (void)saveClockData:(alert *)Alert{
//    NSMutableDictionary *clockDictionary = [NSMutableDictionary dictionaryWithCapacity:12];
//    
//    if (Alert.clockState) {
//      [clockDictionary setObject:[NSString stringWithFormat:@"YES"] forKey:@"ClockState"];
//    }else{
//      [clockDictionary setObject:[NSString stringWithFormat:@"NO"] forKey:@"ClockState"];
//    }
//    if (Alert.clockForce) {
//        [clockDictionary setObject:@"YES" forKey:@"ClockForce"];
//    }else{
//        [clockDictionary setObject:@"NO" forKey:@"ClockForce"];
//    }
//    if (Alert.clockShock) {
//        [clockDictionary setObject:@"YES" forKey:@"ClockShock"];
//    }else{
//        [clockDictionary setObject:@"NO" forKey:@"ClockShock"];
//    }
//    [clockDictionary setObject:self.clockTimeLabel.text forKey:@"ClockTime"];
//    [clockDictionary setObject:self.clockModeLabel.text forKey:@"ClockMode"];
//    [clockDictionary setObject:self.clockNameLabel.text forKey:@"ClockName"];
//#warning music&&小睡,暂时关闭
//    [clockDictionary setObject:self.clockMusicLabel.text forKey:@"ClockMusic"];
////    [clockDictionary setObject:self.clockExtendLabel.text forKey:@"ClockExtend"];
//    [clockDictionary setObject:[NSString stringWithFormat:@"%f",self.clockSoundValueLabel.value] forKey:@"ClockSoundValue"];
//
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    self.clockCount = [[userDefault objectForKey:@"ClockCount"] intValue];
//    if (!self.clockID) {
//        if (![self.clickTheFirstOrAddBtnFlag isEqualToString:ClickTheFirstClockFlag]) {
//            _clockID = _clockCount++;
//        }
//    }
////    NSLog(@"clockID======%d",_clockID);
//    [clockDictionary setObject:[NSString stringWithFormat:@"%d",self.clockID]forKey:@"ClockID"];
//    [userDefault setObject:clockDictionary forKey:[NSString stringWithFormat:@"%d", self.clockID]];
//    
//
//    [userDefault setObject:[NSNumber numberWithInt:self.clockCount] forKey:@"ClockCount"];
//
//
//    
////    NSLog(@"%@",clockDictionary);
//    
//    
//
//}

#pragma mark SetClockMusicVC的传值协议方法
- (void)passingTheClockMusicToFront:(NSString *)musicName{
    self.clockMusicLabel.text = musicName;
    self.passingFlag = YES;
}

#pragma mark SetClockTimeVC的代理传值的协议方法
//闹钟设定时间的传值
- (void)passingClockTimeToHere:(NSString *)clockTime{
    
    self.passingFlag = YES;
    self.clockTimeLabel.text = clockTime;
}

#pragma mark SetClockModeVC的代理传值的协议方法
//闹钟循环模式
- (void)passingClockMode:(NSArray *)modeArray{
   
    modeArray = [modeArray sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:7];
    for (NSString *__strong mode in modeArray) {
        if ([mode isEqualToString:@"0"]) {
            mode = @"日";
        }else{
            mode = [NSString translation:mode];
        }
        
        [tempArray addObject:mode];
    }
    NSString *modeStr = [tempArray componentsJoinedByString:@","];
//    NSLog(@"modeStr===%@",modeStr);
    self.clockModeLabel.text = modeStr;
    self.passingFlag = YES;
}

#pragma mark 闹钟的音量设置
- (void)soundValueChangeAction:(UISlider *)sender{
    _valueLabel.text = [NSString stringWithFormat:@"%.0f",self.clockSoundValueLabel.value];
    
}

#pragma mark textField的协议内容
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}



#pragma mark tableView的协议

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     NSString *cellID = [NSString stringWithFormat:@"Cell%ld%ld", [indexPath section], (long)[indexPath row]];//以indexPath来唯一确定cell;

//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];

  UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            cell.textLabel.text = @"闹钟开关";
//            闹钟开关按键
            if (cell.contentView.subviews.count<3){
                [cell.contentView addSubview:_clockSwitchBtn];
            }
            

            
        }else if (indexPath.row == 1){
            
            cell.textLabel.text = @"强制叫醒";
//            强制叫醒开关按键
            if (cell.contentView.subviews.count<3){
                [cell.contentView addSubview:_forceSwitchBtn];
            }
            
            
        }else if (indexPath.row == 2){

            cell.textLabel.text = @"震动";
//            震动开关按键
            if (cell.contentView.subviews.count<3){
                [cell.contentView addSubview:_shockSwitchBtn];
            }
            
        }else{
//            cell.userInteractionEnabled = NO;
        }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        当用了reload方法的时候，发生视图重叠
//        if (cell.contentView.subviews.count == 3) {
//            [cell.contentView.subviews[1] removeFromSuperview];
//        }

    }else{
        if (indexPath.row == 0) {
            
            cell.textLabel.text = @"名称";
//            self.clockNameLabel = [[UITextField alloc] initWithFrame:CGRectMake(150, 0, cell.contentView.frame.size.width-150, cell.contentView.frame.size.height)];
            
            _clockNameLabel.borderStyle = UITextBorderStyleNone;
            
            _clockNameLabel.delegate = self;
            if (cell.contentView.subviews.count<3){
              [cell.contentView addSubview:self.clockNameLabel];
            }
            
//            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
        }else if (indexPath.row == 1){
 
//            if (cell.contentView.subviews.count == 3) {
//                [cell.contentView.subviews[1] removeFromSuperview];
//            }
            cell.textLabel.text = @"时间";
//            self.clockTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, cell.contentView.frame.size.width-150, cell.contentView.frame.size.height)];
            
            if (cell.contentView.subviews.count<3){
               [cell.contentView addSubview:self.clockTimeLabel];
            }
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
//             NSLog(@"========%@=======",cell.contentView.subviews);
            
        }else if (indexPath.row == 2){
            
            cell.textLabel.text = @"周期";
//            self.clockModeLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, cell.contentView.frame.size.width-150, cell.contentView.frame.size.height)];
            
            if (cell.contentView.subviews.count<3){
               [cell.contentView addSubview:self.clockModeLabel];
            }
            
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
        }else if (indexPath.row == 3){
            
            cell.textLabel.text = @"铃声";
//            self.clockMusicLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, cell.contentView.frame.size.width-150, cell.contentView.frame.size.height)];
            
            
            if (cell.contentView.subviews.count<3){
              [cell.contentView addSubview:self.clockMusicLabel];
            }
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
        }else if (indexPath.row == 4){
            
            cell.textLabel.text = @"小睡";
//            self.clockExtendLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, cell.contentView.frame.size.width-150, cell.contentView.frame.size.height)];
            
            if (cell.contentView.subviews.count<3){
               [cell.contentView addSubview:self.clockExtendLabel];
            }
            
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }else{
            

            cell.textLabel.text = @"音量";
//            self.clockSoundValueLabel = [[UISlider alloc] initWithFrame:CGRectMake(150, 0, self.view.frame.size.width-220, cell.contentView.frame.size.height)];
            

            

            
            if (cell.contentView.subviews.count<3) {
            [cell.contentView addSubview:_valueLabel];
            [cell.contentView addSubview:self.clockSoundValueLabel];
            }
            
            
        }
    }
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.clockNameLabel resignFirstResponder];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                for (UIImageView *view in cell.contentView.subviews) {
                    if (view.tag == 1000) {
                        [view removeFromSuperview];
                    }
                }
                
                if (self.Alert.clockState) {
                    
                    self.clockSwitchBtn.image = [UIImage imageNamed:@"开关（关）"];
                    
                }else{
                    
                    [self.clockSwitchBtn setImage:[UIImage imageNamed:@"开关（开）"]] ;
                    
                }
                
                [cell.contentView addSubview:_clockSwitchBtn];
                
                self.Alert.clockState = !self.Alert.clockState;
                break;
            case 1:
                for (UIImageView *view in cell.contentView.subviews) {
                    if (view.tag == 2000) {
                        [view removeFromSuperview];
                    }
                }
                
                if (self.Alert.clockForce) {
                    
                    self.forceSwitchBtn.image = [UIImage imageNamed:@"开关（关）"];
                    
                }else{
                    
                    [self.forceSwitchBtn setImage:[UIImage imageNamed:@"开关（开）"]] ;
                    
                }
                
                [cell.contentView addSubview:_forceSwitchBtn];
                
                self.Alert.clockForce = !self.Alert.clockForce;
                break;
            case 2:
                for (UIImageView *view in cell.contentView.subviews) {
                    if (view.tag == 3000) {
                        [view removeFromSuperview];
                    }
                }
                
                if (self.Alert.clockShock) {
                    
                    self.shockSwitchBtn.image = [UIImage imageNamed:@"开关（关）"];
                    
                }else{
                    
                    [self.shockSwitchBtn setImage:[UIImage imageNamed:@"开关（开）"]] ;
                    
                }
                
                [cell.contentView addSubview:_shockSwitchBtn];
                
                self.Alert.clockShock = !self.Alert.clockShock;

                break;
            default:
                break;
        }

        
    }
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                
                break;
            case 1:
                [self.navigationController pushViewController:setClockTimeController animated:YES];
                break;
            case 2:
                [self.navigationController pushViewController:setClockModeController animated:YES];
                break;
            case 3:
                [self presentViewController:setClockMusicController animated:YES completion:^{
                    
                }];
//                [self.navigationController pushViewController:setClockMusicController animated:YES];
                break;
            case 4:
                
                break;
                
            default:
                break;
        }
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }
    return 6;
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
