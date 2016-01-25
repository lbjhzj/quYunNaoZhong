//
//  mainSetViewController.m
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/15.
//  Copyright © 2016年 趣云科技. All rights reserved.
//

#import "mainSetViewController.h"

@interface mainSetViewController ()<UITableViewDataSource,UITableViewDelegate,passingSelectedModeDelegate,MFMailComposeViewControllerDelegate>
{
    GADMasterViewController *shared;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)UILabel * fitPeopleLabel;


@end

@implementation mainSetViewController
static NSString *cellID = @"cellID";

+ (instancetype)sharedMainSetViewController{
    static mainSetViewController * mainSetVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mainSetVC = [[mainSetViewController alloc] init];
    });
    return mainSetVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fitPeopleLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, self.view.frame.size.width-200, 44)];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    shared = [GADMasterViewController singleton];
    [shared resetAdView:self];
}

- (IBAction)makeSureBtnAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)backToVCAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"推荐闹钟设置";
            [cell.contentView addSubview:self.fitPeopleLabel];
            break;
        case 1:
            cell.textLabel.text = nil;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
            
        case 2:
            cell.textLabel.text = @"购买应用";
            break;
        case 3:
            cell.textLabel.text = @"告诉朋友";
            break;
        case 4:
            cell.textLabel.text = @"意见反馈";
            break;
        case 5:
            cell.textLabel.text = @"关于我们";
            break;
        default:
            break;
    }
    if (indexPath.row != 1) {
        
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (void)passingTheSelectedModeAction:(NSString *)selectedMode{

    self.fitPeopleLabel.text = selectedMode;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:{
           
            FitPeopleViewController *fit = [FitPeopleViewController new];
            fit.delegate = self;
             [self.navigationController pushViewController:fit animated:YES];
        }
            break;
        case 3:{
            UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:@[@"健康生活闹钟,https://itunes.apple.com/us/app/jian-kang-sheng-huo-nao-zhong/id1078158366?l=zh&ls=1&mt=8."] applicationActivities:nil];
            [self presentViewController:activityVC animated:YES completion:^{
                
            }];
        }
            break;
        case 4:{
            MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
            mc.mailComposeDelegate = self;
            [mc setSubject:@"意见反馈"];
            [mc setCcRecipients:[NSArray arrayWithObject:@"bryanthao@sina.com"]];
            [mc setBccRecipients:[NSArray arrayWithObject:@"brynthao@sina.com"]];
            [mc setMessageBody:@"请在此写出您的建议" isHTML:NO];
            NSString *path = [[NSBundle mainBundle] pathForResource:@"blood_orange"
                                                             ofType:@"png"];
            NSData *data = [NSData dataWithContentsOfFile:path];
            [mc addAttachmentData:data mimeType:@"image/png" fileName:@"blood_orange"];
            
            
            //    [self dismissViewControllerAnimated:YES completion:^{
            //        [(UINavigationController *)self.presentingViewController popToRootViewControllerAnimated:YES];
            //
            //    }];
            [self presentViewController:mc animated:YES completion:nil];
            //    while(theViewController = [theObjectEnumerator nextObject ])
            //    {
            //        if([theViewController modalTransitionStyle] == UIModalTransitionStyleCoverVertical)
            //        {
            //            [self.mNavigationController popToRootViewControllerAnimated:
            //             YES];
            //        }
            //    }
            //}else
            //while(theViewController = [theObjectEnumerator nextObject ])
            //{
            //    if([theViewController modalTransitionStyle] == UIModalTransitionStyleCoverVertical)
            //    {
            //        [self.mNavigationController dismissModalViewControllerAnimated:YES];
            //    }
            //}
        }
            break;
        default:
            break;
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent...");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
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
