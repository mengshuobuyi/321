//
//  BaseScanReaderViewController.h
//  wenYao-store
//
//  Created by caojing on 15/10/8.
//  Copyright (c) 2015年 carret. All rights reserved.
//
//扫码的基础界面
#import "QWBaseVC.h"
#import "IOSScanView.h"

@interface BaseScanReaderViewController : QWBaseVC<IOSScanViewDelegate>

@property (nonatomic, strong) IBOutlet  UIView  *readerView;

@property (nonatomic, assign) BOOL torchMode;          //控制闪光灯的开关

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) IOSScanView *iosScanView;

@property (nonatomic, assign) int SCAN_W;

@end
