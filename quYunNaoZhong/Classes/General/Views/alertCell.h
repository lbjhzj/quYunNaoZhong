//
//  alertCell.h
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/7.
//  Copyright © 2016年 趣云科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface alertCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UILabel *alertNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *alertWeekLabel;

@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@property (weak, nonatomic) IBOutlet UIImageView *moreInButton;




@end
