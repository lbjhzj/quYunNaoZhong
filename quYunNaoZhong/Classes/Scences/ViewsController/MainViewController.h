//
//  MainViewController.h
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/6.
//  Copyright © 2016年 趣云科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITableView *tableView;
+ (CGSize)labelheight:(UILabel *)detlabel;
@end
