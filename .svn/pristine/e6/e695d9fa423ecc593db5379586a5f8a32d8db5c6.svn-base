//
//  ConsultModelR.h
//  APP
//
//  Created by chenzhipeng on 5/5/15.
//  Copyright (c) 2015 carret. All rights reserved.
//

#import "BaseModel.h"
#import "BasePrivateModel.h"
@interface ConsultModelR : BaseModel
@property (nonatomic, strong) NSString *token;
@end

@interface ConsultCustomerModelR : ConsultModelR

@end

@interface XPCreate : BaseModel //请求用model
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *consultId;
@property (nonatomic, strong) NSString *contentType;
@property (nonatomic, strong) NSString *contentJson;
@property (nonatomic, strong) NSString *UUID;
@end

@interface XPRead : BaseModel
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *consultId;
@property (nonatomic, strong) NSString *detailIds;
@end

@interface XPRemove : BaseModel
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *consultId;
@property (nonatomic, strong) NSString *detailId;
@end

@interface ConsultCustomerNewModelR : ConsultModelR
@property (nonatomic, strong) NSString *consultIds;
@property (nonatomic, strong) NSString *lastTimestamp;//最后的更新时间
@end

@interface ConsultDetailCreateModelR : BasePrivateModel

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *consultId;
@property (nonatomic, strong) NSString *contentType;
@property (nonatomic, strong) NSString *UUID;
@property (nonatomic, strong) NSString *contentJson;

@end

@interface ConsultDetailRemoveModelR : BasePrivateModel

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *consultId;
@property (nonatomic, strong) NSString *detailId;

@end

@interface ConsultItemReadModelR : ConsultModelR

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *consultId;
@property (nonatomic, strong) NSString *detailIds;

@end

@interface ConsultExpiredModelR : BaseModel

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *consultId;
@property (nonatomic, strong) NSString *point;

@end


@interface ConsultSpreadModelR : ConsultModelR

@property (nonatomic ,strong) NSString *consultId;

@end

@interface ConsultDetailCustomerModelR : ConsultModelR

@property (nonatomic ,strong) NSString *consultId;

@end

@interface ConsultSetUnreadNumModelR : ConsultModelR

@property (nonatomic, strong) NSString *num;

@end


///////



@interface ConsultCloseModelR : BasePrivateModel

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *point;
@property (nonatomic, strong) NSString *view;

@end

//增量获取解答列表model
@interface ConsultnNewDetailModelR : BasePrivateModel

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *consultIds;
@property (nonatomic, strong) NSString *lastTimestamp;//最后的更新时间

@end


@interface ConsultConsultingModelR : BasePrivateModel

@property (nonatomic, strong) NSString *token;

@end

@interface ConsultCreateModelR : BasePrivateModel

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imgUrls;
@property (nonatomic, strong) NSString *lon;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *location;

@end




@interface ConsultDetailPharModelR : BasePrivateModel

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *point;
@property (nonatomic, strong) NSString *view;
@property (nonatomic, strong) NSString *consultId;

@end

@interface ConsultDetailReceiveModelR : BasePrivateModel

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *consultId;
@property (nonatomic, strong) NSString *detailIds;

@end

 

@interface ConsultRacingModelR : BasePrivateModel

@property (nonatomic, strong) NSString *token;

@end

@interface ConsultReplyFirstgModelR : BasePrivateModel

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *consultId;

@end

@interface ConsultSpCreateModelR : BasePrivateModel

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imgUrls;
@property (nonatomic, strong) NSString *lon;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *branchId;

@end
 
