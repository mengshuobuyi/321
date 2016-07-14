//
//  BusinessLicenseViewController.h
//  wenyao-store
//
//  Created by Meng on 14-10-24.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//


#import "QWBaseVC.h"
#import "CertifiArrayModel.h"
typedef NS_ENUM(NSInteger, LicenseType) {
    LicenseTypeBusiness = 0,//营业执照
    LicenseTypeDrug,        //药品经营许可证
    LicenseTypeGSP,         //GSP证书
    LicenseTypeOrganization,//组织机构
};

typedef NS_ENUM(NSInteger, GroupType) {
    GroupTypeOrganization = 0, //组织机构
    GroupTypeStore, //药店
};

@interface BusinessLicenseViewController : QWBaseVC



@property (nonatomic ,strong) CertificateModel *certificateModel;

//执照类型
@property (nonatomic ,assign) LicenseType licenseType;


@end
