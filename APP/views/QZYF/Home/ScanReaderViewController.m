//
//  ScanReaderViewController.m
//  quanzhi
//
//  Created by xiezhenghong on 14-6-4.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "ScanReaderViewController.h"
#import "ScanDrugViewController.h"
#import "InfomationOrderViewController.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "Promotion.h"
#import "OrderModel.h"

@interface ScanReaderViewController ()
{
    NSMutableArray *checkArr;
    NSString *checkStr;
    BOOL torchIsOn;
}
@end

@implementation ScanReaderViewController
@synthesize scanRectView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"条码";
    checkArr = [NSMutableArray array];
    checkStr = @"";
//    [self._scanRectView.scanner setSymbology:ZBAR_QRCODE config:ZBAR_CFG_ENABLE to:0];
    self.capture = [[ZXCapture alloc] init];
    self.capture.camera = self.capture.back;
    self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    self.capture.rotation = 90.0f;
    [self configureReadView];
    [self setupTorchBarButton];
    [self setupDynamicScanFrame];
    
}

- (void)popVCAction:(id)sender{
    
    if (self.capture.running ) {
        [self.capture stop];
    }
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)configureReadView
{
  
//     self.capture.torch = YES;
    self.capture.layer.frame = self.view.bounds;
    self.capture.delegate = self;
    self.capture.layer.frame = self.view.bounds;
    
    CGAffineTransform captureSizeTransform = CGAffineTransformMakeScale(320 / self.view.frame.size.width, 480 / self.view.frame.size.height);
 
    self.capture.scanRect = CGRectApplyAffineTransform(self.scanRectView.frame, captureSizeTransform);
    [self.view.layer addSublayer:self.capture.layer];
     NSLog(@"%@",NSStringFromCGSize(self.capture.scanRect.size));
//    [self.view bringSubviewToFront:self.scanRectView];
    //_scanRectView.scanCrop = [self getScanCrop:scanMaskRect _scanRectViewBounds:self._scanRectView.bounds];
    UILabel *desrciption = [[UILabel alloc] initWithFrame:CGRectMake(60, 380, 200, 35)];
    desrciption.textColor = [UIColor whiteColor];
    desrciption.font = [UIFont systemFontOfSize:13];
    desrciption.text = @"将条码放到取景框内,即可自动扫描";
    [self.view addSubview:desrciption];
}

- (void)setupDynamicScanFrame
{
    CGRect scanMaskRect = CGRectMake(60, CGRectGetMidY(scanRectView.frame) - 126, 200, 200);
    UIImageView *scanImage = [[UIImageView alloc] initWithFrame:scanMaskRect];
    [scanImage setImage:[UIImage imageNamed:@"扫描框.png"]];
    [self.view addSubview:scanImage];
    
    UIImageView *scanLineImage = [[UIImageView alloc] initWithFrame:CGRectMake(60, CGRectGetMidY(scanRectView.frame) - 126, 200, 6)];
    [scanLineImage setImage:[UIImage imageNamed:@"扫描线.png"]];
    [self.view addSubview:scanLineImage];
    [self runSpinAnimationOnView:scanLineImage duration:3 positionY:200 repeat:CGFLOAT_MAX];
}

- (CGRect)getScanCrop:(CGRect)rect _scanRectViewBounds:(CGRect)_scanRectViewBounds
{
    CGFloat x,y,width,height;
    
    x = rect.origin.x / _scanRectViewBounds.size.width;
    y = rect.origin.y / _scanRectViewBounds.size.height;
    width = rect.size.width / _scanRectViewBounds.size.width;
    height = rect.size.height / _scanRectViewBounds.size.height;
    
    return CGRectMake(x, y, width, height);
}

- (void)setupTorchBarButton
{
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"闪光灯.png"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleTorch:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}
- (void)captureSize:(ZXCapture *)capture
              width:(NSNumber *)width
             height:(NSNumber *)height
{
    
}

- (void)captureCameraIsReady:(ZXCapture *)capture
{
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    torchIsOn = NO;
}


- (IBAction)toggleTorch:(id)sender
{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            if (!torchIsOn) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                torchIsOn = YES;
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
                torchIsOn = NO;
            }
            [device unlockForConfiguration];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}
