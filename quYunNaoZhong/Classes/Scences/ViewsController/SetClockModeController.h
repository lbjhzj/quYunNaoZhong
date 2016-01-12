//
//  SetClockModeController.h
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/12.
//  Copyright © 2016年 趣云科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PassingTheClockModeDelegate <NSObject>

- (void)passingClockMode:(NSArray *)modeArray;

@end

@interface SetClockModeController : UIViewController

@property(nonatomic,assign)id <PassingTheClockModeDelegate> delegate;



@end
