//
//  MyClockViewController.m
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/8.
//  Copyright © 2016年 趣云科技. All rights reserved.
//
@import GoogleMobileAds;

#import "MyClockViewController.h"

@interface MyClockViewController ()<UITableViewDataSource,UITableViewDelegate,GADBannerViewDelegate>
{
    GADMasterViewController *shared;
}


//切换到闹钟页的视图
@property (strong,nonatomic)UIView *bottomView;

//tableView的约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrainsOfTabelView;

@property (weak, nonatomic) IBOutlet UITableView *tabelView;

@property (weak, nonatomic) IBOutlet UIButton *backToMainVCButton;

@property(nonatomic,strong)SetClockViewController * setClockVC;

@property(nonatomic,strong)NSMutableArray *alertArray;

@property (weak, nonatomic) IBOutlet UIView *topView;



@end

@implementation MyClockViewController

static NSString *cellID = @"cellID";

+ (instancetype)sharedMyClockViewController{
     MyClockViewController *myClockViewController =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyClockID"];

    return myClockViewController;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.setClockVC = [SetClockViewController sharedSetClockViewController];
    
//    // Replace this ad unit ID with your own ad unit ID.
//    self.admodBannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
//    self.admodBannerView.rootViewController = self;
//
//
//    GADRequest *request = [GADRequest request];
//    // Requests test ads on devices you specify. Your test device ID is printed to the console when
//    // an ad request is made. GADBannerView automatically returns test ads when running on a
//    // simulator.
//    request.testDevices = @[
//                            @"5ff659b7225c70aee936a20c4c6236ad"  // Eric's iPod Touch
//                        ];
//    [self.admodBannerView loadRequest:request];
//
//        
    [self.tabelView registerNib:[UINib nibWithNibName:@"MyAlertCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellID];

    
    [self addAllViews];

}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView{
    
}
//    从NSUserDefault中读取数据,填充表格
- (void)viewWillAppear:(BOOL)animated{
    
    shared = [GADMasterViewController singleton];
    [shared resetAdView:self];
    
    [self initClockCount];
    [self.tabelView reloadData];
    
    [super viewWillAppear:animated];
}
#pragma mark     从NSUserDefault中读取数据,填充表格
- (void)initClockCount{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    NSLog(@"%@",[userDefault objectForKey:@"ClockCount"]);
    if (![userDefault objectForKey:@"ClockCount"]){
        self.clockCount = 0;
    }
    else{
        self.clockCount = [[userDefault objectForKey:@"ClockCount"] intValue];
    }

 
}

#pragma mark 推出总设置页面
- (IBAction)moveToMainSetVCAction:(UIButton *)sender {
    [self.navigationController pushViewController:[mainSetViewController sharedMainSetViewController] animated:YES];

}

#pragma mark 添加视图
- (void)addAllViews{
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-109, self.view.frame.size.width, 59)];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addAlertAtion:) forControlEvents:UIControlEventTouchUpInside];
    addButton.frame = CGRectMake(self.bottomView.frame.size.width * 0.5 - 30, 0, 59, 59);
    [self.bottomView addSubview:addButton];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _bottomView.frame.size.width, 1)];
    lineLabel.backgroundColor = [UIColor blackColor];
    lineLabel.alpha = .1f;
    
    [self.bottomView addSubview:lineLabel];
    
    [self.view addSubview:self.bottomView];
    
    UILabel *lineLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, self.topView.frame.size.height-1, self.view.frame.size.width, 1)];
    lineLabel2.backgroundColor = [UIColor blackColor];
    lineLabel2.alpha = .1f;
    [self.topView addSubview:lineLabel2];

}

#pragma mark 去往添加闹钟页面
- (void)addAlertAtion:(UIButton *)sender{
    self.setClockVC.Alert = nil;
    self.setClockVC.clickTheFirstOrAddBtnFlag = nil;
    [self.navigationController pushViewController:self.setClockVC animated:YES];
        
    
}


#pragma mark 返回按键的方法
- (IBAction)backToMainVCAction:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark tableView的协议内容

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyAlertCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    alert * Alert = [[HYLocalNotication shareHYLocalNotication] findClockOfAllAlertsByIndexPath:indexPath];
    cell.clockTimeLabel.text = Alert.clockTime;
    cell.clockNameLabel.text = Alert.clockName;
    cell.clockModeLabel.text = Alert.clockMode;
    cell.clockID = (short)indexPath.row;
    if (Alert.clockState) {
        [cell.clockStateBtn setImage:[UIImage imageNamed:@"开关（开）"] forState:UIControlStateNormal];
    }else{
        [cell.clockStateBtn setImage:[UIImage imageNamed:@"开关（关）"] forState:UIControlStateNormal];
    }
    
    cell.backgroundColor = [UIColor colorWithHexString:@"#55aa55"alpha:.5f];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.setClockVC.clickTheFirstOrAddBtnFlag = ClickTheFirstClockFlag;
    self.setClockVC.passingFlag = NO;
    self.setClockVC.Alert = [[HYLocalNotication shareHYLocalNotication]findClockOfAllAlertsByIndexPath:indexPath];
    self.setClockVC.clockID = [[NSString stringWithFormat:@"%ld",indexPath.row] intValue];
    [self.navigationController pushViewController:self.setClockVC animated:YES];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.clockCount;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


- (NSMutableArray *)alertArray{
    if (_alertArray == nil) {
        _alertArray = [NSMutableArray arrayWithCapacity:6];
    }
    return _alertArray;
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
