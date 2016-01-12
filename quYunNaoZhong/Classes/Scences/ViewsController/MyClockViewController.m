//
//  MyClockViewController.m
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/8.
//  Copyright © 2016年 趣云科技. All rights reserved.
//
@import GoogleMobileAds;

#import "MyClockViewController.h"

@interface MyClockViewController ()<UITableViewDataSource,UITableViewDelegate>



//切换到闹钟页的视图
@property (strong,nonatomic)UIView *bottomView;

//tableView的约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrainsOfTabelView;

@property (weak, nonatomic) IBOutlet UITableView *tabelView;

@property (weak, nonatomic) IBOutlet UIButton *backToMainVCButton;


@end

@implementation MyClockViewController

static NSString *cellID = @"cellID";

+ (instancetype)sharedMyClockViewController{
     MyClockViewController *myClockViewController =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyClockID"];

    return myClockViewController;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
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

        
    [self.tabelView registerNib:[UINib nibWithNibName:@"MyAlertCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellID];
    
    [self addAllViews];
   
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
    
    [_bottomView addSubview:lineLabel];
    
    [self.view addSubview:self.bottomView];

}

#pragma mark 去往添加闹钟页面
- (void)addAlertAtion:(UIButton *)sender{
    [self.navigationController pushViewController:[SetClockViewController sharedSetClockViewController] animated:YES];
}


#pragma mark 返回按键的方法
- (IBAction)backToMainVCAction:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark tableView的协议内容

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyAlertCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHexString:@"#55aa55"alpha:.5f];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_async(dispatch_get_main_queue(), ^{
        
    [self.navigationController pushViewController:[SetClockViewController sharedSetClockViewController] animated:YES];

    });


}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
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