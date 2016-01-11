//
//  SetClockViewController.h
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/8.
//  Copyright © 2016年 趣云科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SetClockTimeController;



@interface SetClockViewController : UIViewController
{
    SetClockTimeController *setClockTimeController;
    
    
    
    
}



//传入闹钟模型接口
@property(nonatomic,strong)alert * Alert;


@property(nonatomic,strong)UILabel * clockNameLabel;

@property(nonatomic,strong)UILabel * clockTimeLabel;

@property(nonatomic,strong)UILabel * clockModeLabel;

@property(nonatomic,strong)UILabel * clockMusicLabel;

@property(nonatomic,strong)UILabel * clockExtendLabel;

@property(nonatomic,strong)UISlider * clockSoundValueLabel;


+ (instancetype)sharedSetClockViewController;


@end
