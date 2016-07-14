//
//  CheckUploadLicenseViewController.h
//  wenYao-store
//
//  Created by YYX on 15/8/25.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseVC.h"

@protocol CheckUploadLicenseViewControllerDelegate  <NSObject>

- (void)deleteImageActionWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface CheckUploadLicenseViewController : QWBaseVC

@property (assign, nonatomic) id <CheckUploadLicenseViewControllerDelegate> delegate;

// 图片地址
@property (strong, nonatomic) NSString *imageUrl;

@property (strong, nonatomic) NSIndexPath *indexPath;

@end
