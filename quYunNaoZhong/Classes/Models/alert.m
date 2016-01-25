//
//  alert.m
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/7.
//  Copyright © 2016年 趣云科技. All rights reserved.
//

#import "alert.h"

@implementation alert 

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"ClockRemember"]) {
        self.clockRemember = value;
    }
    if ([key isEqualToString:@"ClockTime"]) {
        self.clockTime = value;
    }
    if ([key isEqualToString:@"ClockForce"]) {
        self.clockType = value;
    }
    if ([key isEqualToString:@"ClockShock"]) {
        self.clockShock = value;
    }
    if ([key isEqualToString:@"ClockState"]) {
        self.clockState = [value boolValue];
    }
    if ([key isEqualToString:@"ClockMusic"]) {
        self.clockMusic = value;
    }
    if ([key isEqualToString:@"ClockName"]) {
        self.clockName = value;
    }
    if ([key isEqualToString:@"ClockSoundValue"]) {
        self.clockSoundValue = [value intValue];
    }
    if ([key isEqualToString:@"ClockMode"]) {
        self.clockMode = value;
    }
}

@end
