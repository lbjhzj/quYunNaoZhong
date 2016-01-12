
//
//  SetClockViewController.m
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/8.
//  Copyright © 2016年 趣云科技. All rights reserved.
//
@import GoogleMobileAds;
#import "SetClockViewController.h"

@interface SetClockViewController ()<UITableViewDataSource,UITableViewDelegate,PassingTheClockTimeDelegate>

@property (weak, nonatomic) IBOutlet GADBannerView *admodBannerView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic)UILabel *valueLabel;

@property (strong, nonatomic)UIImageView *switchButton;

@end

@implementation SetClockViewController

static NSString *cellID = @"cellID";

static NSString *cellID_2 = @"sliderID";
+ (instancetype)sharedSetClockViewController{
   SetClockViewController *setClockViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SetClockID"];
 
    return setClockViewController;
}



//返回按键方法
- (IBAction)backToMyClockVCAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    setClockTimeController = [[SetClockTimeController alloc]initWithNibName:@"SetClockTimeController" bundle:nil];

    setClockTimeController.delegate = self;
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    
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

    
}

#pragma mark SetClockTimeVC的协议方法
//闹钟设定时间的传值
- (void)passingClockTimeToHere:(NSString *)clockTime{
    

    self.clockTimeLabel.text = clockTime;
//    [self.tableView reloadData];
}

#pragma mark 闹钟的音量设置
- (void)soundValueChangeAction:(UISlider *)sender{
    _valueLabel.text = [NSString stringWithFormat:@"%.0f",self.clockSoundValueLabel.value];
    
}

#pragma mark tableView的协议

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
 
    
    self.switchButton = [[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width-22-16, cell.frame.size.height * 0.5 - 8, 16, 16)];
    _switchButton.image = [UIImage imageNamed:@"开关（关）"];
    
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            cell.textLabel.text = @"闹钟开关";
//            闹钟开关按键
            
            [cell.contentView addSubview:_switchButton];

            
        }else if (indexPath.row == 1){
            
            cell.textLabel.text = @"强制叫醒";
//            强制叫醒开关按键
            [cell.contentView addSubview:_switchButton];
            
        }else if (indexPath.row == 2){

            cell.textLabel.text = @"震动";
//            震动开关按键
            [cell.contentView addSubview:_switchButton];
        }else{
            cell.userInteractionEnabled = NO;
        }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell.contentView.subviews.count == 3) {
//            [cell.contentView.subviews[1] removeFromSuperview];
        }

    }else{
        if (indexPath.row == 0) {
            
            cell.textLabel.text = @"名称";
            self.clockNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, cell.contentView.frame.size.width-150, cell.contentView.frame.size.height)];
            [cell.contentView addSubview:self.clockNameLabel];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
        }else if (indexPath.row == 1){
 
            if (cell.contentView.subviews.count == 3) {
//                [cell.contentView.subviews[1] removeFromSuperview];
            }
            cell.textLabel.text = @"时间";
            self.clockTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, cell.contentView.frame.size.width-150, cell.contentView.frame.size.height)];
            [cell.contentView addSubview:self.clockTimeLabel];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
//             NSLog(@"========%@=======",cell.contentView.subviews);
            
        }else if (indexPath.row == 2){
            
            cell.textLabel.text = @"周期";
            self.clockModeLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, cell.contentView.frame.size.width-150, cell.contentView.frame.size.height)];
            [cell.contentView addSubview:self.clockModeLabel];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
        }else if (indexPath.row == 3){
            
            cell.textLabel.text = @"铃声";
            self.clockMusicLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, cell.contentView.frame.size.width-150, cell.contentView.frame.size.height)];
            
            [cell.contentView addSubview:self.clockMusicLabel];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
        }else if (indexPath.row == 4){
            
            cell.textLabel.text = @"小睡";
            self.clockExtendLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, cell.contentView.frame.size.width-150, cell.contentView.frame.size.height)];
            [cell.contentView addSubview:self.clockExtendLabel];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }else{
            
            UITableViewCell * cell2 = [tableView dequeueReusableCellWithIdentifier:cellID_2 forIndexPath:indexPath];

            cell2.textLabel.text = @"音量";
            self.clockSoundValueLabel = [[UISlider alloc] initWithFrame:CGRectMake(150, 0, cell.contentView.frame.size.width-220, cell.contentView.frame.size.height)];
            
            _clockSoundValueLabel.maximumValue = 100.f;
            
            [_clockSoundValueLabel addTarget:self action:@selector(soundValueChangeAction:) forControlEvents:UIControlEventValueChanged];
            
            [_clockSoundValueLabel setMinimumTrackImage:[UIImage imageNamed:@"下划线"] forState:UIControlStateNormal];
            
            _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width-50 , 0, 50, cell.contentView.frame.size.height)];
            _valueLabel.textAlignment = NSTextAlignmentCenter;
            _valueLabel.text = [NSString stringWithFormat:@"%.0f",self.clockSoundValueLabel.value];
            
            [cell.contentView addSubview:_valueLabel];
            [cell.contentView addSubview:self.clockSoundValueLabel];
            
           
            
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    NSLog(@"section == %ld  row == %ld",indexPath.section,indexPath.row);
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            [self.navigationController pushViewController:setClockTimeController animated:YES];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49;
}


//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 49;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 99)];
//    if (section == 0) {
//        view.backgroundColor = [UIColor lightTextColor];
//    }else{
//        view.frame = CGRectMake(0, 0, 0, 0);
//    }
//    return view;
//}

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
