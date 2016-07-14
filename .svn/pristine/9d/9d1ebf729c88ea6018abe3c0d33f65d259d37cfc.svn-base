//
//  InputOrderPostNumberViewController.m
//  wenYao-store
//  填写运单号
//  填写物流：FillPostDetail
//  Created by qw_imac on 16/3/10.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "InputOrderPostNumberViewController.h"
#import "AllScanReaderViewController.h"
#import "QueryShopOrdersR.h"
#import "IndentOders.h"
#import "QYPhotoAlbum.h"
@interface InputOrderPostNumberViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputText;
//@property (nonatomic,strong) NSString *billNo;
@property (nonatomic,assign) BOOL success;
@end

@implementation InputOrderPostNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"填写运单号";
    _success = NO;
    self.companyLabel.text = _company.name;
    self.inputText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入或扫描运单号" attributes:@{NSForegroundColorAttributeName:RGBHex(qwColor9),NSFontAttributeName:fontSystem(kFontS4)}];
    self.inputText.delegate = self;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn.titleLabel setFont:fontSystem(kFontS1)];
    [btn addTarget:self action:@selector(commitOperation) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *naviBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = naviBtn;
}

- (IBAction)scanAction:(UIButton *)sender {
    if (![QYPhotoAlbum checkCameraAuthorizationStatus]) {
       [QWGLOBALMANAGER getCramePrivate];
        return;
    }
    AllScanReaderViewController *vc = [[AllScanReaderViewController alloc]init];
        vc.scanType = Enum_Scan_Items_QuickOrder;
        __weak typeof(self) weakSelf = self;
        vc.scan = ^(NSString *code) {
            weakSelf.inputText.text = code;
        };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)commitOperation {
    if (StrIsEmpty(_inputText.text)) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入或扫描订单号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    FillLogisticsR *modelR = [FillLogisticsR new];
    modelR.orderId = _orderId;
    modelR.company = _company.name;
    modelR.companyCode = _company.code;
    modelR.billNo = _inputText.text;
    [IndentOders fillLogistics:modelR success:^(FillLogisticsModel *model) {
        if ([model.apiStatus intValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"订单已在配送中，接下来确认收货" duration:0.8];
            _success = YES;
            [self popVCAction:nil];
        }else {

        }
    } failure:^(HttpException *e) {
        
    }];

}

-(void)popVCAction:(id)sender {
    [super popVCAction:sender];
    if (self.refresh) {
        self.refresh(_success);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    DebugLog(@"%@",string);
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    return YES;
}

@end
