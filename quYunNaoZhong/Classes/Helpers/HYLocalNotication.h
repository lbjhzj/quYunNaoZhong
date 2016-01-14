//
//  HYLocalNotication.h
//  test
//
//  Created by 趣云科技 on 16/1/5.
//  Copyright © 2016年 趣云科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYLocalNotication : NSObject <AVAudioPlayerDelegate>
{
    AVAudioPlayer *musicPlayer;
    NSString *musicFileName;
    NSString *musicFileType;
}

+ (instancetype)shareHYLocalNotication;

- (void)startLocalNoticationClockID:(int)clockID;

- (void)cancelLocalNotication:(int)clockID;

- (alert *)findClockOfAllAlertsByIndexPath:(NSIndexPath *)indexPath;

- (void)removeAllDataInUserDefault;

@end
