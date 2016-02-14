//
//  SetClockTimeController.m
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/11.
//  Copyright © 2016年 趣云科技. All rights reserved.
//

#import "SetClockTimeController.h"


@interface SetClockTimeController ()

@end

@implementation SetClockTimeController

- (IBAction)datePick:(UIDatePicker *)sender {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit;
    comps = [calendar components:unitFlags fromDate:sender.date];
    
    NSString *hoursStr=[NSString stringWithFormat:@"%ld",[comps hour]];;
    NSString *minutesStr=[NSString stringWithFormat:@"%ld",[comps minute]];;
    if ([comps minute] < 10 ){
        minutesStr = [NSString stringWithFormat:@"0%ld",[comps minute]];
    }
    if ([comps hour] < 10) {
        hoursStr = [NSString stringWithFormat:@"0%ld",[comps hour]];
    }
    self.timeLabel.text = [hoursStr stringByAppendingString:[NSString stringWithFormat:@":%@", minutesStr]];
    if ([comps minute] >10 && [comps hour] >10){
        self.timeLabel.text = [NSString stringWithFormat:@"%ld:%ld", [comps hour], [comps minute]];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    self.timeLabel.text = self.timeText;
    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.timeLabel.font = [UIFont fontWithName:@"DB LCD Temp" size:30.0f];
    
    
    self.datePicker.datePickerMode = UIDatePickerModeTime;

    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
//    NSArray * tempTimeArray = [[NSString stringFromDate:[NSDate date] ByFormatter:formatter] componentsSeparatedByString:@":"];
//    _timeLabel.text = [tempTimeArray[0] stringByAppendingString:[NSString stringWithFormat:@":%@", tempTimeArray[1]]];

    
}


- (IBAction)backToTheController:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark 确认增加闹钟时间
- (IBAction)AddAClockAction:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(passingClockTimeToHere:)]) {
        [_delegate passingClockTimeToHere:self.timeLabel.text];
    }

    [self.navigationController popViewControllerAnimated:YES];
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
