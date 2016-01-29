//
//  HYLocalNotication.m
//  test
//
//  Created by 趣云科技 on 16/1/5.
//  Copyright © 2016年 趣云科技. All rights reserved.
//

#import "HYLocalNotication.h"

@implementation HYLocalNotication

 int number = 0;

+ (instancetype)shareHYLocalNotication{
    static HYLocalNotication *hyLocalNotication = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hyLocalNotication = [[HYLocalNotication alloc] init];
    });
    return hyLocalNotication;
}



/**
 * 震动
 **/
-(void)vibratePlay{
    [self vibratePlay:1];
}

/**
 * 震动
 * @param num 震动次数
 **/
-(void)vibratePlay:(NSInteger*)num{
    
    AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL, audioPlayFinish,num);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    number++;
}

/**
 * 播放完成之后的回调方法
 * @param soundID 播放的声音ID
 * @param num 播放次数
 **/
void audioPlayFinish(SystemSoundID soundID,NSInteger* num){
    if (num&&num>0) {
        if (number>=num) {
            if (soundID!=kSystemSoundID_Vibrate) {
                AudioServicesDisposeSystemSoundID(soundID);
            }
        }else{
            AudioServicesPlaySystemSound(soundID);
            number++;
        }
    }else{
        if (soundID!=kSystemSoundID_Vibrate) {
            AudioServicesDisposeSystemSoundID(soundID);
        }
    }
}

- (BOOL)ifTheClockDateIsCurrentDateInEnglishLanguage:(NSString *)ClockDate{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd (ccc)"];
    NSString *dateMode=[NSString stringFromDate:[NSDate date] ByFormatter:formatter];
    NSString *enClockMode = [(NSString *)[dateMode componentsSeparatedByString:@"("][1] componentsSeparatedByString:@")"][0];
    if ([enClockMode containsString:@"Sun"]) {
        if ([ClockDate containsString:@"日"]) {
            return YES;
        }
    }else if ([enClockMode containsString:@"Mon"]){
        if ([ClockDate containsString:@"一"]) {
            return YES;
        }
        
    }else if ([enClockMode containsString:@"Tue"]){
        if ([ClockDate containsString:@"二"]) {
            return YES;
        }
        
    }else if ([enClockMode containsString:@"Wed"]){
        if ([ClockDate containsString:@"三"]) {
            return YES;
        }
        
    }else if ([enClockMode containsString:@"Thu"]){
        if ([ClockDate containsString:@"四"]) {
            return YES;
        }
        
    }else if ([enClockMode containsString:@"Fri"]){
        if ([ClockDate containsString:@"五"]) {
            return YES;
        }
        
    }else if ([enClockMode containsString:@"Sat"]){
        if ([ClockDate containsString:@"六"]) {
            return YES;
        }
        
    }
    
    return NO;
}

- (void)saveClockData:(alert *)Alert{
    
    NSMutableDictionary *clockDictionary = [NSMutableDictionary dictionaryWithCapacity:12];

    if (Alert.clockState) {
        [clockDictionary setObject:[NSString stringWithFormat:@"YES"] forKey:@"ClockState"];
    }else{
        [clockDictionary setObject:[NSString stringWithFormat:@"NO"] forKey:@"ClockState"];
    }
    if (Alert.clockForce) {
        [clockDictionary setObject:@"YES" forKey:@"ClockForce"];
    }else{
        [clockDictionary setObject:@"NO" forKey:@"ClockForce"];
    }
    if (Alert.clockShock) {
        [clockDictionary setObject:@"YES" forKey:@"ClockShock"];
    }else{
        [clockDictionary setObject:@"NO" forKey:@"ClockShock"];
    }
    [clockDictionary setObject:Alert.clockTime forKey:@"ClockTime"];
    [clockDictionary setObject:Alert.clockMode forKey:@"ClockMode"];
    [clockDictionary setObject:Alert.clockName forKey:@"ClockName"];
    [clockDictionary setObject:Alert.clockID forKey:@"ClockID"];

    if (!Alert.clockMusic) {
        Alert.clockMusic = @"未设置";
    }
    [clockDictionary setObject:Alert.clockMusic forKey:@"ClockMusic"];
    if (!Alert.clockExtend) {
        Alert.clockExtend = @"未设置";
    }
    [clockDictionary setObject:Alert.clockExtend forKey:@"ClockExtend"];
    [clockDictionary setObject:[NSString stringWithFormat:@"%ld",Alert.clockSoundValue] forKey:@"ClockSoundValue"];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:clockDictionary forKey:Alert.clockID];
//        NSLog(@"clockID======%@",Alert.clockID);
    
