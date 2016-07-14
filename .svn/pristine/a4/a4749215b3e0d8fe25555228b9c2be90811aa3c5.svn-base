//
//  ActivityModelR.h
//  wenYao-store
//
//  Created by caojing on 15/4/1.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseModel.h"

@interface ActivityModelR : BaseModel

@end


@interface QueryActivitysR : BaseModel
@property(nonatomic,strong)NSString *groupId;
@property(nonatomic,strong)NSString *currPage;
@property(nonatomic,strong)NSString *pageSize;

@end

@interface QueryActivityCoupnR : BaseModel
@property(nonatomic,strong)NSString *token;
@property(nonatomic,strong)NSString *currPage;
@property(nonatomic,strong)NSString *pageSize;

@end


//发布更新营销活动
@interface SaveActivityR : BaseModel
@property(nonatomic,strong)NSString *token;
@property(nonatomic,strong)NSString *activityId;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *imgUrl;
@end


@interface DeleteActivitysR : BaseModel
@property(nonatomic,strong)NSString *token;
@property(nonatomic,strong)NSString *activityId;
@end

@interface QueryActivityR : BaseModel
@property(nonatomic,strong)NSString *groupId;
@property(nonatomic,strong)NSString *activityId;
@end


//优惠活动
@interface GetBranchPromotionR : BaseModel
@property (nonatomic ,strong) NSString *branchId;
@property (nonatomic ,strong) NSNumber *currPage;
@property (nonatomic ,strong) NSNumber *pageSize;
@end

//-----------新的优惠活动--------------
//优惠活动
@interface GetNewBranchPromotionR : BaseModel
@property (nonatomic ,strong) NSString *branchId;
@property (nonatomic ,strong) NSNumber *status;
@property (nonatomic ,strong) NSNumber *currPage;
@property (nonatomic ,strong) NSNumber *pageSize;
@end

@interface BranchPromotionDetailR : BaseModel
@property (nonatomic ,strong) NSString *branchId;
@property (nonatomic ,strong) NSString *packPromotionId;
@end

@interface BranchPromotionProductR : BaseModel
@property (nonatomic ,strong) NSString *branchId;
@property (nonatomic ,strong) NSString *packPromotionId;
@property (nonatomic ,strong) NSString *currPage;
@property (nonatomic ,strong) NSString *pageSize;
@end

