//
//  ConsultPTPR.h
//  APP
//
//  Created by carret on 15/6/5.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseModel.h"

@interface ConsultPTPR : BaseModel

@end

@interface GetByPharModelR : BaseModel
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *branchId;
@property (nonatomic, strong) NSString *point;
@property (nonatomic, strong) NSString *view;
@property (nonatomic, strong) NSString *viewType;
@end

@interface GetByCustomerModelR : BaseModel
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *customerPassport;
@property (nonatomic, strong) NSString *point;
@property (nonatomic, strong) NSString *view;
@property (nonatomic, strong) NSString *viewType;
@end

@interface PollBySessionidModelR : BaseModel
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *sessionId;

@end

@interface GetAllSessionModelR : ConsultPTPR
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *point;
@property (nonatomic, strong) NSString *view;
@property (nonatomic, strong) NSString *viewType;
@end

@interface GetNewSessionModelR : ConsultPTPR
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *lastTimestamp;
@end

@interface PTPCreate : BaseModel
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *sessionId;
@property (nonatomic, strong) NSString *contentType;
@property (nonatomic, strong) NSString *contentJson;
@property (nonatomic, strong) NSString *UUID;
@end
@interface PTPRead : BaseModel
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *sessionId;
@property (nonatomic, strong) NSString *detailIds;
@property (nonatomic, strong) NSString *containSystem;
@end
@interface PTPRemove : BaseModel
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *sessionId;
@property (nonatomic, strong) NSString *detailId;
@end



////////






@interface PTP24Check : BaseModel
@property (nonatomic, strong) NSString *sessionId;
@end



@interface PTPRemoveByPharModelR : BaseModel
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *sessionId;

@end

@interface PTPTopByPharModelR : BaseModel

@property (nonatomic, strong) NSString *sessionId;
@property (nonatomic, strong) NSString *option; //操作选项：1 置顶，2 取消置顶

@end

@interface GetAllByPharModelR : BaseModel
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *point;
@property (nonatomic, strong) NSString *view;
@property (nonatomic, strong) NSString *viewType;
@end