//    NSLog(@"%@",clockDictionary);
    

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
    NSString *clockForceSwitch = [clockDictionary objectForKey:@"ClockForce"];
    NSString *clockRemember = [clockDictionary objectForKey:@"ClockRemember"];
    NSString *clockExtend = [clockDictionary objectForKey:@"ClockExtend"];
    NSString *clockType = [clockDictionary objectForKey:@"ClockType"];
    NSString *clockName = [clockDictionary objectForKey:@"ClockName"];
    int ClockCount = [[userDefault objectForKey:@"ClockCount"] intValue];
    
    if (!clockDictionary) {
        NSArray *ttmpArray = [self findClockOfDefaultPlist:(NSString *)[userDefault objectForKey:@"ClockFitPeople"]];
        int index;
        if (ClockCount == 8) {
            index = clockID;
        }else{
            int biggerCount=0;
            int smallerCount = 0;
            for (int x=0; x<50; x++) {
                if ([userDefault objectForKey:[NSString stringWithFormat:@"%d",x]]) {
                    if (x>clockID) {
                        biggerCount++;
                    }else{
                        smallerCount++;
                    }
                }
            }
            index = clockID - smallerCount - biggerCount;
        }
        
        NSMutableDictionary *ttmpDictionary = ttmpArray[index];
        
        clockTime = [ttmpDictionary objectForKey:@"ClockTime"];
        clockMode = [ttmpDictionary objectForKey:@"ClockMode"];
        clockMusic = [ttmpDictionary objectForKey:@"ClockMusic"];
        clockForceSwitch = [ttmpDictionary objectForKey:@"ClockForce"];
        clockRemember = [ttmpDictionary objectForKey:@"ClockRemember"];
        clockExtend = [ttmpDictionary objectForKey:@"ClockExtend"];
        clockName = [ttmpDictionary objectForKey:@"ClockName"];
        clockType = [ttmpDictionary objectForKey:@"ClockType"];
    }

    //-----组建本地通知的fireDate-----------------------------------------------
    
    //------------------------------------------------------------------------
    NSArray *clockTimeArray = [clockTime componentsSeparatedByString:@":"];
    
    NSDate *dateNow = [NSDate date];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //    identifier的范围可以是：
    /**
     NSGregorianCalendar   阳历
     NSBuddhisCalendar     佛历
     NSChineseCalendar     中国日历
     NSHebrewCalendar      希伯来日历
     NSIslamicCalendar     伊斯兰日历
     NSIslamicCivilCalendar伊斯兰民事日历
     NSJapaneseCalendar    日本日历
     
     这里选择的是中国阳历
     */
    
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
//    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
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
    
//    从NSDate提取年，月，日，时，分，秒各个字段的信息
    comps = [calendar components:unitFlags fromDate:dateNow];
    [comps setHour:[[clockTimeArray objectAtIndex:0] intValue]];
    [comps setMinute:[[clockTimeArray objectAtIndex:1] intValue]];
    [comps setSecond:0];

    
    //------------------------------------------------------------------------
    Byte weekday = [comps weekday];
    NSArray *array = [clockMode  componentsSeparatedByString:@","];
    
    
//    NSLog(@"ClockModeArray==%@",array);
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
//            newNotification.fireDate = newFireDate;
#warning 测试
            newNotification.alertBody = clockName;
            
            if ([clockMusic containsString:@"未设置"] || clockMusic.length == 0 ||!clockMusic) {
                newNotification.soundName = UILocalNotificationDefaultSoundName;
            }else{
                newNotification.soundName = [NSString stringWithFormat:@"%@.mp3", clockMusic];
            }
           
