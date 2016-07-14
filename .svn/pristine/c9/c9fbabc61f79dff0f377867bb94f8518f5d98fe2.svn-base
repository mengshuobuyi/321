//
//  MyCustomerBaseModel.h
//  wenYao-store
//
//  Created by chenzhipeng on 3/27/15.
//  Copyright (c) 2015 carret. All rights reserved.
//

#import "BaseModel.h"
#import "BaseAPIModel.h"

@interface MyCustomerBaseModel : BaseAPIModel

@end

@interface MyCustomerLabelsModel : BaseAPIModel
@property (nonatomic, strong) NSArray *list;
@end

@interface MyCustomerListModel : MyCustomerBaseModel
@property (nonatomic, strong) NSString *appAccountId;
@property (nonatomic, strong) NSString *createDate;
@property (nonatomic, strong) NSString *headImgUrl;
@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) NSString *indexText;
@property (nonatomic, strong) NSString *indexName;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *nick;
@property (nonatomic, strong) NSString *passportId;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *tags;
@end

@interface MyCustomerInfoModel : MyCustomerBaseModel
@property (nonatomic, strong) NSString *appAccountId;
@property (nonatomic, strong) NSString *chat;
@property (nonatomic, strong) NSString *createDate;
@property (nonatomic, strong) NSString *headImgUrl;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *index;
@property (nonatomic, strong) NSString *indexName;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *nick;
@property (nonatomic, strong) NSString *passportId;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSNumber *sex;
@property (nonatomic, strong) NSString *tags;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *sourceDescription;
@property (nonatomic, strong) NSString *lvl;
@property (nonatomic, strong) NSArray *ncdTags;
@property (nonatomic, strong) NSString *sessionId;
@end

@interface MyCustomerNcdLabelModel: MyCustomerBaseModel
@property (nonatomic, strong) NSString *ncdId;
@property (nonatomic, strong) NSString *ncdName;
@end

@interface MyCustomerDrugListModel : BaseAPIModel
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, strong) NSString *page;
@property (nonatomic, strong) NSString *pageSize;
@property (nonatomic, strong) NSString *pageSum;
@property (nonatomic, strong) NSString *totalRecords;
@end

@interface CustomerDrugListModel : BaseModel
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *num;
@end

@interface MyCustomerAppriseListModel : BaseAPIModel
@property(strong,nonatomic) NSString * page;
@property(strong,nonatomic) NSMutableArray  * list;
@property(strong,nonatomic) NSString * pageSum;
@property(strong,nonatomic) NSString * pageSize;
@property(strong,nonatomic) NSString * totalRecords;
@end

@interface CustomerAppriseModel : BaseModel
@property (nonatomic, strong) NSString *addDate;
@property (nonatomic, strong) NSString *appraiseId;
@property (nonatomic, strong) NSString *mark;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *passportId;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSNumber *sex;
@property (nonatomic, strong) NSNumber *star;

@property (nonatomic, strong) NSString *read;//1表示已读 0表示未读
@end

@interface CustomerOrdersVoModel : BaseAPIModel
@property (nonatomic, strong) NSString *orderAmount;
@property (nonatomic, strong) NSArray *memberOrderListVOs;
@end

@interface CustomerOrderVoModel : BaseAPIModel
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *orderCode;
@property (nonatomic, strong) NSString *createStr;
@property (nonatomic, strong) NSString *orderStatus;
@property (nonatomic, strong) NSString *finalAmount;
@end