- (NSString *)barcodeFormatToString:(ZXBarcodeFormat)format {
    switch (format) {
        case kBarcodeFormatAztec:
            return @"Aztec";
            
        case kBarcodeFormatCodabar:
            return @"CODABAR";
            
        case kBarcodeFormatCode39:
            return @"Code 39";
            
        case kBarcodeFormatCode93:
            return @"Code 93";
            
        case kBarcodeFormatCode128:
            return @"Code 128";
            
        case kBarcodeFormatDataMatrix:
            return @"Data Matrix";
            
        case kBarcodeFormatEan8:
            return @"EAN-8";
            
        case kBarcodeFormatEan13:
            return @"EAN-13";
            
        case kBarcodeFormatITF:
            return @"ITF";
            
        case kBarcodeFormatPDF417:
            return @"PDF417";
            
        case kBarcodeFormatQRCode:
            return @"QR Code";
            
        case kBarcodeFormatRSS14:
            return @"RSS 14";
            
        case kBarcodeFormatRSSExpanded:
            return @"RSS Expanded";
            
        case kBarcodeFormatUPCA:
            return @"UPCA";
            
        case kBarcodeFormatUPCE:
            return @"UPCE";
            
        case kBarcodeFormatUPCEANExtension:
            return @"UPC/EAN extension";
            
        default:
            return @"Unknown";
    }
}


- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
    if (!result) return;

    
    if(result.text.length <= 15){
        
        [self normalScan:result.text];
        return;
    }
 
      if ([checkArr count]>8)
    {
        
    }else
    {
        [checkArr addObject:result.text];
    }
    
    if ([checkArr count]==3) {
        for (int i = 0; i < checkArr.count; i ++) {
            NSString *string = checkArr[ i];
            NSMutableArray *tempArray = [@[] mutableCopy];
            [tempArray addObject:string];
            for (int j = i+1; j < checkArr.count; j ++) {
                NSString *jstring = checkArr[j];
                NSLog(@"jstring:%@",jstring);
                if([string isEqualToString:jstring]){
                    NSLog(@"jvalue = kvalue");
                    checkStr = jstring;
//                    [checkArr removeObjectAtIndex:j];
                }
            }
        }
        if ([checkStr isEqualToString:@""]) {
            [checkArr removeAllObjects];
        }
        if(checkStr)
        {
            if(self.useType == 3) {
                NSArray *reverseCodingArray = [checkStr componentsSeparatedByString:@"#"];
                if(reverseCodingArray.count < 6)
                {
                    return;
                }
                PromotionScanR *modelR = [PromotionScanR new];
                modelR.promotionId = reverseCodingArray[1];
                modelR.proId = reverseCodingArray[3];
                modelR.token = QWGLOBALMANAGER.configure.userToken;
                modelR.passportId = reverseCodingArray[2];
                modelR.quantity = reverseCodingArray[4];
                modelR.price = reverseCodingArray[5];
                
                [Promotion promotionScanWithParams:modelR success:^(id UFModel) {
                    
                    PromotionScanModel *resonModel = (PromotionScanModel *)UFModel;
                
                    if([resonModel.status intValue] == 0){
                        OrderclassBranch *branch = [OrderclassBranch new];
                        branch.id       = resonModel.id;
                        branch.banner   = resonModel.url;
                        branch.title    = resonModel.title;
                        branch.type     = resonModel.type;
                        branch.desc     = resonModel.desc;
                        branch.proName  = resonModel.proName;
                        branch.nick     = resonModel.nick;
                        branch.discount = resonModel.discount;
                        branch.price    = modelR.price;
                        branch.useTimes = resonModel.useTimes;
                        branch.quantity = modelR.quantity;
                        branch.date     = resonModel.orderCreateTime;
                        
                        if(reverseCodingArray.count >= 6)
                        {
                            branch.inviter = reverseCodingArray[6];
                        }else{
                            branch.inviter = @"";
                        }
                        
                        InfomationOrderViewController *informationOrderViewController = [[InfomationOrderViewController alloc] initWithNibName:@"InfomationOrderViewController" bundle:nil];
                        informationOrderViewController.modeType = 2;
                        informationOrderViewController.orderBranchclass = branch;
                        [self.navigationController pushViewController:informationOrderViewController animated:YES];
                        
                    }else{
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:resonModel.msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        [alert show];
                        return ;
                    }
                    
                    
                } failure:^(HttpException *e) {
                    
                    if(e.Edescription && ![e.Edescription isEqualToString:@""]){
                        [SVProgressHUD showErrorWithStatus:e.Edescription duration:0.8];
                    }
                }];
            }
        }
    }
}
- (void) viewDidAppear: (BOOL) animated
{
    [super viewDidAppear:animated];
  
//    [_scanRectView start];
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

- (void)normalScan:(NSString *)proId
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"barCode"] = proId;
    
    //扫码获取商品信息
    [Promotion queryProductByBarCodeWithParam:param Success:^(id resultObj){
    
        ProductModel *model = (ProductModel *)resultObj;
        NSLog(@"%@",model);
        ScanDrugViewController *scan = [[ScanDrugViewController alloc]initWithNibName:@"ScanDrugViewController" bundle:nil];
        scan.product = model;
        [self.navigationController pushViewController:scan animated:YES];
        return ;
        
    }failure:^(HttpException *e){
        [SVProgressHUD showErrorWithStatus:e.Edescription duration:DURATION_SHORT];
    }];
}

@end
