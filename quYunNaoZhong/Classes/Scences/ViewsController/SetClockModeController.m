//
//  SetClockModeController.m
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/12.
//  Copyright © 2016年 趣云科技. All rights reserved.
//

#import "SetClockModeController.h"

@interface SetClockModeController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSMutableArray * tempArray;


@end

@implementation SetClockModeController

static NSString *cellID = @"cellID";

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    

}




#pragma mark 返回设置页面
- (IBAction)backToSetClockVCAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 确认添加或修改闹钟周期
- (IBAction)addClockModeAction:(UIButton *)sender {
    
//    代理传值方法
    if (self.delegate && [self.delegate respondsToSelector:@selector(passingClockMode:)]) {
        [self.delegate passingClockMode:self.tempArray];
    }
    
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark tableView的协议方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"星期日";
            break;
        case 1:
            cell.textLabel.text = @"星期一";
            break;
        case 2:
            cell.textLabel.text = @"星期二";
            break;
        case 3:
            cell.textLabel.text = @"星期三";
            break;
        case 4:
            cell.textLabel.text = @"星期四";
            break;
        case 5:
            cell.textLabel.text = @"星期五";
            break;
        case 6:
            cell.textLabel.text = @"星期六";
            break;
        default:
            break;
    }
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        
        [self.tempArray addObject:[NSString stringWithFormat:@"%ld",indexPath.row]];
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }else{
        [self.tempArray removeObject:[NSString stringWithFormat:@"%ld",indexPath.row]];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    
}

- (NSMutableArray *)tempArray{
    if (_tempArray == nil) {
        _tempArray = [NSMutableArray arrayWithCapacity:7];
    }
    return _tempArray;
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
