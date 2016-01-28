//
//  MainViewController.m
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/6.
//  Copyright © 2016年 趣云科技. All rights reserved.
//


@import GoogleMobileAds;

#import "MainViewController.h"
@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate,GADBannerViewDelegate>
{
    SetClockViewController *setClockVC;
    GADMasterViewController *shared;
    CGFloat newHight;
    NSInteger alertIndex;
}


//切换到闹钟页的视图
@property (strong,nonatomic)UIView *bottomView;

//时间框
@property (weak, nonatomic) IBOutlet UIView *timeView;

@property (weak, nonatomic) IBOutlet UILabel *hourAndMinuteLabel;

@property (weak, nonatomic) IBOutlet UILabel *secondsLabel;

//tableView的约束条件
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewConstrains;



@property(nonatomic,strong)MyClockViewController * myClockVC;

@property(nonatomic,assign)int clockCount;

@property(nonatomic,assign)int  ActivityCount;

@property(nonatomic,strong)NSMutableArray * clockArray;

@property(nonatomic,strong)NSMutableArray *firstArray;

@property(nonatomic,strong)NSArray * indexPaths;

@end

@implementation MainViewController

static NSString *cellID = @"cellID";



- (void)viewWillAppear:(BOOL)animated{
    alertIndex = 888;
    newHight = 110;
    //    设置谷歌广告
    shared = [GADMasterViewController singleton];
    [shared resetAdView:self];
    if (!shared.adBanner_&&shared) {
        self.tableViewConstrains.constant = 9;
    }
//    NSArray *localNotications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    
    //    时间框的约束条件
    //    self.constrainsOfTimeView.constant = 15.0f;
    
    //#warning 检查时间显示是否有bug
//    NSArray * tempTimeArray = [[NSString stringFromDate:[NSDate date] ByFormatter:formatter] componentsSeparatedByString:@":"];
    
//    [self countDownAction:tempTimeArray];
//    初始化当天的闹钟数组
    [self initClockCount];
    [self.firstArray removeAllObjects];
    int index = 0;
    for (int i=0; i<self.clockCount; i++) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd (ccc)"];
        NSString *dateMode=[NSString stringFromDate:[NSDate date] ByFormatter:formatter];

       NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
        //        检测本机语言
        NSArray* languages = [defs objectForKey:@"AppleLanguages"];
        NSString* preferredLang = [languages objectAtIndex:0];
        NSString *fitPeople = [defs objectForKey:@"ClockFitPeople"];
        
        alert *Alert = [alert new];
        if ([fitPeople isEqualToString:@"关闭"] ||fitPeople == nil){
            Alert = [[HYLocalNotication shareHYLocalNotication]findClockOfAllAlertsByIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        }else{
            if (self.clockCount > 8) {
           
                if ([[HYLocalNotication shareHYLocalNotication]findClockOfAllAlertsByIndexPath:[NSIndexPath indexPathForRow:i inSection:0]].clockTime) {
                Alert = [[HYLocalNotication shareHYLocalNotication]findClockOfAllAlertsByIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                }else{
                NSArray *tmpArray = [[HYLocalNotication shareHYLocalNotication]findClockOfDefaultPlist:fitPeople];
                    
                [Alert setValuesForKeysWithDictionary:tmpArray[index++]];
                }


            }else{
             
                for (NSDictionary *dictionary in [[HYLocalNotication shareHYLocalNotication] findClockOfDefaultPlist:fitPeople]) {

                    alert *Alert1 = [alert new];
                    NSString *clockName =[dictionary objectForKey:@"ClockName"];
                    NSString *clockTime = [dictionary objectForKey:@"ClockTime"];
                    NSString *clockMode = [dictionary objectForKey:@"ClockMode"];
                    NSString *clockMusic = [dictionary objectForKey:@"ClockMusic"];
                    NSString *clockForceSwitch = [dictionary objectForKey:@"ClockForce"];
                    NSString *clockRemember = [dictionary objectForKey:@"ClockRemember"];
                    NSString *clockExtend = [dictionary objectForKey:@"ClockExtend"];
                    NSString *clockType = [dictionary objectForKey:@"ClockType"];
                    
                    Alert1.clockMode = clockMode;
                    Alert1.clockName = clockName;
                    Alert1.clockTime = clockTime;
                    Alert1.clockMusic = clockMusic;
                    Alert1.clockForce = [clockForceSwitch boolValue];
                    Alert1.clockRemember = clockRemember;
                    Alert1.clockExtend = clockExtend;
                    Alert1.clockType = clockType;
                    Alert = Alert1;
                    if ([preferredLang containsString:@"en"]) {
                        //            if ([Alert.clockMode containsString:@"二"]) {
                        //                 [self.firstArray addObject:Alert];
                        //            }
                    }else{
                        if ([Alert.clockMode containsString:[(NSString *)([dateMode componentsSeparatedByString:@"周"][1]) componentsSeparatedByString:@")"][0]]) {
                            [self.firstArray addObject:Alert];
                        }
                    }
 
                }
                break;
                
            }
            

            
        }

        

  
        
        if ([preferredLang containsString:@"en"]) {
//            if ([Alert.clockMode containsString:@"二"]) {
//                 [self.firstArray addObject:Alert];
//            }
        }else{
            if ([Alert.clockMode containsString:[(NSString *)([dateMode componentsSeparatedByString:@"周"][1]) componentsSeparatedByString:@")"][0]]) {
                [self.firstArray addObject:Alert];
            }
        }

    }
   
    self.clockArray = [self.firstArray copy];
    [self.tableView reloadData];
    
    
//    [[UIApplication sharedApplication]cancelAllLocalNotifications];
    for (UILocalNotification *localNotication in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        NSLog(@"%@",localNotication);
    }
    [super viewWillAppear:animated];
}

#pragma mark 谷歌广告协议方法
- (void)adViewDidReceiveAd:(GADBannerView *)bannerView{
    if (shared.view.tag == 1999) {
        [shared removeFromParentViewController];
        shared = [GADMasterViewController singleton];
        [shared resetAdView:self];
    }
    shared.view.tag = 1999;
    
}

#pragma mark 初始化闹钟总个数
- (void)initClockCount{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//        NSLog(@"%@",[userDefault objectForKey:@"ClockCount"]);
    if (![userDefault objectForKey:@"ClockCount"]){
        self.clockCount = 0;
    }
    else{
        self.clockCount = [[userDefault objectForKey:@"ClockCount"] intValue];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
#pragma mark 删除存储的所有闹钟数据===========测试
//    [[HYLocalNotication shareHYLocalNotication] removeAllDataInUserDefault];
    

    self.myClockVC = [MyClockViewController sharedMyClockViewController];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"alertCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellID];
    
    [self addViews];
    
    setClockVC = [SetClockViewController sharedSetClockViewController];
    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveOutAdvertisment) name:@"buyAction" object:nil];

    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeBugger:) name:@"makeItBigger" object:nil];
}

