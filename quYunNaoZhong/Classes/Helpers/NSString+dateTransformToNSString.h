//
//  NSString+dateTransformToNSString.h
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/6.
//  Copyright © 2016年 趣云科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (dateTransformToNSString)

+ (NSString *)stringFromDate:(NSDate *)date ByFormatter:(NSDateFormatter *)formatter;

+(NSString *)translation:(NSString *)arebic;

@end
