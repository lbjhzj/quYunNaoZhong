
//
//  SetClockViewController.m
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/8.
//  Copyright © 2016年 趣云科技. All rights reserved.
//
@import GoogleMobileAds;
#import "SetClockViewController.h"

@interface SetClockViewController ()<UITableViewDataSource,UITableViewDelegate,PassingTheClockTimeDelegate,UITextFieldDelegate,PassingTheClockModeDelegate>

@property (weak, nonatomic) IBOutlet GADBannerView *admodBannerView;

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



#pragma mark 返回按键方法
- (IBAction)backToMyClockVCAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
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
    if (self.Alert.clockForce) {
        _shockSwitchBtn.image = [UIImage imageNamed:@"开关（开）"];
    }else{
        _shockSwitchBtn.image = [UIImage imageNamed:@"开关（关）"];
    }
    [self.tableView reloadData];
//    [cell1.contentView addSubview:_clockSwitchBtn];
//    [cell2.contentView addSubview:_forceSwitchBtn];
//    [cell3.contentView addSubview:_shockSwitchBtn];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
#pragma mark 如果是新建闹钟，那么alert属性一定为空
    if (!self.Alert) {
        self.Alert = [alert new];
        self.Alert.clockState = NO;
        self.Alert.clockForce = NO;
        self.Alert.clockShock = NO;
    }
    
    setClockTimeController = [[SetClockTimeController alloc]initWithNibName:@"SetClockTimeController" bundle:nil];
    setClockModeController = [[SetClockModeController alloc]initWithNibName:@"SetClockModeController" bundle:nil];
    
    setClockTimeController.delegate = self;
    setClockModeController.delegate = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID_2];
    
    // Replace this ad unit ID with your own ad unit ID.
    self.admodBannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
    self.admodBannerView.rootViewController = self;
   
    GADRequest *request = [GADRequest request];
    // Requests test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made. GADBannerView automatically returns test ads when running on a
    // simulator.
    request.testDevices = @[
                                @"5ff659b7225c70aee936a20c4c6236ad"  // Eric's iPod Touch
                        ];
    [self.admodBannerView loadRequest:request];
    
    [self addViews];

}

- (void)addViews{
    self.clockNameLabel = [[UITextField alloc] initWithFrame:CGRectMake(150, 0, self.view.frame.size.width-150, 44)];
    self.clockTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, self.view.frame.size.width-150, 44)];
    self.clockModeLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, self.view.frame.size.width-150, 44)];
    self.clockMusicLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, self.view.frame.size.width-150, 44)];
    self.clockExtendLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, self.view.frame.size.width-150, 44)];
    self.clockSoundValueLabel = [[UISlider alloc] initWithFrame:CGRectMake(150, 0, self.view.frame.size.width-220, 44)];
    
}


