//
//  ForceViewController.h
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/19.
//  Copyright © 2016年 趣云科技. All rights reserved.
//
@protocol stopTheMusicDelegate <NSObject>

- (void)stopMusic;

@end
#import <UIKit/UIKit.h>

@interface ForceViewController : UIViewController

@property(nonatomic,assign)id <stopTheMusicDelegate> delegate;

@property(nonatomic,strong)alert * Alert;


@end
