//
//  SetClockTimeController.h
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/11.
//  Copyright © 2016年 趣云科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PassingTheClockTimeDelegate <NSObject>


- (void)passingClockTimeToHere:(NSString *)clockTime;

@end

@interface SetClockTimeController : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property(nonatomic,assign)id <PassingTheClockTimeDelegate> delegate;

- (void)restoreGUI;

@end
