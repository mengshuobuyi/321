//
//  CustomIdPhotoViewController.m
//  wenYao-store
//
//  Created by YYX on 15/10/8.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "CustomIdPhotoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>

@interface CustomIdPhotoViewController () <AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;

@property (strong, nonatomic) AVCaptureDevice *device;

@property (strong, nonatomic) AVCaptureDeviceInput *input;

@property (strong, nonatomic) AVCaptureSession *session;

@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview;

@property (assign, nonatomic) BOOL isLightOff; // 是否开启闪光灯

@property (weak, nonatomic) IBOutlet UIButton *lightButton;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet UIButton *photoButton;

@property (weak, nonatomic) IBOutlet UIView *leftView;

@property (weak, nonatomic) IBOutlet UIView *rightView;

@property (strong, nonatomic) UILabel *labelOne;

@property (strong, nonatomic) UILabel *labelTwo;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blackBottomHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoButtonBottomConstraint;



- (IBAction)lightAction:(id)sender;

- (IBAction)cancelAction:(id)sender;

- (IBAction)photoAction:(id)sender;

@end

@implementation CustomIdPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self configureUI];
    
    self.isLightOff = NO;
    if ([self isCameraAvailable]) {
        __weak CustomIdPhotoViewController *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf configCamera];
        });
    }
    
    if (IS_IPHONE_4_OR_LESS) {
        self.blackBottomHeightConstraint.constant = 78;
        self.topHeightConstraint.constant = 20;
        self.bottomHeightConstraint.constant = 20;
        self.photoButtonBottomConstraint.constant = 6;
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if ([UIApplication sharedApplication].statusBarHidden == NO) {
        //iOS7，需要plist里设置 View controller-based status bar appearance 为NO
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if ([UIApplication sharedApplication].statusBarHidden == YES) {
        //iOS7，需要plist里设置 View controller-based status bar appearance 为NO
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
}

- (void)configureUI
{
    CGFloat centerY;
    if (IS_IPHONE_4_OR_LESS) {
        centerY = 230;
    }else if (IS_IPHONE_5){
        centerY = 260;
    }else if (IS_IPHONE_6){
        centerY = 300;
    }else if (IS_IPHONE_6P){
        centerY = 340;
    }
    
    self.labelOne = [[UILabel alloc] init];
    self.labelOne.center = CGPointMake(APP_W-24, centerY);
    self.labelOne.bounds = CGRectMake(0, 0, 308, 25);
    self.labelOne.text = @"请身份证正面置于此区域内，并对齐扫描框边缘。";
    self.labelOne.font = font(kFont2, kFontS4);
    self.labelOne.textColor = [UIColor whiteColor];
    [self.view addSubview:self.labelOne];
    self.labelOne.transform=CGAffineTransformMakeRotation(M_PI/2);
    
    self.labelTwo = [[UILabel alloc] init];
    self.labelTwo.center = CGPointMake(24, centerY);
    self.labelTwo.bounds = CGRectMake(0, 0, 308, 25);
    self.labelTwo.text = @"请保持手机镜头和证件平行，拍摄时避免反光。";
    self.labelTwo.font = font(kFont2, kFontS4);
    self.labelTwo.textColor = [UIColor whiteColor];
    [self.view addSubview:self.labelTwo];
    self.labelTwo.transform=CGAffineTransformMakeRotation(M_PI/2);
}

/**
 *  关闭闪光灯
 */
-(void)turnOffLed {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        [device setTorchMode: AVCaptureTorchModeOff];
        [device unlockForConfiguration];
    }
}

/**
 *  开启闪光灯
 */
-(void)turnOnLed {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        [device setTorchMode: AVCaptureTorchModeOn];
        [device unlockForConfiguration];
    }
}

- (void)setCameraPosition
{
    
    //Indicate that some changes will be made to the session
    [self.session beginConfiguration];
    
    //Remove existing input
    AVCaptureInput* currentCameraInput = [self.session.inputs objectAtIndex:0];
    [self.session removeInput:currentCameraInput];
    
    //Get new input
    AVCaptureDevice *newCamera = nil;
    if(((AVCaptureDeviceInput*)currentCameraInput).device.position == AVCaptureDevicePositionBack) {
        newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
    }
    else {
        newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
    }
    
    if(!newCamera) {
        return;
    }
    
    AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:newCamera error:nil];
    [self.session addInput:newVideoInput];
    
    
    [self.session commitConfiguration];
    
    self.device = newCamera;
}

- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) return device;
    }
    return nil;
}


// 判断设备是否有摄像头
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

/**
 *  添加输出设备
 */
- (void)addStillImageOutput {
    AVCaptureStillImageOutput *tmpOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];//输出jpeg
    tmpOutput.outputSettings = outputSettings;
    [_session addOutput:tmpOutput];
    self.stillImageOutput = tmpOutput;
}

/**
 *  添加输入设备
 */
-(void)addInputDevice
{
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    [self.session addInput:self.input];
}

-(void)addPreviewLayer
{
    self.preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame =CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
    [self.view.layer insertSublayer:self.preview atIndex:0];
}

- (void)configCamera
{
    
    self.session = [[AVCaptureSession alloc] init];
    // 添加输入设备
    [self addInputDevice];
    // 添加输出
    [self addStillImageOutput];
    // 添加拍照的预览图
    [self addPreviewLayer];
    [self.session startRunning];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (AVCaptureConnection*)findVideoConnection {
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in _stillImageOutput.connections) {
        for (AVCaptureInputPort *port in connection.inputPorts) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    return videoConnection;
}


-(void)dealloc
{
    self.session = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark ---- 闪光灯 ----

- (IBAction)lightAction:(id)sender
{
    if (self.isLightOff) {
        [self turnOffLed];
        self.isLightOff = NO;
    }else{
        [self turnOnLed];
        self.isLightOff = YES;
    }
}

#pragma mark ---- 取消 ----

- (IBAction)cancelAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark ---- 拍照 ----

- (IBAction)photoAction:(id)sender
{
    AVCaptureConnection *videoConnection = [self findVideoConnection];
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        
        [self.session stopRunning];
        CustomIdPhotoViewController __weak *weakSelf = self;
        [self dismissViewControllerAnimated:YES completion:^{
            // 调用代理
            [weakSelf.CustomIdPhotoViewControllerDelegate idCardPhotoResult:image];
        }];
    }];
}
@end
