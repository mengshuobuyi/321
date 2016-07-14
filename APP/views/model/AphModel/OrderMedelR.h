//
//  OrderMedelR.h
//  APP
//
//  Created by chenpeng on 15/3/19.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseModel.h"

@interface OrderMedelR : BaseModel

@end
/**
 *  3.15.11	[药店端] 查询优惠订单列表
 */
@interface OrderBranchR : BaseModel
@property (nonatomic,strong)NSString *token;
@property (nonatomic,strong)NSString *index;
@property (nonatomic,strong)NSString *page;
@property (nonatomic,strong)NSString *pageSize;

@end



@interface DelreceiptsR : BaseModel
@property(nonatomic,strong)NSString *order;

@end

/**
 *  收藏
 */
@interface FavoriteCollectR : BaseModel
@property (nonatomic,strong)NSString *token;
@property (nonatomic,strong)NSString *objId;
@property (nonatomic,strong)NSString *objType;
@property (nonatomic,strong)NSString *method;
@end


@interface HealthyScenarioDrugModelR : BaseModel

@property (nonatomic) NSString  *classId;
@property (nonatomic) NSNumber *currPage;
@property (nonatomic) NSNumber *pageSize;

@end
@interface SpmListModelR : BaseModel

@property (strong, nonatomic) NSString *currPage;
@property (strong, nonatomic) NSString *pageSize;

@end
@interface SpmListByBodyModelR : BaseModel

@property (strong, nonatomic) NSString      *currPage;
@property (strong, nonatomic) NSString      *pageSize;
@property (strong, nonatomic) NSString      *bodyCode;           //部位编码
@property (strong, nonatomic) NSString      *population;         //人群  0：全部  1：成人  2：儿童  字符
@property (strong, nonatomic) NSString      *position;
@property (strong, nonatomic) NSString      *sex;                //性别  0：全部  1：男 2：女 字符

@end
//3.3.35	症状明细
@interface spminfoDetailR : BaseModel
@property (nonatomic,strong)NSString *spmCode;

@end
@interface QueryProductByClassModelR : BaseModel

@property (nonatomic ,strong) NSString *classId;
@property (nonatomic ,strong) NSString *factory;
@property (nonatomic ,strong) NSNumber *currPage;
@property (nonatomic ,strong) NSNumber *pageSize;

@end
@interface FetchProFactoryByClassModelR : BaseModel

@property (nonatomic ,strong) NSString *classId;
@property (nonatomic ,strong) NSNumber *currPage;
@property (nonatomic ,strong) NSNumber *pageSize;

@end
@interface DiseaseFormulaPruductR : BaseModel
@property (nonatomic,strong)NSString *diseaseId;//疾病ID，字符串，必填项
@property (nonatomic,strong)NSString *formulaId;//组方配方ID，字符串，必填项
@property (nonatomic,strong)NSString *currPage;//
@property (nonatomic,strong)NSString *pageSize;

@end
//3.3.19	疾病相关商品查询(OK)
@interface DiseaseProductListR : BaseModel
@property (nonatomic,strong)NSString *diseaseId;//所属疾病Id，字符串，必填项
@property (nonatomic,strong)NSString *type;//疾病关联类型，字符串，必填项（1:治疗用药, 2:保健食品, 3:医疗用品）
@property (nonatomic,strong)NSString *currPage;//当前页数（分页使用）整型
@property (nonatomic,strong)NSString *pageSize;//每页显示数据条数（分页使用，不使用分页时候可以传入0）整型

@property (nonatomic,strong)NSString *province;
@property (nonatomic,strong)NSString *city;
@property (nonatomic,strong)NSString *v;
@end
//3.3.31	获取生产厂家产品列表
@interface FactoryProductListnameR : BaseModel
@property (nonatomic,strong)NSString *factoryCode;//生产厂家编号(字符类型)，必填项
@property (nonatomic,strong)NSString *currPage;//当前页数（分页使用）
@property (nonatomic,strong)NSString *pageSize;//每页显示数据条数（分页使用，不使用分页时候可以传入0）


@end
@interface pharmacyProductR : BaseModel
@property (nonatomic,strong)NSString *groupId;
@property (nonatomic,strong)NSString *currPage;
@property (nonatomic,strong)NSString *pageSize;
@end

@interface PromoteCompleteR : BaseModel
@property (nonatomic,strong)NSString *token;
//@property (nonatomic,strong)NSString *promotionId;
@property (nonatomic,strong)NSString *code;
//@property (nonatomic,strong)NSString *proId;
//@property (nonatomic,strong)NSString *price;
//@property (nonatomic,strong)NSString *quantity;
//@property (nonatomic,strong)NSString *passportId;
//@property (nonatomic,strong)NSString *inviter;

@end

@interface OrderNotiListModelR : BaseModel
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *view;
@end

@interface OrderNewNotiListModelR : BaseModel
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *lastTimestamp;
@end

@interface RemoveByCustomerOrderR : BaseModel
@property (nonatomic, strong) NSString *messageId;
@end

@interface OrderNotiReadR : BaseModel
@property (nonatomic, strong) NSString *messageId;
@end

@interface OrderNewCountModelR : BaseModel
@property (nonatomic, strong) NSString *token;

@end
