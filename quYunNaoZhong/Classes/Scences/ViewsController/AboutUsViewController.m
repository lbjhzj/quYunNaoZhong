//
//  AboutUsViewController.m
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/28.
//  Copyright © 2016年 趣云科技. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()



@end

@implementation AboutUsViewController
- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)makeSureAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
