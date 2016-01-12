//
//  MainViewController.m
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/6.
//  Copyright © 2016年 趣云科技. All rights reserved.
//
@import GoogleMobileAds;

#import "MainViewController.h"
@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate>

//广告框
@property (weak, nonatomic) IBOutlet GADBannerView *admodBannerView;

//切换到闹钟页的视图
@property (strong,nonatomic)UIView *bottomView;

//时间框
@property (weak, nonatomic) IBOutlet UIView *timeView;

@property (weak, nonatomic) IBOutlet UILabel *hourAndMinuteLabel;

@property (weak, nonatomic) IBOutlet UILabel *secondsLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//时间视图的约束条件
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrainsOfTimeView;

//tableView的约束条件
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintsOfTableView;

@property(nonatomic,strong)MyClockViewController * myClockVC;


@end

@implementation MainViewController

static NSString *cellID = @"cellID";



- (void)viewWillAppear:(BOOL)animated{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    
    //    时间框的约束条件
    self.constrainsOfTimeView.constant = 15.0f;
    
#warning 检查时间显示是否有bug
    NSArray * tempTimeArray = [[NSString stringFromDate:[NSDate date] ByFormatter:formatter] componentsSeparatedByString:@":"];
    
    [self countDownAction:tempTimeArray];
    
    [super viewWillAppear:animated];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myClockVC = [MyClockViewController sharedMyClockViewController];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"alertCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellID];
    
    [self addViews];
    
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

#pragma mark 添加视图
- (void)addViews{
    
    self.bottomView =[[UIView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-109, self.view.frame.size.width, 59)];
    
    //    切换到闹钟界面的按键
    UIButton *switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [switchButton setImage:[UIImage imageNamed:@"闹钟"] forState:UIControlStateNormal];
    switchButton.frame = CGRectMake(self.bottomView.frame.size.width * 0.5 - 30, 0, 59, 59);
    
    [switchButton addTarget:self action:@selector(switchToMyAlertControllerAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.bottomView addSubview:switchButton];
    
    [self.view addSubview:self.bottomView];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _bottomView.frame.size.width, 1)];
    lineLabel.backgroundColor = [UIColor blackColor];
    lineLabel.alpha = .1f;
    
    [_bottomView addSubview:lineLabel];
    
    //    设置自定义的navigationBar的高度
    float newHeight = 79;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(
                                                            self.navigationController.navigationBar.frame.origin.x,
                                                            0,
                                                            self.navigationController.navigationBar.frame.size.width,
                                                            newHeight
                                                            )];
    
    view.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    [self.view addSubview:view];
    
    //    日期label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(45, newHeight-32, 160, 16)];
    label.font = [UIFont systemFontOfSize:18];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd (ccc)"];
    label.text = [NSString stringFromDate:[NSDate date] ByFormatter:formatter] ;
    label.textColor = [UIColor colorWithHexString:@"#333333"];
    [view addSubview:label];
    
    //    设置按钮
    UIButton *setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [setButton setImage:[UIImage imageNamed:@"设置"] forState:UIControlStateNormal];
    setButton.frame = CGRectMake(self.view.frame.size.width-15-40, 35, 40, 40);
    [view addSubview:setButton];
    
    
}



#pragma mark 数秒的方法
- (void)countDownAction:(NSArray *)tempTimeArray{
        NSTimeInterval Timeinterval = [tempTimeArray[0] intValue]*3600+[tempTimeArray[1] intValue]*60+[tempTimeArray[2] intValue];
        __block int timeout=Timeinterval; //当前的时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
    
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
    
                });
            }else{
                int hours = timeout / 3600;
                int minutes = (timeout - hours * 3600) / 60;
                int seconds = timeout % 60;
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    //秒钟
                    self.secondsLabel.font = [UIFont systemFontOfSize:18];
                    if (seconds <10) {
                        self.secondsLabel.text = [@"0" stringByAppendingString:[NSString stringWithFormat:@"%d",seconds]];
                    }else{
                        self.secondsLabel.text = [NSString stringWithFormat:@"%d",seconds];

                    }
                    //    时钟和分钟
                    self.hourAndMinuteLabel.font = [UIFont systemFontOfSize:90];
                    NSString *minutesStr;
                    NSString *hoursStr;
                    if (minutes < 10) {
                        minutesStr = [@"0" stringByAppendingString:[NSString stringWithFormat:@"%d",minutes]];
                    }else{
                        minutesStr = [NSString stringWithFormat:@"%d",minutes];
                    }
                    if (hours < 10) {
                        hoursStr = [@"0" stringByAppendingString:[NSString stringWithFormat:@"%d:",hours]];
                    }else{
                        hoursStr = [NSString stringWithFormat:@"%d:",hours];
                    }
                    
                    self.hourAndMinuteLabel.text = [hoursStr stringByAppendingString:minutesStr];
                    

                });
                timeout++;
                
            }  
        });  
        dispatch_resume(_timer);
}





#pragma mark 切换到我的闹钟界面
- (void)switchToMyAlertControllerAction:(UIButton *)sender{
    
    ;
    [self.navigationController pushViewController:_myClockVC animated:YES];

}



#pragma mark tableView协议内容

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //-----获取闹钟数据---------------------------------------------------------
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    NSMutableDictionary *clockDictionary = [userDefault objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
    
//    NSString *clockName = [clockDictionary objectForKey:@"ClockName"];
//    NSString *clockTime = [clockDictionary objectForKey:@"ClockTime"];
//    NSString *clockMode = [clockDictionary objectForKey:@"ClockMode"];
//    NSString *clockMusic = [clockDictionary objectForKey:@"ClockMusic"];
//    NSString *clockRemember = [clockDictionary objectForKey:@"ClockRemember"];
    
    alertCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
//    cell.timeLabel.text = clockTime;
    
    cell.backgroundColor = [UIColor darkTextColor];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.navigationController pushViewController:[SetClockViewController sharedSetClockViewController] animated:YES];

    });
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
