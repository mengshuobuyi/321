//
//  CertifiArrayModel.h
//  wenYao-store
//
//  Created by Meng on 15/7/31.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseAPIModel.h"

@interface CertifiArrayModel : BaseAPIModel

@property (nonatomic ,strong) NSArray *certifis;

@end


@interface CertificateModel : BaseModel

@property (nonatomic ,strong) NSString *id;
@property (nonatomic ,strong) NSString *index;
@property (nonatomic ,strong) NSArray *items;
@property (nonatomic ,strong) NSString *name;
@property (nonatomic ,strong) NSString *status;
@property (nonatomic ,strong) NSString *type;

@end


@interface CertificateItemModel : BaseModel

@property (nonatomic ,strong) NSString *flag;
@property (nonatomic ,strong) NSString *name;
@property (nonatomic ,strong, getter=theNewValue) NSString *newValue;
@property (nonatomic ,strong) NSString *oldValue;
@property (nonatomic ,strong) NSString *status;

@end