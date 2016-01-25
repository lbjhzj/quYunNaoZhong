//
//  FitPeopleViewController.h
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/22.
//  Copyright © 2016年 趣云科技. All rights reserved.
//
@protocol passingSelectedModeDelegate <NSObject>

- (void)passingTheSelectedModeAction:(NSString *)selectedMode;

@end
#import <UIKit/UIKit.h>

@interface FitPeopleViewController : UIViewController



@property(nonatomic,assign)id <passingSelectedModeDelegate> delegate;

@end
