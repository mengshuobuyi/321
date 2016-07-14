//
//  UploadLicenseModelR.h
//  wenYao-store
//
//  Created by YYX on 15/8/25.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseModel.h"

@interface UploadLicenseModelR : BaseModel

@property (strong, nonatomic) NSString      *personName;    // 法人/企业负责人姓名
@property (strong, nonatomic) NSString      *idNum;         // 身份证号
@property (strong, nonatomic) NSString      *registerNum;   // 营业执照注册号
@property (strong, nonatomic) NSString      *IDUrl;         // 身份证图片
@property (strong, nonatomic) NSString      *registerUrl;   // 营业执照图片

@end


@interface ShitModel : BaseModel

@property (strong, nonatomic) NSString      *medicineNum;   // 药品经营许可证
@property (strong, nonatomic) NSString      *date;          // 有效期
@property (strong, nonatomic) NSString      *medcineUrl;    // 药品经营许可证图片
@property (strong, nonatomic) NSString      *type;

@end
