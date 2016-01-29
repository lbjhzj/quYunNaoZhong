//
//  SetClockViewController.h
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/8.
//  Copyright © 2016年 趣云科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SetClockTimeController;
@class SetClockModeController;
@class SetClockMusicViewController;
@class SetClockExtendViewController;
@interface SetClockViewController : UIViewController
{
    SetClockTimeController *setClockTimeController;
    SetClockModeController *setClockModeController;
    SetClockMusicViewController *setClockMusicController;
    SetClockExtendViewController *setClockExtendViewController;
    
}

@property(nonatomic,assign)int  clockCount;

@property(nonatomic,assign)int  clockID;


//点击了第一个闹钟还是添加闹钟判断
@property(nonatomic,weak)NSString * clickTheFirstOrAddBtnFlag;

@property(nonatomic,strong)NSString * fromMainOrMyVCFlag;

//传入闹钟模型接口
@property(nonatomic,strong)alert * Alert;

@property(nonatomic,assign)BOOL  passingFlag;

@property(nonatomic,strong)UITextField * clockNameLabel;

@property(nonatomic,strong)UILabel * clockTimeLabel;

@property(nonatomic,strong)UILabel * clockModeLabel;

@property(nonatomic,strong)UILabel * clockMusicLabel;
//小睡
@property(nonatomic,strong)UILabel * clockExtendLabel;

@property(nonatomic,strong)UISlider * clockSoundValueLabel;


+ (instancetype)sharedSetClockViewController;


@end
