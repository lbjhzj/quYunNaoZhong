//
//  SetClockMusicViewController.h
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/14.
//  Copyright © 2016年 趣云科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PassingTheClockMusicDelegate <NSObject>

- (void)passingTheClockMusicToFront:(NSString *)musicName;

@end

@interface SetClockMusicViewController : UIViewController <AVAudioPlayerDelegate>
{
    AVAudioRecorder * recorder;
    NSDictionary *recorderSettingsDict;
    //定时器
    NSTimer *timer;
    double lowPassResults;
    //录音名字
    NSString *playName;
}
@property(nonatomic,assign)id <PassingTheClockMusicDelegate> delegate;



@end
