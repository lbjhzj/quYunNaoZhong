//
//  mainSetViewController.h
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/15.
//  Copyright © 2016年 趣云科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mainSetViewController : UIViewController<SKPaymentTransactionObserver,SKProductsRequestDelegate>



+ (instancetype)sharedMainSetViewController;

@end
