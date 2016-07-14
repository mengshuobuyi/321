//
//  ShowBranchCodeViewController.m
//  wenYao-store
//
//  Created by garfield on 15/10/30.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "ShowBranchCodeViewController.h"
#import "QRCodeGenerator.h"
#import "Branch.h"
#import "RefCode.h"

@interface ShowBranchCodeViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *qrImageView;
@property (weak, nonatomic) IBOutlet UILabel *branchCodeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containView_layout_top;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containView_layout_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *branchLabel_layout_left;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

- (IBAction)saveCodeAction:(id)sender;

@end

@implementation ShowBranchCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"本店二维码";
    [self configUI];
    [self queryQRCode];
    
    if (QWGLOBALMANAGER.configure.storeType == 3)
    {
        //开通微商
        self.saveButton.hidden = NO;
        self.saveButton.enabled = YES;
        self.tipsLabel.hidden = NO;
    }else
    {
        //未开通微商
        self.saveButton.hidden = YES;
        self.saveButton.enabled = NO;
        self.tipsLabel.hidden = YES;
    }
}

- (void)configUI
{
    _containerView.layer.masksToBounds = YES;
    _containerView.layer.cornerRadius = 4.0;
    
    self.saveButton.layer.masksToBounds = YES;
    self.saveButton.layer.cornerRadius = 4.0;
    
    if (IS_IPHONE_6) {
        self.branchLabel_layout_left.constant = 95;
    }else if (IS_IPHONE_6P){
        self.branchLabel_layout_left.constant = 115;
    }
    
    if (IS_IPHONE_4_OR_LESS) {
        self.containView_layout_top.constant = 40;
    }
    self.containView_layout_height.constant = (APP_W-38*2)*278/244;
}

#pragma mark ---- 请求数据 ----
- (void)queryQRCode
{
    BranchGetSymbolModelR *modelR = [BranchGetSymbolModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    
    [Branch GetSymbolWithParams:modelR success:^(BranchSymbolVo *obj) {
        
        self.branchCodeLabel.text = obj.symbol;
        [self.qrImageView setImageWithURL:[NSURL URLWithString:obj.qrCodeImgUrl]];
        
    } failure:NULL];
}

#pragma mark ---- 保存图片到系统相册 ----
- (IBAction)saveCodeAction:(id)sender
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showError:@"系统异常，请稍后再试"];
        return;
    }
    
    [QWGLOBALMANAGER statisticsEventId:@"我的二维码_保存二维码" withLable:@"圈子" withParams:nil];
    
    RefCodeModelR *modelR = [RefCodeModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.objType = @"3";
    modelR.objId = QWGLOBALMANAGER.configure.groupId;
    modelR.channel = @"1";
    [RefCode queryRefCode:modelR success:^(RefCodeModel *responseModel) {
        
        if ([responseModel.apiStatus integerValue] == 0) {
            
            if (responseModel.url) {
                UIImage *image = [QRCodeGenerator qrImageForString:responseModel.url imageSize:self.containView_layout_height.constant Topimg:nil];
                if (image) {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
                    [SVProgressHUD showSuccessWithStatus:@"已保存到系统相册！" duration:1.0];
                }
            }
        }else{
            [SVProgressHUD showErrorWithStatus:responseModel.apiMessage];
        }
    
    } failure:^(HttpException *e) {
        [self showError:@"系统异常，请稍后再试"];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
