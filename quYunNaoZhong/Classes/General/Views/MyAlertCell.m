//
//  MyAlertCell.m
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/8.
//  Copyright © 2016年 趣云科技. All rights reserved.
//

#import "MyAlertCell.h"

@interface MyAlertCell ()



@end

@implementation MyAlertCell



- (IBAction)clockSwitchButton:(UIButton *)sender {
    alert *Alert = [[HYLocalNotication shareHYLocalNotication]findClockOfAllAlertsByIndexPath:[NSIndexPath indexPathForRow:self.clockID inSection:0]];
    if (Alert.clockState) {
        [sender setImage:[UIImage imageNamed:@"开关（关）"] forState:UIControlStateNormal ];
        [[HYLocalNotication shareHYLocalNotication] cancelLocalNotication:self.clockID];
    }else{
        [sender setImage:[UIImage imageNamed:@"开关（开）"] forState:UIControlStateNormal ];
        [[HYLocalNotication shareHYLocalNotication] startLocalNoticationClockID:self.clockID];
    }
        Alert.clockState = ! Alert.clockState;
    NSLog(@"%@",Alert.clockID);
    [[HYLocalNotication shareHYLocalNotication] saveClockData:Alert];
    
    
}



- (void)awakeFromNib {


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
