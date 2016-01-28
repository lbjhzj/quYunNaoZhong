//
//  alertCell.m
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/7.
//  Copyright © 2016年 趣云科技. All rights reserved.
//

#import "alertCell.h"

@interface alertCell ()
{
    MainViewController *mainVC;
}
@end

@implementation alertCell


- (void)awakeFromNib {
    mainVC = [[MainViewController alloc]init];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(makeBigger)];
    [self.remarkLabel addGestureRecognizer:gesture];
    
}
- (void)makeBigger{
    CGRect frame=self.frame;
    if (self.isOpen) {
        self.remarkLabel.numberOfLines = 1;
        CGSize newSize = [MainViewController labelheight:self.remarkLabel];
        
        frame.size.height = frame.size.height-newSize.height;
//        self.frame = frame;
        self.isOpen = NO;
       
    }else{
        self.remarkLabel.numberOfLines = 0;
        CGSize newSize = [MainViewController labelheight:self.remarkLabel];
        frame.size.height = frame.size.height+newSize.height;
//        self.frame = frame;
        self.isOpen = YES;
    }
    //添加 字典，将label的值通过key值设置传递
    NSString *newFramStr = NSStringFromCGRect(frame);
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:newFramStr,@"newFrame",[NSString stringWithFormat:@"%ld",self.index],@"index", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"makeItBigger" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
   
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
