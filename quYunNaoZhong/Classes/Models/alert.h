//
//  alert.h
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/7.
//  Copyright © 2016年 趣云科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface alert : NSObject

//闹钟开关状态
@property(nonatomic,assign)BOOL clockState ;

//闹钟设定时间
@property(nonatomic,weak)NSString * clockTime;

//循环模式
@property(nonatomic,weak)NSString * clockMode;

//闹钟备注
@property(nonatomic,weak)NSString * clockRemember;

//闹钟名
@property(nonatomic,weak)NSString * clockName;

//闹钟铃声
@property(nonatomic,weak)NSString * clockMusic;

//预设闹钟还是自定义闹钟
@property(nonatomic,weak)NSString * clockType;

//闹钟适用人群
@property(nonatomic,weak)NSString * clockFitPeople;

//clockID就是闹钟的个数中的顺序位数  ***********根据clockID作为key值将闹钟存入NSUserDefaults中***************
@property(nonatomic,weak)NSString * clockID;

//是否强制叫醒
@property(nonatomic,assign)BOOL  clockForce;

//闹钟震动开关
@property(nonatomic,assign)BOOL  clockShock;


//闹钟音量
@property(nonatomic,assign)NSInteger  clockSoundValue;



@end