//                NSLog(@"clockMusic======%@",clockMusic);
//                newNotification.soundName = [NSString stringWithFormat:@"%@.aac", clockMusic];
        

            newNotification.alertAction = @"查看闹钟";
            newNotification.repeatInterval = NSWeekCalendarUnit;
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:clockIDString forKey:@"ActivityClock"];
            newNotification.userInfo = userInfo;
            
            if ([clockForceSwitch isEqualToString:@"YES"]) {
                for (int i=0; i<5; i++) {
                    
//                    是否开启了小睡功能
                    if (![clockExtend containsString:@"未设置"]&&clockExtend){
                       newNotification.fireDate = [newFireDate dateByAddingTimeInterval:[[clockExtend componentsSeparatedByString:@"分钟"][0] intValue]*i*60];
                        NSLog(@"小睡了%d分",[[clockExtend componentsSeparatedByString:@"分钟"][0] intValue]);
                    }else{
                       newNotification.fireDate = [newFireDate dateByAddingTimeInterval:30*i];
                    }
                    
//                    判断是否是强制叫醒后的第二次打开，为用户关闭后几次强制闹钟
                    if ([[NSDate date] compare:newNotification.fireDate]==-1) {
                        newNotification.fireDate = [newFireDate dateByAddingTimeInterval:3600*24*7+i*30];
                        NSLog(@"您刚刚从强制叫醒闹钟醒来，现在为您开启下一周的闹钟");
                    }
                   
                    if (![clockMode containsString:@"未设置"] && clockMode) {
                        
                    [[UIApplication sharedApplication] scheduleLocalNotification:newNotification];
                        
                     NSLog(@"已开启强制叫醒");
                        
                    NSLog(@"Post new localNotification:%@", [[newNotification fireDate]dateByAddingTimeInterval:3600*8]);  
                    }

                }
            }
            else{
                for (int i=0; i<3; i++) {
                    if (![clockExtend containsString:@"未设置"]&&clockExtend){
   
                        
                        newNotification.fireDate = [newFireDate dateByAddingTimeInterval:[[clockExtend componentsSeparatedByString:@"分钟"][0] intValue]*i*60];
  
                        if (![clockMode containsString:@"未设置"] && clockMode){
                            
                        [[UIApplication sharedApplication] scheduleLocalNotification:newNotification];
                        NSLog(@"Post new localNotification:%@", [[newNotification fireDate]dateByAddingTimeInterval:3600*8]);
                        NSLog(@"小睡了%d分",[[clockExtend componentsSeparatedByString:@"分钟"][0] intValue]);
                        }

                    }else{
                        newNotification.fireDate = [newFireDate dateByAddingTimeInterval:i*30];
                        if (![clockMode containsString:@"未设置"] && clockMode){
                            
                        [[UIApplication sharedApplication] scheduleLocalNotification:newNotification];
                        NSLog(@"Post new localNotification:%@", [[newNotification fireDate]dateByAddingTimeInterval:3600*8]);
                            
                        }
                        
                    }

                }

            }

            
        }
//        NSLog(@"设定的闹钟日期为%@",[newFireDate dateByAddingTimeInterval:8 * 3600]);
//        NSLog(@"Post new localNotification:%@", [newNotification fireDate]);
        
    }

}

- (void)cancelLocalNotication:(int)clockID{
    NSArray *localNotications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for (UILocalNotification *notication in localNotications) {
        if ([[[notication userInfo] objectForKey:@"ActivityClock"] intValue] == clockID) {
            NSLog(@"Cancel localNotication:%@",[[notication fireDate]dateByAddingTimeInterval:3600*8]);
            [[UIApplication sharedApplication] cancelLocalNotification:notication];
        }
    }
}

- (NSArray *)findClockOfDefaultPlist:(NSString *)sectionName{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"defaultClock" ofType:@"plist"];

    //获取本地沙盒路径
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *plistPath1 = [documentsPath stringByAppendingPathComponent:@"defaltClock.plist"];
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath1];
    if (data) {
        
    }else{
        data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        
    }
    NSArray *array = [data objectForKey:sectionName];
    
    
    return array;
    
//    NSMutableArray *clockArray = [NSMutableArray arrayWithCapacity:8];
//    for (NSDictionary *dictionary in array) {
//        alert *Alert = [alert new];
//        
//        [Alert setValuesForKeysWithDictionary:dictionary];
//
//        [clockArray addObject:Alert];
//    }

}

- (void)writeDataToDefaultPlist:(alert *)Alert{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *sectionName = [userDefault objectForKey:@"ClockFitPeople"];
     NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"defaultClock" ofType:@"plist"];
    //获取本地沙盒路径
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *plistPath1 = [documentsPath stringByAppendingPathComponent:@"defaltClock.plist"];
    

    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath1];
    NSMutableArray *array = [data objectForKey:sectionName];
    if (data) {
        
    }else{
        data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        
    }

    if (Alert) {
            for (int x=0;x<8;x++) {
        NSDictionary *dictionary =array[x];
        if ([Alert.clockRemember isEqualToString:[dictionary objectForKey:@"ClockRemember"]]) {
            [dictionary setValue:Alert.clockMusic forKey:@"ClockMusic"];
            [dictionary setValue:Alert.clockMode forKey:@"ClockMode"];
            [dictionary setValue:Alert.clockName forKey:@"ClockName"];
            [dictionary setValue:Alert.clockExtend forKey:@"ClockExtend"];
            [dictionary setValue:Alert.clockTime forKey:@"ClockTime"];
#pragma mark 检查默认闹钟的id号
            [dictionary setValue:Alert.clockID forKey:@"ClockID"];
            if (Alert.clockState) {
                [dictionary setValue:[NSString stringWithFormat:@"YES"] forKey:@"ClockState"];
            }else{
                [dictionary setValue:[NSString stringWithFormat:@"NO"] forKey:@"ClockState"];
            }
            if (Alert.clockForce) {
                [dictionary setValue:@"YES" forKey:@"ClockForce"];
            }else{
                [dictionary setValue:@"NO" forKey:@"ClockForce"];
            }
            array[x] = dictionary;
            break;
        }
    }
}
    if (array) {
        [data setValue:array forKey:sectionName];
    }
    

    [data writeToFile:plistPath1 atomically:YES];
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
    Alert.clockExtend = [clockDictionary objectForKey:@"ClockExtend"];
    Alert.clockForce = [[clockDictionary objectForKey:@"ClockForce"] boolValue];
    Alert.clockShock = [[clockDictionary objectForKey:@"ClockShock"] boolValue];
    Alert.clockSoundValue = [[clockDictionary objectForKey:@"ClockSoundValue"] integerValue];
    
    
    return Alert;
}

