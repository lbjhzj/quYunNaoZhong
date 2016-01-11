//
//  MyClockViewController.h
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/8.
//  Copyright © 2016年 趣云科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyClockViewController : UIViewController

//广告框
@property (weak, nonatomic) IBOutlet GADBannerView *admodBannerView;


+ (instancetype)sharedMyClockViewController;

@end
