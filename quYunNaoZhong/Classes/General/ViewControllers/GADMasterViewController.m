//
//  GADMasterViewController.m
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/19.
//  Copyright © 2016年 趣云科技. All rights reserved.
//

@import GoogleMobileAds;
#import "GADMasterViewController.h"

@interface GADMasterViewController ()<GADBannerViewDelegate>

@end

@implementation GADMasterViewController

+(GADMasterViewController *)singleton {
    static dispatch_once_t pred;
    static GADMasterViewController *shared;
    // Will only be run once, the first time this is called
    dispatch_once(&pred, ^{
        shared = [[GADMasterViewController alloc] init];
    });
    return shared;
}


-(id)init {
    if (self = [super init]) {
        adBanner_ = [[GADBannerView alloc]
                     initWithFrame:CGRectMake(0.5 * self.view.frame.size.width - 0.5 * GAD_SIZE_320x50.width,
                                              self.view.frame.size.height - GAD_SIZE_320x50.height,
                                              GAD_SIZE_320x50.width,
                                              GAD_SIZE_320x50.height)];
        // Has an ad request already been made
        isLoaded_ = NO;
    }
    return self;
}
-(void)resetAdView:(UIViewController *)rootViewController {
    // Always keep track of currentDelegate for notification forwarding
    currentDelegate_ = rootViewController;
    
    // Ad already requested, simply add it into the view
    if (isLoaded_) {
        [rootViewController.view addSubview:adBanner_];
    } else {
        
        adBanner_.delegate = self;
        adBanner_.rootViewController = rootViewController;
        adBanner_.adUnitID = @"ca-app-pub-3940256099942544/2934735716";

        GADRequest *request = [GADRequest request];
        request.testDevices = @[
                                @"5ff659b7225c70aee936a20c4c6236ad"  // Eric's iPod Touch
                                ];
        [adBanner_ loadRequest:request];
        [rootViewController.view addSubview:adBanner_];
        isLoaded_ = YES;
    }
}


- (void)adViewDidReceiveAd:(GADBannerView *)bannerView{
    [currentDelegate_ adViewDidReceiveAd:bannerView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
