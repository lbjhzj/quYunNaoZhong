//
//  ForceViewController.m
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/19.
//  Copyright © 2016年 趣云科技. All rights reserved.
//

#import "ForceViewController.h"


@interface ForceViewController ()
{
     int correctOperation;
}
@property (weak, nonatomic) IBOutlet UIView *lowView;
@property (weak, nonatomic) IBOutlet UILabel *firstNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *operatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;
@property (weak, nonatomic) IBOutlet UIButton *fourthBtn;
@property (weak, nonatomic) IBOutlet UIButton *fifthBtn;
@property (weak, nonatomic) IBOutlet UIButton *sixthBtn;


@end

@implementation ForceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    


}




- (void)viewWillAppear:(BOOL)animated{
    
    int optionOfOperators = [self getRandomNumber:0 to:2];
    int optionOfBtns = [self getRandomNumber:0 to:5];
    
    NSString *operator;
    switch (optionOfOperators) {
        case 0:
            operator = @"+";
            break;
        case 1:
            operator = @"-";
            break;
        case 2:
            operator = @"X";
            break;
        default:
            break;
    }
    self.operatorLabel.text = operator;
    if ([operator containsString:@"+"]) {
        self.firstNumLabel.text = [NSString stringWithFormat:@"%d",[self getRandomNumber:1000 to:9999]];
        self.secondNumLabel.text = [NSString stringWithFormat:@"%d",[self getRandomNumber:1000 to:9999]];
        correctOperation = [self.firstNumLabel.text intValue] + [self.secondNumLabel.text intValue];
    }else if ([operator containsString:@"-"]){
        self.firstNumLabel.text = [NSString stringWithFormat:@"%d",[self getRandomNumber:1000 to:9999]];
        self.secondNumLabel.text = [NSString stringWithFormat:@"%d",[self getRandomNumber:1000 to:9999]];
        correctOperation = [self.firstNumLabel.text intValue] - [self.secondNumLabel.text intValue];
    }
    else{
        self.firstNumLabel.text = [NSString stringWithFormat:@"%d",[self getRandomNumber:10 to:99]];
        self.secondNumLabel.text = [NSString stringWithFormat:@"%d",[self getRandomNumber:10 to:99]];
        correctOperation = [self.firstNumLabel.text intValue] * [self.secondNumLabel.text intValue];
    }
    
    
    switch (optionOfBtns) {
        case 0:
            [self.firstBtn setTitle:[NSString stringWithFormat:@"%d",correctOperation]forState:UIControlStateNormal];
            break;
        case 1:
            [self.secondBtn setTitle:[NSString stringWithFormat:@"%d",correctOperation]forState:UIControlStateNormal];            break;
        case 2:
            [self.thirdBtn setTitle:[NSString stringWithFormat:@"%d",correctOperation]forState:UIControlStateNormal];            break;
        case 3:
            [self.fourthBtn setTitle:[NSString stringWithFormat:@"%d",correctOperation]forState:UIControlStateNormal];            break;
        case 4:
            [self.fifthBtn setTitle:[NSString stringWithFormat:@"%d",correctOperation]forState:UIControlStateNormal];            break;
        case 5:
            [self.sixthBtn setTitle:[NSString stringWithFormat:@"%d",correctOperation]forState:UIControlStateNormal];            break;
        default:
            break;
    }
    int falseSelection = correctOperation;
    for (UIButton *btn in self.lowView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if (![btn.titleLabel.text isEqualToString:[NSString stringWithFormat:@"%d",correctOperation]]) {
                [btn setTitle:[NSString stringWithFormat:@"%d",++falseSelection]forState:UIControlStateNormal];
                
            }
        }
    }

    
}

- (int)getRandomNumber:(int)from to:(int)to{
    
    return (int)(from + (arc4random() % (to - from + 1)));
    
}


- (IBAction)firstBtnAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:[NSString stringWithFormat:@"%d",correctOperation]]) {
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(stopMusic)]) {
                [self.delegate stopMusic];
            }
        }];
    }
}
- (IBAction)secondBtnAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:[NSString stringWithFormat:@"%d",correctOperation]]) {
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(stopMusic)]) {
                [self.delegate stopMusic];
                
                [[HYLocalNotication shareHYLocalNotication]cancelLocalNotication:[self.Alert.clockID intValue]];
            }
        }];
    }
}
- (IBAction)thirdBtnAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:[NSString stringWithFormat:@"%d",correctOperation]]) {
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(stopMusic)]) {
                [self.delegate stopMusic];
                
                [[HYLocalNotication shareHYLocalNotication]cancelLocalNotication:[self.Alert.clockID intValue]];

            }
        }];
    }
}
- (IBAction)fourthBtnAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:[NSString stringWithFormat:@"%d",correctOperation]]) {
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(stopMusic)]) {
                [self.delegate stopMusic];
                
                [[HYLocalNotication shareHYLocalNotication]cancelLocalNotication:[self.Alert.clockID intValue]];
            }
        }];
    }
}
- (IBAction)fifthBtnAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:[NSString stringWithFormat:@"%d",correctOperation]]) {
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(stopMusic)]) {
                [self.delegate stopMusic];
                
                [[HYLocalNotication shareHYLocalNotication]cancelLocalNotication:[self.Alert.clockID intValue]];

            }
        }];
    }
}
- (IBAction)sixthBtnAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:[NSString stringWithFormat:@"%d",correctOperation]]) {
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(stopMusic)]) {
                [self.delegate stopMusic];
                
                [[HYLocalNotication shareHYLocalNotication]cancelLocalNotication:[self.Alert.clockID intValue]];

            }
        }];
    }
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
