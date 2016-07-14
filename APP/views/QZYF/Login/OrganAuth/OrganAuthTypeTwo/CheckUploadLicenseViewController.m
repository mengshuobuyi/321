//
//  CheckUploadLicenseViewController.m
//  wenYao-store
//
//  Created by YYX on 15/8/25.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "CheckUploadLicenseViewController.h"
#import "SDWebImageManager.h"

@interface CheckUploadLicenseViewController ()

@property (strong, nonatomic)  UIImageView *imageView;

@end

@implementation CheckUploadLicenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"查看照片";
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(deleteIamgeAction)];
    
    self.imageView = [[UIImageView alloc] init];
    [self.view addSubview:self.imageView];
    self.imageView.center = CGPointMake(APP_W/2, (SCREEN_H-64)/2);
    
    
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:self.imageUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        
        // 要显示的ao度
        CGFloat saleImgheight  = image.size.height > SCREEN_H-64 ? SCREEN_H-64 : image.size.height;
        
        // 要显示的高度
        CGFloat saleImgwidth = image.size.width*saleImgheight/image.size.height;
        
        self.imageView.bounds = CGRectMake(0, 0, saleImgwidth, saleImgheight);
        self.imageView.image = image;
        
    }];
    
}

#pragma mark ---- 删除图片 ----

- (void)deleteIamgeAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteImageActionWithIndexPath:)]) {
        [self.delegate deleteImageActionWithIndexPath:self.indexPath];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