#pragma mark 去除广告，改约束
- (void)moveOutAdvertisment{

}

#pragma mark 添加视图
- (void)addViews{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    
    //    时间框的约束条件
//    self.constrainsOfTimeView.constant = 15.0f;
    
    //#warning 检查时间显示是否有bug
    NSArray * tempTimeArray = [[NSString stringFromDate:[NSDate date] ByFormatter:formatter] componentsSeparatedByString:@":"];
    
    [self countDownAction:tempTimeArray];
    
//    去广告
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ((!shared.adBanner_&&shared)||[userDefault objectForKey:@"enable_rocket_car"] ) {
    self.bottomView =[[UIView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-59, self.view.frame.size.width, 59)];
    }else{
     self.bottomView =[[UIView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-109, self.view.frame.size.width, 59)];
    }

    
    //    切换到闹钟界面的按键
    UIButton *switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [switchButton setImage:[UIImage imageNamed:@"闹钟"] forState:UIControlStateNormal];
    switchButton.frame = CGRectMake(self.bottomView.frame.size.width * 0.5 - 30, 0, 59, 59);
    
    [switchButton addTarget:self action:@selector(switchToMyAlertControllerAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.bottomView addSubview:switchButton];
    
    [self.view addSubview:self.bottomView];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _bottomView.frame.size.width, 0.5)];
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
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd (ccc)"];
    label.text = [NSString stringFromDate:[NSDate date] ByFormatter:formatter];
   
    label.textColor = [UIColor colorWithHexString:@"#333333"];
    [view addSubview:label];
    
    //    设置按钮
    UIButton *setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [setButton setImage:[UIImage imageNamed:@"设置"] forState:UIControlStateNormal];
    [setButton addTarget:self action:@selector(moveToMainSetVC:) forControlEvents:UIControlEventTouchUpInside];
    setButton.frame = CGRectMake(self.view.frame.size.width-15-40, 35, 40, 40);
    [view addSubview:setButton];
    
    UILabel *lineLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, view.frame.size.height-0.5, self.view.frame.size.width, 0.5)];
    lineLabel2.backgroundColor = [UIColor blackColor];
    lineLabel2.alpha = .1f;
    
        [view addSubview:lineLabel2];
}

