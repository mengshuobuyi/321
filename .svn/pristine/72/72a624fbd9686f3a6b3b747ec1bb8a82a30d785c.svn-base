//
//  PharmacistModel.h
//  wenYao-store
//
//  Created by Meng on 15/4/20.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseAPIModel.h"
#import "BranchModel.h"
@interface PharmacistModel : BaseAPIModel

@end

@interface PharmacistListModel : PharmacistModel

@property (nonatomic ,strong) NSArray *list;

@end

@interface PharmacistStatusModel : BaseModel

@property (nonatomic ,strong) NSString *fieldStatus;
@property (nonatomic ,strong) NSString *fieldValue;
@property (nonatomic ,strong) NSString *validResult;

@end

@interface PharmacistInfoModel : BaseModel

@property (nonatomic ,strong) PharmacistStatusModel *cardNo;
@property (nonatomic ,strong) PharmacistStatusModel *certImgUrl;
@property (nonatomic ,strong) PharmacistStatusModel *name;
@property (nonatomic ,strong) PharmacistStatusModel *practiceEndTime;
@property (nonatomic ,strong) PharmacistStatusModel *practiceImgUrl;
@property (nonatomic ,strong) PharmacistStatusModel *sex;

@end


@interface PharmacistMemberModel : PharmacistModel

@property (nonatomic ,strong) NSString *approveStatus;//approveStatus 审核状态 (0:未审核,1:审核不通过,2:审核通过),
@property (nonatomic ,strong) NSString *name;
@property (nonatomic ,strong) PharmacistInfoModel *pharmacistInfo; //药师信息
@property (nonatomic ,strong) NSString *pid; //药师ID
@property (nonatomic ,strong) NSString *validResult; //执照是否过期（0-过期，1-有效）

@end

@interface PharmacistSaveModel : BaseModel

@property (nonatomic ,strong) NSString *name;
@property (nonatomic ,strong) NSString *sex;
@property (nonatomic ,strong) NSString *cardNo;
@property (nonatomic ,strong) NSString *certImgUrl;
@property (nonatomic ,strong) NSString *practiceImgUrl;
@property (nonatomic ,strong) NSString *practiceEndTime;

@end


@interface PharmacistCheckModel : BaseModel

@end