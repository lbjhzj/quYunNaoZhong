//
//  SetClockExtendViewController.h
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/25.
//  Copyright © 2016年 趣云科技. All rights reserved.
//

@protocol passingSelectedClockExtendToHere <NSObject>

- (void)passingTheClockExtendToHere:(NSString *)clockExtend;

@end
#import <UIKit/UIKit.h>

@interface SetClockExtendViewController : UIViewController


@property(nonatomic,assign)id <passingSelectedClockExtendToHere> delegate;

@property(nonatomic,strong)NSString * clockExtend;


@end
