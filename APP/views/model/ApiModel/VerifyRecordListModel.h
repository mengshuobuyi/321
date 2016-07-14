//
//  VerifyRecordListModel.h
//  wenYao-store
//
//  Created by PerryChen on 6/21/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "BaseAPIModel.h"

@interface VerifyRecordListModel : BaseAPIModel
@property (nonatomic, strong) NSArray *orders;
@end

@interface VerifyRecordModel : BaseModel
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *mallProId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) NSString *level;
@property (nonatomic, strong) NSString *chargeNo;
@property (nonatomic, strong) NSString *postAddress;
@property (nonatomic, strong) NSString *drawRemark;
@property (nonatomic, strong) NSString *drawDate;
@property (nonatomic, strong) NSString *exchangeCode;
@property (nonatomic, strong) NSString *exchangeDate;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *exchangeType;
@property (nonatomic, strong) NSString *userName;
@end