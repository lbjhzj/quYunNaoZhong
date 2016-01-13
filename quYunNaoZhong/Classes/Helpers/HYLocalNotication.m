//
//  HYLocalNotication.m
//  test
//
//  Created by 趣云科技 on 16/1/5.
//  Copyright © 2016年 趣云科技. All rights reserved.
//

#import "HYLocalNotication.h"

@implementation HYLocalNotication

+ (instancetype)shareHYLocalNotication{
    static HYLocalNotication *hyLocalNotication = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hyLocalNotication = [[HYLocalNotication alloc] init];
    });
    return hyLocalNotication;
}



- (void)startLocalNoticationClockID:(int)clockID
{
    [self cancelLocalNotication:clockID];
        
    NSString *clockIDString = [NSString stringWithFormat:@"%d", clockID];

    //-----获取闹钟数据---------------------------------------------------------
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *clockDictionary = [userDefault objectForKey:clockIDString];
    
    NSString *clockTime = [clockDictionary objectForKey:@"ClockTime"];
    NSString *clockMode = [clockDictionary objectForKey:@"ClockMode"];
    NSString *clockMusic = [clockDictionary objectForKey:@"ClockMusic"];
    NSString *clockRemember = [clockDictionary objectForKey:@"ClockRemember"];

    //-----组建本地通知的fireDate-----------------------------------------------
    
    //------------------------------------------------------------------------
    NSArray *clockTimeArray = [clockTime componentsSeparatedByString:@":"];
    NSDate *dateNow = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    //[calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    //[comps setTimeZone:[NSTimeZone timeZoneWithName:@"CMT"]];
    NSInteger unitFlags = NSEraCalendarUnit |
    NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit |
    NSWeekCalendarUnit |
    NSWeekdayCalendarUnit |
    NSWeekdayOrdinalCalendarUnit |
    NSQuarterCalendarUnit;
    
    comps = [calendar components:unitFlags fromDate:dateNow];
    [comps setHour:[[clockTimeArray objectAtIndex:0] intValue]];
    [comps setMinute:[[clockTimeArray objectAtIndex:1] intValue]];
    [comps setSecond:0];
    
    //------------------------------------------------------------------------
    Byte weekday = [comps weekday];
    NSArray *array = [[clockMode substringFromIndex:1] componentsSeparatedByString:@"、"];
    Byte i = 0;
    Byte j = 0;
    int days = 0;
    int	temp = 0;
    Byte count = [array count];
    Byte clockDays[7];
    
    NSArray *tempWeekdays = [NSArray arrayWithObjects:@"日", @"一", @"二", @"三", @"四", @"五", @"六", nil];
    //查找设定的周期模式
    for (i = 0; i < count; i++) {
        for (j = 0; j < 7; j++) {
            if ([[array objectAtIndex:i] isEqualToString:[tempWeekdays objectAtIndex:j]]) {
                clockDays[i] = j + 1;
                break;
            }
        }
    }
    
    for (i = 0; i < count; i++) {
        temp = clockDays[i] - weekday;
        days = (temp >= 0 ? temp : temp + 7);
        NSDate *newFireDate = [[calendar dateFromComponents:comps] dateByAddingTimeInterval:3600 * 24 * days];
        
        UILocalNotification *newNotification = [[UILocalNotification alloc] init];
        if (newNotification) {
            newNotification.fireDate = newFireDate;
            newNotification.alertBody = clockRemember;
            newNotification.soundName = [NSString stringWithFormat:@"%@.caf", clockMusic];
            newNotification.alertAction = @"查看闹钟";
            newNotification.repeatInterval = NSWeekCalendarUnit;
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:clockIDString forKey:@"ActivityClock"];
            newNotification.userInfo = userInfo;
            [[UIApplication sharedApplication] scheduleLocalNotification:newNotification];
        }
        NSLog(@"Post new localNotification:%@", [newNotification fireDate]);
        
    }

//    if (notication) {
//
////        设置本地推送时间
//        notication.fireDate = date;
//    
////        设置时区
//        notication.timeZone = [NSTimeZone defaultTimeZone];
//        
////        设置重复间隔
//        notication.repeatInterval = NSCalendarUnitWeekOfMonth;
//        
////        设置闹钟声音
//        notication.soundName = sound;
//        
////        设置闹钟提示信息
//        notication.alertBody = [NSString stringWithFormat:@"%@的时间到了!",alertName];
//        
//        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:clockIDString forKey:@"ActivityClock"];
//        
//        notication.userInfo = userInfo;//添加额外的信息
//
//        [[UIApplication sharedApplication] scheduleLocalNotification:notication];
//    }

}

- (void)cancelLocalNotication:(int)clockID{
    NSArray *localNotications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notication in localNotications) {
        if ([[[notication userInfo] objectForKey:@"ActivityClock"] intValue] == clockID) {
            NSLog(@"Cancel localNotication:%@",[notication fireDate]);
            [[UIApplication sharedApplication] cancelLocalNotification:notication];
        }
    }
}

- (alert *)findClockOfAllAlertsByIndexPath:(NSIndexPath *)indexPath{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *clockDictionary = [userDefault objectForKey:[NSString stringWithFormat:@"%ld", indexPath.row]];
    
    alert *Alert = [alert new];
    
    Alert.clockState = [[clockDictionary objectForKey:@"ClockState"] boolValue];
    Alert.clockMode = [clockDictionary objectForKey:@"ClockMode"];
    Alert.clockRemember = [clockDictionary objectForKey:@"ClockRemember"];
    Alert.clockName = [clockDictionary objectForKey:@"ClockName"];
    Alert.clockTime = [clockDictionary objectForKey:@"ClockTime"];
    Alert.clockMusic = [clockDictionary objectForKey:@"ClockMusic"];
    Alert.clockType = [clockDictionary objectForKey:@"ClockType"];
    Alert.clockFitPeople = [clockDictionary objectForKey:@"ClockFitPeople"];
    Alert.clockID = [clockDictionary objectForKey:@"ClockID"];
    Alert.clockForce = [[clockDictionary objectForKey:@"ClockForce"] boolValue];
    Alert.clockShock = [[clockDictionary objectForKey:@"CLockShock"] boolValue];
    Alert.clockSoundValue = [[clockDictionary objectForKey:@"ClockSound"] integerValue];
    
    
    return Alert;
}

- (void)removeAllDataInUserDefault{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    for (int i=0; i<100; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
          [userDefault removeObjectForKey:key];
        [userDefault removeObjectForKey:@"ClockCount"];
    }
    
}

@end
