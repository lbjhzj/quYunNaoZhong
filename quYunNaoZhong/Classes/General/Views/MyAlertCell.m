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
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    alert *Alert = [alert new];
    if ([userDefault objectForKey:[NSString stringWithFormat:@"%d",self.clockID]]) {
        Alert = [[HYLocalNotication shareHYLocalNotication]findClockOfAllAlertsByIndexPath:[NSIndexPath indexPathForRow:self.clockID inSection:0]];
    }else{
        int biggerCount=0;
        int smallerCount = 0;
        int index = 0;
        for (int x=0; x<50; x++) {
            if ([userDefault objectForKey:[NSString stringWithFormat:@"%d",x]]) {
                if (x>self.clockID) {
                    biggerCount++;
                }else{
                    NSLog(@"%@",[userDefault objectForKey:[NSString stringWithFormat:@"%d",x]]);
                    smallerCount++;
                }
            }
        }
        index = self.clockID - smallerCount - biggerCount;
        NSArray *ttmpArray = [[HYLocalNotication shareHYLocalNotication] findClockOfDefaultPlist:(NSString *)[userDefault objectForKey:@"ClockFitPeople"]];
        NSMutableDictionary *ttmpDictionary = ttmpArray[index];
        [Alert setValuesForKeysWithDictionary:ttmpDictionary];
    }
  
    
    if (Alert.clockState) {
        [sender setImage:[UIImage imageNamed:@"开关（关）"] forState:UIControlStateNormal ];
        [[HYLocalNotication shareHYLocalNotication] cancelLocalNotication:self.clockID];
    }else{
        [sender setImage:[UIImage imageNamed:@"开关（开）"] forState:UIControlStateNormal ];
        [[HYLocalNotication shareHYLocalNotication] startLocalNoticationClockID:self.clockID];
    }
        Alert.clockState = ! Alert.clockState;
    NSLog(@"选中的clockID====%@",Alert.clockID);
    
    if ([ (NSString *)[userDefault objectForKey:@"ClockFitPeople"] isEqualToString:@"关闭"] ||![userDefault objectForKey:@"ClockFitPeople"] ) {
         [[HYLocalNotication shareHYLocalNotication] saveClockData:Alert];
    }else {
        if (!Alert.clockType) {
            [[HYLocalNotication shareHYLocalNotication] saveClockData:Alert];
        }else{
            [[HYLocalNotication shareHYLocalNotication]writeDataToDefaultPlist:Alert];
        }
        
        
    }
   
    
    
}



- (void)awakeFromNib {


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
