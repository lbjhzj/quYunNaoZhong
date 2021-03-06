
//
//  SetClockViewController.m
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/8.
//  Copyright © 2016年 趣云科技. All rights reserved.
//
@import GoogleMobileAds;
#import "SetClockViewController.h"

@interface SetClockViewController ()<GADBannerViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,PassingTheClockTimeDelegate,PassingTheClockModeDelegate,PassingTheClockMusicDelegate,passingSelectedClockExtendToHere>
{
    GADMasterViewController *shared;
    int SetNoClockModeAlertCount;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic)UILabel *valueLabel;

@property (strong, nonatomic)UIImageView *clockSwitchBtn;

@property(nonatomic,strong)UIImageView * forceSwitchBtn;

@property(nonatomic,strong)UIImageView * shockSwitchBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrainsOfAdViewHeight;

@property (weak, nonatomic) IBOutlet UIButton *deletButton;


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

    //    去广告
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ((!shared.adBanner_&&shared)||[userDefault objectForKey:@"enable_rocket_car"]) {

        self.constrainsOfAdViewHeight.constant = 0;
    }else{
    shared = [GADMasterViewController singleton];
    [shared resetAdView:self]; 
    }
    if (![self.clickTheFirstOrAddBtnFlag isEqualToString:ClickTheFirstClockFlag]) {
//        [self.deletButton setUserInteractionEnabled:NO];
        [self.deletButton setEnabled:NO];
        
    }else{
//        [self.deletButton setUserInteractionEnabled:YES];
        [self.deletButton setEnabled:YES];

    }
    
    UITableViewCell *cell1 = [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITableViewCell *cell2 = [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];


    //    判断开关状态
    self.clockSwitchBtn = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-30, cell1.frame.size.height * 0.5 - 8, 16, 16)];
    _clockSwitchBtn.tag = 1000;
    
    self.forceSwitchBtn = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-30, cell2.frame.size.height * 0.5 - 8, 16, 16)];
    _forceSwitchBtn.tag = 2000;
    

 
    NSString *fitPeople = [userDefault objectForKey:@"ClockFitPeople"];
    if (self.Alert.clockType) {
        int biggerCount=0;
        int smallerCount = 0;
        int index = 0;
        int noClockModeAlertCount=0;
        int clockTodayCount = 0;
        for (int x=0; x<50; x++) {
            if ([userDefault objectForKey:[NSString stringWithFormat:@"%d",x]]) {
                if (x>self.clockID) {
                    biggerCount++;
                }else{
                    smallerCount++;
                }
            }
        }
        for (NSInteger y=0; y<50; y++) {
            alert *testAlert = [[HYLocalNotication shareHYLocalNotication]findClockOfAllAlertsByIndexPath:[NSIndexPath indexPathForRow:y inSection:0]];
            if (!testAlert.clockTime) {
                continue;
            }
            
            NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
            //        检测本机语言
            NSArray* languages = [defs objectForKey:@"AppleLanguages"];
            NSString* preferredLang = [languages objectAtIndex:0];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy/MM/dd (ccc)"];
            NSString *dateMode=[NSString stringFromDate:[NSDate date] ByFormatter:formatter];
            if ([preferredLang containsString:@"en"]) {
                            if (![[HYLocalNotication shareHYLocalNotication]ifTheClockDateIsCurrentDateInEnglishLanguage:testAlert.clockMode]) {
                                noClockModeAlertCount++;
                            }
            }else{
                if (![testAlert.clockMode containsString:[(NSString *)([dateMode componentsSeparatedByString:@"周"][1]) componentsSeparatedByString:@")"][0]]) {
                noClockModeAlertCount++;
                }else{
                    clockTodayCount++;
                }
        }
    }
        
        SetNoClockModeAlertCount = noClockModeAlertCount;
        if ([self.fromMainOrMyVCFlag isEqualToString:FromMainVC]) {
            index = self.clockID  - smallerCount +noClockModeAlertCount;
        }else{
            index = self.clockID  - smallerCount-clockTodayCount-noClockModeAlertCount;
        }
        NSArray *ttmpArray = [[HYLocalNotication shareHYLocalNotication]findClockOfDefaultPlist:fitPeople];
        NSDictionary *ttmpDictionary = ttmpArray[index];
        struct utsname systemInfo;
        NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
        if ([deviceString isEqualToString:@"iphone 4,1"]) {
            [self.Alert setValuesForKeysWithDictionary:ttmpDictionary];
        }else {
            self.Alert.clockTime = [ttmpDictionary objectForKey:@"ClockTime"];
            self.Alert.clockMode = [ttmpDictionary objectForKey:@"ClockMode"];
            self.Alert.clockMusic = [ttmpDictionary objectForKey:@"ClockMusic"];
            self.Alert.clockForce = [[ttmpDictionary objectForKey:@"ClockForce"] boolValue];
            self.Alert.clockRemember = [ttmpDictionary objectForKey:@"ClockRemember"];
            self.Alert.clockExtend = [ttmpDictionary objectForKey:@"ClockExtend"];
            self.Alert.clockType = [ttmpDictionary objectForKey:@"ClockType"];
            self.Alert.clockName = [ttmpDictionary objectForKey:@"ClockName"];
 
        }
        
        
        
    }else{
       NSDictionary *dict = [userDefault objectForKey:[NSString stringWithFormat:@"%d",self.clockID]];
        struct utsname systemInfo;
        NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
        if ([deviceString isEqualToString:@"iphone 4,1"]) {
            [self.Alert setValuesForKeysWithDictionary:dict];
        }else {
            self.Alert.clockTime = [dict objectForKey:@"ClockTime"];
            self.Alert.clockMode = [dict objectForKey:@"ClockMode"];
            self.Alert.clockMusic = [dict objectForKey:@"ClockMusic"];
            self.Alert.clockForce = [[dict objectForKey:@"ClockForce"] boolValue];
            self.Alert.clockRemember = [dict objectForKey:@"ClockRemember"];
            self.Alert.clockExtend = [dict objectForKey:@"ClockExtend"];
            self.Alert.clockType = [dict objectForKey:@"ClockType"];
            self.Alert.clockName = [dict objectForKey:@"ClockName"];
            
        }

        
    }
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
            self.clockExtendLabel.text = self.Alert.clockExtend;
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
    setClockExtendViewController = [[SetClockExtendViewController alloc]initWithNibName:@"SetClockExtendViewController" bundle:nil];
    
    setClockExtendViewController.delegate = self;
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

    if (self.Alert.clockType) {
        [[HYLocalNotication shareHYLocalNotication]removeDefaultClockDataInDocument:self.Alert];
    }else{
        [[HYLocalNotication shareHYLocalNotication] removeClockDataWithClockID:self.clockID];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 确认添加或修改闹钟
- (IBAction)makeSureAddOrChangeClockInformation:(UIButton *)sender {

//    数据永久化
    
        NSString *nameStr = self.clockNameLabel.text;
        self.Alert.clockName = nameStr;
    
    self.Alert.clockTime = self.clockTimeLabel.text;
    
    if ([self.clockModeLabel.text containsString:@"未设置"]||![self.clockModeLabel.text length]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"注意" message:@"您还未设置闹钟周期呦！\n它是多余滴..." delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];
    }
    self.Alert.clockMode = self.clockModeLabel.text;
    self.Alert.clockMusic = self.clockMusicLabel.text;
    self.Alert.clockSoundValue = self.clockSoundValueLabel.value;
    if (self.Alert.clockForce) {
        self.Alert.clockExtend = @"关闭";
    }else{
        self.Alert.clockExtend = self.clockExtendLabel.text;
    }
    
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        self.clockCount = [[userDefault objectForKey:@"ClockCount"] intValue];
        if (!self.clockID) {
            if (![self.clickTheFirstOrAddBtnFlag isEqualToString:ClickTheFirstClockFlag]) {
                _clockID = _clockCount++;
                  self.Alert.clockID = [NSString stringWithFormat:@"%d",_clockID];
                [userDefault setObject:[NSNumber numberWithInt:self.clockCount] forKey:@"ClockCount"];
                 [[HYLocalNotication shareHYLocalNotication] saveClockData:self.Alert];
            }else{
                self.Alert.clockID = [NSString stringWithFormat:@"%d",_clockID];
            }
        }else{
            self.Alert.clockID = [NSString stringWithFormat:@"%d",_clockID];
        }
    
  

    
    NSString *fitPeople = [userDefault objectForKey:@"ClockFitPeople"];
    if ([fitPeople isEqualToString:@"关闭"] ||fitPeople == nil){
     [[HYLocalNotication shareHYLocalNotication] saveClockData:self.Alert];
    }else{
        
        if (!self.Alert.clockType) {
            [[HYLocalNotication shareHYLocalNotication] saveClockData:self.Alert];
        }else{
            [[HYLocalNotication shareHYLocalNotication]writeDataToDefaultPlist:self.Alert];
        }
        
    }
    
    if (self.Alert.clockState) {
        if ([self.fromMainOrMyVCFlag isEqualToString:FromMainVC]){
            
            if (self.Alert.clockType) {
            [[HYLocalNotication shareHYLocalNotication]startLocalNoticationClockID:self.clockID+SetNoClockModeAlertCount];
            }else {
            [[HYLocalNotication shareHYLocalNotication]startLocalNoticationClockID:self.clockID];
            }

        }else{
            [[HYLocalNotication shareHYLocalNotication]startLocalNoticationClockID:self.clockID];
        }
        
    }else{
        if ([self.fromMainOrMyVCFlag isEqualToString:FromMainVC]){
            [[HYLocalNotication shareHYLocalNotication]cancelLocalNotication:self.clockID+SetNoClockModeAlertCount];
        }else{
           [[HYLocalNotication shareHYLocalNotication]cancelLocalNotication:self.clockID];
        }
    }
 
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark SetClockExtendVC的传值协议方法
- (void)passingTheClockExtendToHere:(NSString *)clockExtend{
    self.clockExtendLabel.text = clockExtend;
    self.passingFlag = YES;
}

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
            
            cell.textLabel.text = NSLocalizedString(@"闹钟开关", nil) ;
//            闹钟开关按键
            if (cell.contentView.subviews.count<3){
                [cell.contentView addSubview:_clockSwitchBtn];
            }
            

            
        }else if (indexPath.row == 1){
            
            cell.textLabel.text = NSLocalizedString(@"强制叫醒", nil);
//            强制叫醒开关按键
            if (cell.contentView.subviews.count<3){
                [cell.contentView addSubview:_forceSwitchBtn];
            }
            
            
        }else if (indexPath.row == 2){

            cell.userInteractionEnabled = NO;
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        

    }else{
        if (indexPath.row == 0) {
            
            cell.textLabel.text = NSLocalizedString(@"名称", nil);
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
            cell.textLabel.text = NSLocalizedString(@"时间", nil);
//            self.clockTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, cell.contentView.frame.size.width-150, cell.contentView.frame.size.height)];
            
            if (cell.contentView.subviews.count<3){
               [cell.contentView addSubview:self.clockTimeLabel];
            }
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
//             NSLog(@"========%@=======",cell.contentView.subviews);
            
        }else if (indexPath.row == 2){
            
            cell.textLabel.text = NSLocalizedString(@"周期", nil);
//            self.clockModeLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, cell.contentView.frame.size.width-150, cell.contentView.frame.size.height)];
            
            if (cell.contentView.subviews.count<3){
               [cell.contentView addSubview:self.clockModeLabel];
            }
            
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
        }else if (indexPath.row == 3){
            
            cell.textLabel.text = NSLocalizedString(@"铃声", nil);
//            self.clockMusicLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, cell.contentView.frame.size.width-150, cell.contentView.frame.size.height)];
            
            
            if (cell.contentView.subviews.count<3){
              [cell.contentView addSubview:self.clockMusicLabel];
            }
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
        }else if (indexPath.row == 4){
            
            cell.textLabel.text = NSLocalizedString(@"小睡", nil);
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
                
                if ([self.clockExtendLabel.text containsString:@"分钟"]) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注意" message:@"当开启小睡功能的时候是不允许" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alertView show];
                }else{
                    if (self.Alert.clockForce) {
                        
                        self.forceSwitchBtn.image = [UIImage imageNamed:@"开关（关）"];
                        //                    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:[]
                        
                    }else{
                        
                        [self.forceSwitchBtn setImage:[UIImage imageNamed:@"开关（开）"]] ;
                        
                    }
                    self.Alert.clockForce = !self.Alert.clockForce;

                }

                
                [cell.contentView addSubview:_forceSwitchBtn];
                
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
                setClockTimeController.timeText = self.clockTimeLabel.text;
                [self.navigationController pushViewController:setClockTimeController animated:YES];
                break;
            case 2:
                [self.navigationController pushViewController:setClockModeController animated:YES];
                break;
            case 3:
                setClockMusicController.clockMusic = self.clockMusicLabel.text;
                [self presentViewController:setClockMusicController animated:YES completion:^{
                    
                }];
                break;
            case 4:
                if (self.Alert.clockForce) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注意" message:@"强制叫醒的时候不需要设置小睡" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
                    [alertView show];
                }else{
                    setClockExtendViewController.clockExtend = self.clockExtendLabel.text;
                    [self.navigationController pushViewController:setClockExtendViewController animated:YES];
                }
                
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
        return 3;
    }
    return 5;
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