+(NSArray *)getFilenamelistOfType:(NSString *)type fromDirPath:(NSString *)dirPath
{
    NSMutableArray *filenamelist = [NSMutableArray arrayWithCapacity:10];
    NSArray *tmplist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:nil];
    
    for (NSString *filename in tmplist) {
        NSString *fullpath = [dirPath stringByAppendingPathComponent:filename];
        if ([self isFileExistAtPath:fullpath]) {
            if ([[filename pathExtension] isEqualToString:type]) {
                [filenamelist  addObject:filename];
            }
        }
    }
    
    return filenamelist;
}



+(BOOL)isFileExistAtPath:(NSString*)fileFullPath {
    BOOL isExist = NO;
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath];
    return isExist;
}


- (void)removeAllDataInUserDefault{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    for (int i=0; i<100; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
          [userDefault removeObjectForKey:key];
        [userDefault removeObjectForKey:@"ClockCount"];
    }
    
}

- (void)removeClockDataWithClockID:(int)clockID{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSInteger clockCount = [[userDefault objectForKey:@"ClockCount"] integerValue];
    if (clockCount>2) {
      --clockCount;
        [userDefault setObject:[NSString stringWithFormat:@"%ld",clockCount] forKey:@"ClockCount"];
    }else{
        if (clockCount >=1) {
            --clockCount;
            [userDefault setObject:[NSString stringWithFormat:@"%ld",clockCount] forKey:@"ClockCount"];
        }

//        [userDefault removeObjectForKey:@"ClockCount"];
    }
    [self cancelLocalNotication:clockID];
    
    [userDefault removeObjectForKey:[NSString stringWithFormat:@"%d",clockID]];
}

- (void)removeDefaultClockDataInDocument:(alert *)Alert{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSInteger clockCount = [[userDefault objectForKey:@"ClockCount"] integerValue];
    if (clockCount>2) {
        --clockCount;
        [userDefault setObject:[NSString stringWithFormat:@"%ld",clockCount] forKey:@"ClockCount"];
    }else{
        if (clockCount >=1) {
            --clockCount;
            [userDefault setObject:[NSString stringWithFormat:@"%ld",clockCount] forKey:@"ClockCount"];
        }
        
        
        
    }
    //获取本地沙盒路径
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *plistPath1 = [documentsPath stringByAppendingPathComponent:@"defaltClock.plist"];
    NSString *sectionName = [userDefault objectForKey:@"ClockFitPeople"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath1];
    NSMutableArray *array = [data objectForKey:sectionName];
    if (Alert) {
        for (NSInteger x=0;x<8;x++) {
            NSDictionary *dictionary =array[x];
            if ([Alert.clockRemember isEqualToString:[dictionary objectForKey:@"ClockRemember"]]) {

                [array removeObjectAtIndex:x];
                break;
            }
        }
        
    }
    
    [self cancelLocalNotication:[Alert.clockID intValue]];
    [data setValue:array forKey:sectionName];
    
    [data writeToFile:plistPath1 atomically:YES];
    

}

- (void)removeAllDefaultClockData{
    //获取本地沙盒路径
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *plistPath1 = [documentsPath stringByAppendingPathComponent:@"defaltClock.plist"];

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *sectionName = [userDefault objectForKey:@"ClockFitPeople"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath1];
    NSMutableArray *array = [data objectForKey:sectionName];
    if (array && array.count) {
        for (NSDictionary *dictionary in array) {
            alert *Alert = [[alert alloc]init];
            [Alert setValuesForKeysWithDictionary:dictionary];
            if(Alert.clockState){
                [self cancelLocalNotication:[Alert.clockID intValue]];
            }
        }
    }

    
    
    NSFileManager *manager = [[NSFileManager alloc] init];
    [manager removeItemAtPath:plistPath1 error:nil];
}


@end
