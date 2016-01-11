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



- (IBAction)clockSwitchAction:(UIButton *)sender {
    
#warning 通过判断闹钟开启状态，修改开关状态
    [sender setImage:[UIImage imageNamed:@"开关（开）"] forState:UIControlStateNormal];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
