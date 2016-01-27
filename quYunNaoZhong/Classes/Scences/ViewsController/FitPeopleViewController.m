//
//  FitPeopleViewController.m
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/22.
//  Copyright © 2016年 趣云科技. All rights reserved.
//

#import "FitPeopleViewController.h"

@interface FitPeopleViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,weak)NSString * selectedMode;


@end

@implementation FitPeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *fitPeople = [userDefault objectForKey:@"ClockFitPeople"];
    self.selectedMode = fitPeople;
    [super viewWillAppear:animated];
}
- (IBAction)backToVCAction:(UIButton *)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)makeSureSelectionAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(passingTheSelectedModeAction:)]) {
        
        if (self.selectedMode) {
        [self.delegate passingTheSelectedModeAction:self.selectedMode];  
        }
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *fitPeople = [userDefault objectForKey:@"ClockFitPeople"];
    if ([self.selectedMode isEqualToString:@"关闭"]) {
        if (![fitPeople isEqualToString:self.selectedMode] && fitPeople) {
    [userDefault setObject:[NSString stringWithFormat:@"%d",[[userDefault objectForKey:@"ClockCount"] intValue]-8]forKey:@"ClockCount"];
            [[HYLocalNotication shareHYLocalNotication]removeAllDefaultClockData];
        }

    }else{
        if (self.selectedMode != fitPeople && [fitPeople isEqualToString:@"关闭"]) {
        [userDefault setObject:[NSString stringWithFormat:@"%d",[[userDefault objectForKey:@"ClockCount"] intValue]+8]forKey:@"ClockCount"];
              [[HYLocalNotication shareHYLocalNotication]writeDataToDefaultPlist:nil];
        }

    }
    [userDefault setObject:self.selectedMode forKey:@"ClockFitPeople"];
    [self.navigationController popViewControllerAnimated:YES];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"关闭";
            break;
        case 1:
            cell.textLabel.text = @"18-30岁";
            break;
        case 2:
            cell.textLabel.text = @"30-40岁";
            break;
        case 3:
            cell.textLabel.text = @"40-50岁";
            break;
        case 4:
            cell.textLabel.text = @"50岁以上";
            break;
        default:
            break;
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    
    for (NSInteger i=0; i<5; i++) {
        UITableViewCell *tmpCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
             tmpCell.accessoryType = UITableViewCellAccessoryNone;
    }
    self.selectedMode = cell.textLabel.text;
     cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