#pragma mark 推出总设置页面
- (void)moveToMainSetVC:(UIButton *)sender{
    [self.navigationController pushViewController:[mainSetViewController sharedMainSetViewController] animated:YES];
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
    
    self.indexPaths = [NSArray arrayWithObject:indexPath];

   alertCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[alertCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
 
    alert *Alert = [alert new];
    Alert=self.clockArray[indexPath.row];
    cell.timeLabel.text =Alert.clockTime;
   
    cell.alertNameLabel.text = Alert.clockName;
    cell.alertWeekLabel.text = Alert.clockMode;
    cell.remarkLabel.text = Alert.clockRemember;
    cell.index = indexPath.row;
//    if (cell.isOpen) {
//        if (indexPath.row == alertIndex) {
//          cell.remarkLabel.numberOfLines = 0;
//            
//        }else{
//        cell.remarkLabel.numberOfLines = 1;
//            cell.isOpen = NO;
//        }
//        
//    }else{
//        cell.remarkLabel.numberOfLines = 1;
//    }
    if (indexPath.row == alertIndex) {
        if (cell.isOpen) {
        cell.remarkLabel.numberOfLines = 0;
         cell.isOpen = YES;    
        }else{
            cell.remarkLabel.numberOfLines = 1;
            cell.isOpen = NO;
        }

    }else{
        cell.remarkLabel.numberOfLines = 1;
         cell.isOpen = NO;
    }
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    

    int hour = [((NSString *)[Alert.clockTime componentsSeparatedByString:@":"][0]) intValue]-[((NSString *)[[NSString stringFromDate:date ByFormatter:formatter] componentsSeparatedByString:@":"][0]) intValue];
    int minute = [((NSString *)[Alert.clockTime componentsSeparatedByString:@":"][1]) intValue]-[((NSString *)[[NSString stringFromDate:date ByFormatter:formatter] componentsSeparatedByString:@":"][1]) intValue];
    if (hour<0) {

        cell.countLabel.text = NSLocalizedString(@"时间已过", nil);
    }else{
        if (hour<0) {
            hour = 0;
        }
        if (minute<0) {
            minute = 0;
        }
        cell.countLabel.text = [NSString stringWithFormat:@"还有%d时%d分",hour,minute];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.clockArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (alertIndex!=888) {
        if (indexPath.row == alertIndex) {
            
            NSLog(@"改变了%f",newHight);
            return newHight;
        }
    }
    return 110;
}

- (void)makeBugger:(NSNotification *)text{
   NSString *newFramStr = text.userInfo[@"newFrame"];
    CGRect newFrame = CGRectFromString(newFramStr);
    
       newHight = newFrame.size.height;
    
    alertIndex = [text.userInfo[@"index"] integerValue];
    [self.tableView reloadData];
}
//自适应cell高度
+ (CGSize)labelheight:(UILabel *)detlabel{
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 
                                 };
    
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width - 168, 1000);
    
    CGSize contentactually = [detlabel.text boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributes context:nil].size;
    
    return contentactually;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    setClockVC.Alert = self.clockArray[indexPath.row];
    setClockVC.clickTheFirstOrAddBtnFlag = ClickTheFirstClockFlag;
    setClockVC.passingFlag = NO;
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //    NSLog(@"%@",[userDefault objectForKey:@"ClockCount"]);
    NSString *fitPeople = [userDefault objectForKey:@"ClockFitPeople"];
    if ([fitPeople isEqualToString:@"关闭"] ||fitPeople == nil){
        setClockVC.clockID = [[NSString stringWithFormat:@"%ld",indexPath.row] intValue];
    }else{
        if (!setClockVC.Alert.clockType) {
           setClockVC.clockID = [setClockVC.Alert.clockID intValue];
        }else{
            setClockVC.clockID = [[NSString stringWithFormat:@"%ld",indexPath.row] intValue];
            
        }
    }

    [self.navigationController pushViewController:setClockVC animated:YES];
    
    
}

//懒加载闹钟数组
- (NSMutableArray *)clockArray{

    if (_clockArray == nil) {
        _clockArray = [NSMutableArray array];
    }
    return _clockArray;
   
}

- (NSMutableArray *)firstArray{
    if (_firstArray == nil) {
        _firstArray = [NSMutableArray array];
    }
    return _firstArray;
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
