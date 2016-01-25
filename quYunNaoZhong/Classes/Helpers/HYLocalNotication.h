//
//  HYLocalNotication.h
//  test
//
//  Created by 趣云科技 on 16/1/5.
//  Copyright © 2016年 趣云科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYLocalNotication : NSObject <AVAudioPlayerDelegate>

+ (instancetype)shareHYLocalNotication;

- (void)startLocalNoticationClockID:(int)clockID;

- (void)cancelLocalNotication:(int)clockID;

- (alert *)findClockOfAllAlertsByIndexPath:(NSIndexPath *)indexPath;

- (NSMutableArray *)findClockOfDefaultPlist:(NSString *)sectionName;

- (void)changeClockOfDefaultPlist:(NSString *)sectionName AtIndexPath:(NSIndexPath *)indexPath withAlert:(alert *)Alert;

- (void)removeAllDataInUserDefault;

- (void)saveClockData:(alert *)Alert;

-(void)vibratePlay:(NSInteger*)num;

+(NSArray *) getFilenamelistOfType:(NSString *)type fromDirPath:(NSString *)dirPath;

- (void)writeDataToDefaultPlist:(NSString *)type toDirPath:(NSString *)dirPath;

- (void)removeClockDataWithClockID:(int)clockID;
@end
