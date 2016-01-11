//
//  NSString+dateTransformToNSString.m
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/6.
//  Copyright © 2016年 趣云科技. All rights reserved.
//

#import "NSString+dateTransformToNSString.h"

@implementation NSString (dateTransformToNSString)

+ (NSString *)stringFromDate:(NSDate *)date ByFormatter:(NSDateFormatter *)formatter;
{
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

@end
