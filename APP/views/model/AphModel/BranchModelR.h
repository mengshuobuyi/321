//
//  BranchModelR.h
//  wenYao-store
//
//  Created by Meng on 15/4/20.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseModel.h"

@interface BranchModelR : BaseModel

@end

@interface BranchCertifiSaveModelR : BranchModelR

@property (nonatomic ,strong) NSString *id;
@property (nonatomic ,strong) NSString *groupId;
@property (nonatomic ,strong) NSNumber *typeId;
@property (nonatomic ,strong) NSString *imageName;
@property (nonatomic ,strong) NSString *certifiName;
@property (nonatomic ,strong) NSString *certifiNo;
@property (nonatomic ,strong) NSString *validEndDate;

@end

@interface BranchGetSymbolModelR : BaseModel

@property (nonatomic, strong) NSString *token;
@end