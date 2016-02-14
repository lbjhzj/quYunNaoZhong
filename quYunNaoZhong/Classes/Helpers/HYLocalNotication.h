//
//  HYLocalNotication.h
//  test
//
//  Created by 趣云科技 on 16/1/5.
//  Copyright © 2016年 趣云科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYLocalNotication : NSObject <AVAudioPlayerDelegate>


@property(nonatomic,assign)NSCalendarUnit clockRepeatCount;

+ (instancetype)shareHYLocalNotication;

- (void)startLocalNoticationClockID:(int)clockID;

- (void)cancelLocalNotication:(int)clockID;

- (alert *)findClockOfAllAlertsByIndexPath:(NSIndexPath *)indexPath;

- (NSArray *)findClockOfDefaultPlist:(NSString *)sectionName;

- (void)changeClockOfDefaultPlist:(NSString *)sectionName AtIndexPath:(NSIndexPath *)indexPath withAlert:(alert *)Alert;

- (void)removeAllDataInUserDefault;

- (void)saveClockData:(alert *)Alert;

-(void)vibratePlay:(NSInteger*)num;

+(NSArray *) getFilenamelistOfType:(NSString *)type fromDirPath:(NSString *)dirPath;

- (void)writeDataToDefaultPlist:(alert *)Alert;

- (void)removeClockDataWithClockID:(int)clockID;

- (void)removeDefaultClockDataInDocument:(alert *)Alert;

- (void)removeAllDefaultClockData;

- (BOOL)ifTheClockDateIsCurrentDateInEnglishLanguage:(NSString *)ClockDate;

@end
