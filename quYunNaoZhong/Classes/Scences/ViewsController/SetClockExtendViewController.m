//
//  SetClockExtendViewController.m
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/25.
//  Copyright © 2016年 趣云科技. All rights reserved.
//

#import "SetClockExtendViewController.h"

@interface SetClockExtendViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property(nonatomic,weak)NSString * selectedClockExtend;


@end

@implementation SetClockExtendViewController

- (IBAction)backToAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)makeSureAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(passingTheClockExtendToHere:)]) {
        [self.delegate passingTheClockExtendToHere:self.selectedClockExtend];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];

}
- (void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
    
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"3分钟";
            break;
        case 1:
            cell.textLabel.text = @"5分钟";
            break;
        case 2:
            cell.textLabel.text = @"10分钟";
            break;
        case 3:
            cell.textLabel.text = @"30分钟";
            break;
            case 4:
            cell.textLabel.text = @"关闭";
        default:
            break;
    }
    if ([cell.textLabel.text isEqualToString:self.clockExtend]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;

    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    for (NSInteger i=0; i<5; i++) {
        UITableViewCell *tmpCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        tmpCell.accessoryType = UITableViewCellAccessoryNone;
    }
    self.selectedClockExtend = cell.textLabel.text;
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    
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
