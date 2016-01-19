//
//  GADMasterViewController.h
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/19.
//  Copyright © 2016年 趣云科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GADMasterViewController : UIViewController
{
    GADBannerView *adBanner_;
    BOOL didCloseWebsiteView;
    BOOL isLoaded_;
    id currentDelegate_;
}

+(GADMasterViewController *)singleton;

-(void)resetAdView:(UIViewController *)rootViewController;


@end
