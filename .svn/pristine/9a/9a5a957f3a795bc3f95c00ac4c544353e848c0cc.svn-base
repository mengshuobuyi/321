//
//  CustomerModelR.h
//  APP
//
//  Created by chenzhipeng on 3/25/15.
//  Copyright (c) 2015 carret. All rights reserved.
//

#import "BaseModel.h"

@interface CustomerModelR : BaseModel
@property (nonatomic, strong) NSString *token;
@end

@interface CustomerQueryIndexModelR : CustomerModelR
@property (nonatomic, strong) NSString *tags;
@property (nonatomic, strong) NSString *item;
@end

@interface CustomerDeleteModelR : CustomerModelR
@property (nonatomic, strong) NSString *customer;
@end

@interface CustomerDetailInfoModelR : CustomerModelR
@property (nonatomic, strong) NSString *customer;
@end

@interface CustomerDrugModelR : CustomerModelR
@property (nonatomic, strong) NSString *customer;
@property (nonatomic, strong) NSString *currPage;
@property (nonatomic, strong) NSString *pageSize;
@end

@interface CustomerAppriseModelR : CustomerModelR
@property (nonatomic, strong) NSString *groupId;
@property (nonatomic, strong) NSString *customer;
@property (nonatomic, strong) NSString *currPage;
@property (nonatomic, strong) NSString *pageSize;
@end

@interface CustomerTagsModelR : CustomerModelR

@end

@interface CustomerUpdateTagsModelR : CustomerModelR
@property (nonatomic, strong) NSString *customer;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *tags;
@end

@interface CustomerRemoveTagsModelR : CustomerModelR
@property (nonatomic, strong) NSString *tag;
@end

@interface CustomerAddTagModelR : CustomerModelR
@property (nonatomic, strong) NSString *tag;
@end

@interface CustomerOrderListModelR : CustomerModelR
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *page;
@property (nonatomic, strong) NSString *pageSize;
@end


