//
//  BaseScanReaderViewController.m
//  wenYao-store
//
//  Created by caojing on 15/10/8.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseScanReaderViewController.h"

@interface BaseScanReaderViewController ()
@end

@implementation BaseScanReaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.SCAN_W=APP_W/2+100;
    //默认关闭闪光灯
    self.torchMode = NO;
    CGRect rect = CGRectMake(0, 0, APP_W, APP_H);
    self.iosScanView = [[IOSScanView alloc] initWithFrame:rect];
    self.iosScanView.delegate = self;
    [self.view addSubview:self.iosScanView];
    
    [self setupTorchBarButton];
    [self setupDynamicScanFrame];
    [self configureReadView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark  初始化界面布局

- (void)configureReadView
{
    UILabel *desrciption = [[UILabel alloc] initWithFrame:CGRectMake(0,0, APP_W, 30)];
    CGPoint point = CGPointMake(APP_W/2, (APP_H+ self.SCAN_W)/2);
    desrciption.center = point;
    desrciption.textColor = RGBHex(qwColor4);
    desrciption.font = fontSystem(kFontS4);
    desrciption.textAlignment = NSTextAlignmentCenter;
    desrciption.text = @"将条形码/二维码放到取景框内,即可自动扫描";
    [self.view addSubview:desrciption];
}

- (void)setupDynamicScanFrame
{
    float backalpha = 0.4;
    CGRect viewRect1 = CGRectMake(0,0, (APP_W - self.SCAN_W )/ 2, APP_H);
    UIView* view1 = [[UIView alloc] initWithFrame:viewRect1];
    [view1 setBackgroundColor:[UIColor blackColor]];
    view1.alpha = backalpha;
    [self.view addSubview:view1];
    
    CGRect viewRect2 = CGRectMake((APP_W - self.SCAN_W )/ 2,0, self.SCAN_W, (APP_H-self.SCAN_W)/2-40);
    UIView* view2 = [[UIView alloc] initWithFrame:viewRect2];
    [view2 setBackgroundColor:[UIColor blackColor]];
    view2.alpha = backalpha;
    [self.view addSubview:view2];
    
    CGRect viewRect3 = CGRectMake((APP_W + self.SCAN_W )/2,0, (APP_W - self.SCAN_W )/ 2, APP_H);
    UIView* view3 = [[UIView alloc] initWithFrame:viewRect3];
    [view3 setBackgroundColor:[UIColor blackColor]];
    view3.alpha = backalpha;
    [self.view addSubview:view3];
    
    CGRect viewRect4 = CGRectMake((APP_W - self.SCAN_W )/ 2,(APP_H+self.SCAN_W)/2-40, self.SCAN_W, (APP_H-self.SCAN_W)/2);
    UIView* view4 = [[UIView alloc] initWithFrame:viewRect4];
    [view4 setBackgroundColor:[UIColor blackColor]];
    view4.alpha = backalpha;
    [self.view addSubview:view4];
    
    
    //x:(APP_W - self.SCAN_W )/ 2
    //y:(APP_H-self.SCAN_W)/2
    //w:220
    //h:220
    CGRect scanMaskRect = CGRectMake((APP_W - self.SCAN_W )/ 2,(APP_H-self.SCAN_W)/2-40, self.SCAN_W, self.SCAN_W);
    UIImageView *scanImage = [[UIImageView alloc] initWithFrame:scanMaskRect];
    [scanImage setImage:[UIImage imageNamed:@"扫描框"]];
    [self.view addSubview:scanImage];
    
    UIImageView *scanLineImage = [[UIImageView alloc] initWithFrame:CGRectMake((APP_W - self.SCAN_W )/ 2,(APP_H-self.SCAN_W)/2-40, self.SCAN_W, 6)];
    [scanLineImage setImage:[UIImage imageNamed:@"扫描线"]];
    scanLineImage.center = CGPointMake(APP_W/2, (APP_H-self.SCAN_W)/2-40);
    [self.view addSubview:scanLineImage];
    
    [self runSpinAnimationOnView:scanLineImage duration:3 positionY:self.SCAN_W repeat:CGFLOAT_MAX];
}

- (void)runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration positionY:(CGFloat)positionY repeat:(float)repeat;
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: positionY];
    rotationAnimation.duration = duration;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    rotationAnimation.autoreverses = YES;
    [view.layer addAnimation:rotationAnimation forKey:@"position"];
}

#pragma mark -
#pragma mark  右上角按钮 闪光灯
- (void)setupTorchBarButton
{
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"闪光灯"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleTorch:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)toggleTorch:(id)sender
{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            if (!self.torchMode) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                self.torchMode = YES;
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
                self.torchMode = NO;
            }
            [device unlockForConfiguration];
        }
    }
}

- (void) IOSScanResult: (NSString*) scanCode WithType:(NSString *)type
{
    //进行业务逻辑处理 优惠商品的扫码搜索页面
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (self.iosScanView) {
        [self.iosScanView startRunning];
    }
    ((QWBaseNavigationController *)self.navigationController).canDragBack = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    if (self.iosScanView) {
        [self.iosScanView stopRunning];
    }
    self.torchMode = NO;
    ((QWBaseNavigationController *)self.navigationController).canDragBack = YES;
}

@end
