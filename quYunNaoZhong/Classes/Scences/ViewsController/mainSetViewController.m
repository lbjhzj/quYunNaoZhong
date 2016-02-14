//
//  mainSetViewController.m
//  quYunNaoZhong
//
//  Created by 趣云科技 on 16/1/15.
//  Copyright © 2016年 趣云科技. All rights reserved.
//

#import "mainSetViewController.h"

@interface mainSetViewController ()<UITableViewDataSource,UITableViewDelegate,passingSelectedModeDelegate,MFMailComposeViewControllerDelegate,SKProductsRequestDelegate>
{
    GADMasterViewController *shared;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)UILabel * fitPeopleLabel;

@property(nonatomic,strong)NSString * productID;

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
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    _fitPeopleLabel.text = [userDefault objectForKey:@"ClockFitPeople"];
    [[SKPaymentQueue defaultQueue]addTransactionObserver:self];
    self.productID = @"com.quYunNaoZhong.deleteAd";


}




- (void)viewWillAppear:(BOOL)animated{
    shared = [GADMasterViewController singleton];
    [shared resetAdView:self];
    [super viewWillAppear:animated];

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
            cell.textLabel.text = NSLocalizedString(@"推荐闹钟设置", nil);
            [cell.contentView addSubview:self.fitPeopleLabel];
            break;
        case 1:
            cell.textLabel.text = nil;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
            
        case 2:
            cell.textLabel.text = NSLocalizedString(@"购买应用", nil);
            break;
        case 3:
            cell.textLabel.text = NSLocalizedString(@"告诉朋友", nil);
            break;
        case 4:
            cell.textLabel.text = NSLocalizedString(@"意见反馈", nil);
            break;
        case 5:
            cell.textLabel.text = NSLocalizedString(@"关于我们", nil);
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

#pragma mark 请求商品
- (void)requestProductData:(NSString *)type{
    NSLog(@"-------------请求对应的产品信息----------------");
    NSArray *product = [[NSArray alloc] initWithObjects:type, nil];
    
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
}

#pragma mark 收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSLog(@"--------------收到产品反馈消息---------------------");
    NSArray *product = response.products;
    if([product count] == 0){
        NSLog(@"--------------没有商品------------------");
        return;
    }
    
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    NSLog(@"产品付费数量:%lu",[product count]);
    
    SKProduct *p = nil;
    for (SKProduct *pro in product) {
        NSLog(@"%@", [pro description]);
        NSLog(@"%@", [pro localizedTitle]);
        NSLog(@"%@", [pro localizedDescription]);
        NSLog(@"%@", [pro price]);
        NSLog(@"%@", [pro productIdentifier]);
        
        if([pro.productIdentifier isEqualToString:self.productID]){
            p = pro;
        }
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    
    NSLog(@"发送购买请求");
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"------------------错误-----------------:%@", error);
}

- (void)requestDidFinish:(SKRequest *)request{
    NSLog(@"------------反馈信息结束-----------------");
}
//恢复购买
- (void)restorTransaction{

   
        SKPaymentQueue *paymentQueue=[SKPaymentQueue defaultQueue];
//        设置支付观察者（类似于代理），通过观察者来监控购买情况
         [paymentQueue addTransactionObserver:self];
//         恢复所有非消耗品
        [paymentQueue restoreCompletedTransactions];
    
}



//监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction{
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@"buy",@"textOne", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"buyAction" object:nil userInfo:dict];
  
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];

    for(SKPaymentTransaction *tran in transaction){
        
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"交易完成");
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                [storage setBool:YES forKey:@"enable_rocket_car"];
                [self completeTransaction:tran];
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"商品添加进列表");
//                [[NSNotificationCenter defaultCenter] postNotification:notification];

                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"已经购买过商品");
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                [storage setBool:YES forKey:@"enable_rocket_car"];
                [self completeTransaction:tran];
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"交易失败");
                [[SKPaymentQueue defaultQueue] finishTransaction: tran];
                break;
            default:
                break;
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    NSLog(@"出错了%@",error);
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{
    NSLog(@"完成恢复操作");
}
//交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    NSLog(@"交易结束");
    
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    NSURL *url =[[NSBundle mainBundle]appStoreReceiptURL];
    NSData *newReceipt = [NSData dataWithContentsOfURL:url];
    NSArray *savedReceipts = [storage arrayForKey:@"receipts"];
    if (!savedReceipts) {
        // Storing the first receipt
        [storage setObject:@[newReceipt] forKey:@"receipts"];
    } else {
        // Adding another receipt
        NSArray *updatedReceipts = [savedReceipts arrayByAddingObject:newReceipt];
        [storage setObject:updatedReceipts forKey:@"receipts"];
    }
    
    NSLog(@"transcation====%@",transaction);
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}


- (void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:{
           
            FitPeopleViewController *fit = [FitPeopleViewController new];
            fit.delegate = self;
             [self.navigationController pushViewController:fit animated:YES];
        }
            break;
            
        case 2:{
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"购买应用", nil) message:NSLocalizedString(@"购买后，可以去除广告", nil) preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *buyAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确认购买", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if ([SKPaymentQueue canMakePayments]) {
                    [self requestProductData:self.productID];
                }else{
                    NSLog(@"不允许内购");
                }
            }];
            UIAlertAction *restoreAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"恢复购买", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if ([SKPaymentQueue canMakePayments]) {
                    [self restorTransaction];
                }else{
                    NSLog(@"不允许内购");
                }
            }];
            [alertVC addAction:buyAction];
            [alertVC addAction:restoreAction];
            [self presentViewController:alertVC animated:YES completion:nil];
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
            [mc setCcRecipients:[NSArray arrayWithObject:@"quyunkj@163.com"]];
            [mc setBccRecipients:[NSArray arrayWithObject:@"quyunkj@163.com"]];
            [mc setMessageBody:@"请在此写出您的建议" isHTML:NO];
            NSString *path = [[NSBundle mainBundle] pathForResource:@"blood_orange"
                                                             ofType:@"png"];
            NSData *data = [NSData dataWithContentsOfFile:path];
            [mc addAttachmentData:data mimeType:@"image/png" fileName:@"blood_orange"];
            
            
      
            [self presentViewController:mc animated:YES completion:nil];

        }
            break;
        case 5:{
            AboutUsViewController *aboutUsVC = [[AboutUsViewController alloc] init];
            [self.navigationController pushViewController:aboutUsVC animated:YES];
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
