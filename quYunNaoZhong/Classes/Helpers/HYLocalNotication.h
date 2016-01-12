//
//  HYLocalNotication.h
//  test
//
//  Created by 趣云科技 on 16/1/5.
//  Copyright © 2016年 趣云科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYLocalNotication : NSObject


+ (instancetype)shareHYLocalNotication;

- (void)startLocalNoticationInTheDate:(NSDate *)date soundName:(NSString *)sound alertBody:(NSString *)alertName clockID:(int)clockID;

- (void)cancelLocalNotication:(int)clockID;



@end