//
//  InternalProductQRCodeViewController.m
//  wenYao-store
//
//  商品二维码页面
//
//
//  Created by PerryChen on 3/11/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "InternalProductQRCodeViewController.h"
#import "QRCodeGenerator.h"

@interface InternalProductQRCodeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImgView;
@property (weak, nonatomic) IBOutlet UIView *saveCodeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contraintImgHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintSaveViewHeight;
- (IBAction)saveCodeAction:(UIButton *)sender;

@end

@implementation InternalProductQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商品二维码";
    [self setupViewStyle];
    [self generateQRCodeImg];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  设置界面元素
 */
- (void)setupViewStyle
{
    self.view.backgroundColor = RGBHex(qwGcolor11);
    self.saveCodeView.backgroundColor = RGBHex(qwMcolor2);
    self.saveCodeView.layer.cornerRadius = 4.0f;
    self.constraintSaveViewHeight.constant = APP_W / 320 * 40.0f;
    self.contraintImgHeight.constant = APP_W / 320 * 173.0f;
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

/**
 *  生成二维码图片
 */
- (void)generateQRCodeImg
{
    UIImage *img = [QRCodeGenerator qrImageForString:self.qrCodeURL imageSize:self.constraintSaveViewHeight.constant*3 Topimg:nil];
    self.qrCodeImgView.image = img;
}

/**
 *  保存图片到本地相册
 *
 *  @param sender 
 */
- (IBAction)saveCodeAction:(UIButton *)sender {

    UIImageWriteToSavedPhotosAlbum(self.qrCodeImgView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    [QWLOADING showLoading];
}

/**
 *  保存图片的回调方法
 *
 *  @param image
 *  @param error
 *  @param info
 */
- (void) image:(UIImage*)image didFinishSavingWithError:(NSError *)error contextInfo:(NSDictionary*)info;
{
    [QWLOADING removeLoading];
    if (error == nil) {
        [self showSuccess:@"已保存到系统相册!"];
    } else {
        [self showError:@"保存失败"];
    }
}
@end