#pragma mark 确认添加或修改闹钟
- (IBAction)makeSureAddOrChangeClockInformation:(UIButton *)sender {

    if (self.Alert.clockState) {
        
//        [[HYLocalNotication shareHYLocalNotication] cancelLocalNotication:[self.Alert.clockID intValue]];
    }else{
        
    }
    
    [self saveClockData];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 闹钟数据永久化
- (void)saveClockData{
    NSMutableDictionary *clockDictionary = [NSMutableDictionary dictionaryWithCapacity:12];
    
    if (self.Alert.clockState) {
      [clockDictionary setObject:[NSString stringWithFormat:@"YES"] forKey:@"ClockState"];
    }else{
      [clockDictionary setObject:[NSString stringWithFormat:@"NO"] forKey:@"ClockState"];
    }
    if (self.Alert.clockForce) {
        [clockDictionary setObject:@"YES" forKey:@"ClockForce"];
    }else{
        [clockDictionary setObject:@"NO" forKey:@"ClockForce"];
    }
    if (self.Alert.clockShock) {
        [clockDictionary setObject:@"YES" forKey:@"ClockShock"];
    }else{
        [clockDictionary setObject:@"NO" forKey:@"ClockShock"];
    }
    [clockDictionary setObject:self.clockTimeLabel.text forKey:@"ClockTime"];
    [clockDictionary setObject:self.clockModeLabel.text forKey:@"ClockMode"];
    [clockDictionary setObject:self.clockNameLabel.text forKey:@"ClockName"];
#warning music暂时，小睡关闭
//    [clockDictionary setObject:self.clockMusicLabel.text forKey:@"ClockMusic"];
//    [clockDictionary setObject:self.clockExtendLabel.text forKey:@"ClockExtend"];
    [clockDictionary setObject:[NSString stringWithFormat:@"%.0f",self.clockSoundValueLabel.value] forKey:@"ClockMusic"];

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    self.clockCount = [[userDefault objectForKey:@"ClockCount"] intValue];
    if (!self.clockID) {
        _clockID = _clockCount++;
    }
    NSLog(@"clockID======%d",_clockID);
    
    [userDefault setObject:clockDictionary forKey:[NSString stringWithFormat:@"%d", self.clockID]];
    

    [userDefault setObject:[NSNumber numberWithInt:self.clockCount] forKey:@"ClockCount"];
    

    
    NSLog(@"%@",clockDictionary);
    
    

}

#pragma mark SetClockTimeVC的代理传值的协议方法
//闹钟设定时间的传值
- (void)passingClockTimeToHere:(NSString *)clockTime{
    

    self.clockTimeLabel.text = clockTime;
}

#pragma mark SetClockModeVC的代理传值的协议方法
//闹钟循环模式
- (void)passingClockMode:(NSArray *)modeArray{
   
    modeArray = [modeArray sortedArrayUsingSelector:@selector(compare:)];
    
    
    NSString *modeStr = [modeArray componentsJoinedByString:@","];
    
    self.clockModeLabel.text = modeStr;
    
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
    
//    self.clockSwitchBtn = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-30, cell.frame.size.height * 0.5 - 8, 16, 16)];
//    判断开关状态
//    if (self.Alert.clockState) {
//        _clockSwitchBtn.image = [UIImage imageNamed:@"开关（开）"];
//    }else{
//        _clockSwitchBtn.image = [UIImage imageNamed:@"开关（关）"];
//    }
//    _clockSwitchBtn.tag = 1000;
//    
//    self.forceSwitchBtn = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-30, cell.frame.size.height * 0.5 - 8, 16, 16)];
//    if (self.Alert.clockForce) {
//        _forceSwitchBtn.image = [UIImage imageNamed:@"开关（开）"];
//    }else{
//        _forceSwitchBtn.image = [UIImage imageNamed:@"开关（关）"];
//    }
//    _forceSwitchBtn.tag = 2000;
    
    
//    self.shockSwitchBtn = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-30, cell.frame.size.height * 0.5 - 8, 16, 16)];
//    if (self.Alert.clockForce) {
//        _shockSwitchBtn.image = [UIImage imageNamed:@"开关（开）"];
//    }else{
//        _shockSwitchBtn.image = [UIImage imageNamed:@"开关（关）"];
//    }
//    _shockSwitchBtn.tag = 3000;
    
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
            self.clockNameLabel = [[UITextField alloc] initWithFrame:CGRectMake(150, 0, cell.contentView.frame.size.width-150, cell.contentView.frame.size.height)];
            
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
            
            _clockSoundValueLabel.maximumValue = 100.f;
            
            [_clockSoundValueLabel addTarget:self action:@selector(soundValueChangeAction:) forControlEvents:UIControlEventValueChanged];
            
            [_clockSoundValueLabel setMinimumTrackImage:[UIImage imageNamed:@"下划线"] forState:UIControlStateNormal];
            
            _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50 , 0, 50, cell.contentView.frame.size.height)];
            _valueLabel.textAlignment = NSTextAlignmentCenter;
            _valueLabel.text = [NSString stringWithFormat:@"%.0f",self.clockSoundValueLabel.value];
            
            if (cell.contentView.subviews.count<3) {
            [cell.contentView addSubview:_valueLabel];
            [cell.contentView addSubview:self.clockSoundValueLabel];
            }
            
            
        }
    }
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    NSLog(@"section == %ld  row == %ld",indexPath.section,indexPath.row);
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
                
                break;
            case 2:
                
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
