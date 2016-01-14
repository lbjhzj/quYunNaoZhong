//
//  MyAlertCell.h
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/8.
//  Copyright © 2016年 趣云科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAlertCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *clockTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *clockNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *clockModeLabel;

@property (weak, nonatomic) IBOutlet UIButton *clockStateBtn;

@end
