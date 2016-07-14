//
//  OrderModel.h
//  APP
//
//  Created by chenpeng on 15/3/19.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseModel.h"
#import "BaseAPIModel.h"
#import "BasePrivateModel.h"
@interface OrderModel : BaseModel

@end
@interface OrderBrach : BaseAPIModel
@property (nonatomic,strong)NSArray  *list;
@property (nonatomic,strong)NSString *page;
@property (nonatomic,strong)NSString *pageSize;
@property (nonatomic,strong)NSString *pageSum;
@property (nonatomic,strong)NSString *totalRecords;

@end
@interface OrderclassBranch : BaseModel
@property (nonatomic,strong)NSString *banner;
@property (nonatomic,strong)NSString *branch;
@property (nonatomic,strong)NSString *count;
@property (nonatomic,strong)NSString *date;
@property (nonatomic,strong)NSString *desc;
@property (nonatomic,strong)NSString *discount;
@property (nonatomic,strong)NSString *empty;
@property (nonatomic,strong)NSString *emptyCount;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *inviter;
@property (nonatomic,strong)NSString *inviterName;
@property (nonatomic,strong)NSString *nick;
@property (nonatomic,strong)NSString *largess;
@property (nonatomic,strong)NSString *pay;
@property (nonatomic,strong)NSString *price;
@property (nonatomic,strong)NSString *proName;
@property (nonatomic,strong)NSString *quantity;
@property (nonatomic,strong)NSString *receipt;
@property (nonatomic,strong)NSString *remark;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *totalLargess;
@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong)NSString *useTimes;

@property (nonatomic,strong)NSString *code;
@property (nonatomic,strong)NSString *proId;
@property (nonatomic,strong)NSString *passportId;

@end




/**
 *  删除门店小票
 */
@interface Delreceipts : BaseModel
@property(nonatomic,strong)NSString *result;
@property(nonatomic,strong)NSString *msg;
@end







/**
 *  3.15.2	[用户端][扫码]查询优惠活动
 */
@interface CouponEnjoyModel : BaseModel

@property (nonatomic) NSString *id;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *desc;
@property (nonatomic) NSString *url;
@property (nonatomic) NSString *type;
@property (nonatomic) NSString *remark;
@property (nonatomic) NSString *limitPersonTimes;
@property (nonatomic) NSString *limitTotal;
@property (nonatomic) NSString *statTotal;
@property (nonatomic) NSString *statPro;
@property (nonatomic) NSString *statBranch;
@property (nonatomic) NSString *validBegin;
@property (nonatomic) NSString *validEnd;
@property (nonatomic) NSString *factory;
@property (nonatomic) NSString *proId;
@property (nonatomic) NSString *proName;
@property (nonatomic) NSString *spec;
@property (nonatomic) NSString *unit;
@property (nonatomic) NSString *useTimes;
@property (nonatomic) NSString *useTotal;
@property (nonatomic) NSString *largess;
@property (nonatomic) NSString *orderCreateTime;
@property (nonatomic) NSString *status;
@property (nonatomic) NSString *msg;

@end

@interface HealthyScenarioListModel : BaseModel

@property (nonatomic) NSString *currPage;
@property (nonatomic) NSArray *data;
@property (nonatomic) NSString *pageSize;
@property (nonatomic) NSString *totalPage;
@property (nonatomic) NSString *totalRecord;

@property (nonatomic,strong) NSString *scenarioId;


@end
@interface HealthyScenarioDrugModel : BaseModel

@property (strong,nonatomic) NSString *proId;         //商品ID
@property (strong,nonatomic) NSString *productId;       //商品编码
@property (strong,nonatomic) NSString *proName;       //全维商品过程
@property (strong,nonatomic) NSString *factory;         //生产厂家
@property (strong,nonatomic) NSString *spec;       //规格



@end
//获取症状列表page
@interface SpmListPage : BaseAPIModel

@property (strong, nonatomic) NSString              *currPage;
@property (strong, nonatomic) NSString              *pageSize;
@property (strong, nonatomic) NSString              *totalPage;
@property (strong, nonatomic) NSString              *totalRecord;
@property (strong, nonatomic) NSArray               *list;

@end
//症状列表model
@interface SpmListModel : BaseModel

@property (strong, nonatomic) NSString              *liter;                  //症状索引字母 字符
@property (strong, nonatomic) NSString              *name;                   //症状名称  字符
@property (strong, nonatomic) NSString              *population;             //人群  0:全部1:成人2:儿童  整型数字
@property (strong, nonatomic) NSString              *sex;                    //性别  0:全部 1: 男 2:女  整型数字
@property (strong, nonatomic) NSString              *sortNo;                 //排序号  整型数字
@property (strong, nonatomic) NSString              *spmCode;                //症状编码  字符
@property (strong, nonatomic) NSString              *usual;                  //是否常见症状 0:否  1:是 整型数字

@end
//部位下症状的page
@interface SpmListByBodyPage : BaseAPIModel

@property (strong, nonatomic) NSArray               *list;

@end
//3.3.35	症状明细
@interface spminfoDetail : BaseModel
@property (nonatomic,strong)NSString *spmCode;//症状编码 字符
@property (nonatomic,strong)NSString *name;//症状名称 字符
@property (nonatomic,strong)NSString *intro;//症状简介(touch专用) 字符
@property (nonatomic,strong)NSString *desc;//症状描述 字符
@property (nonatomic,strong)NSString *imgUrl;//症状图片url 字符
@property (nonatomic,strong)NSArray  *properties;//症状属性列表 是个jsonArray对象
@property (nonatomic,strong)NSString *title;//属性标题  properties列表字段 字符
@property (nonatomic,strong)NSString *content;//属性内容  properties列表字段 字符
@property (nonatomic,strong)NSString *sex;//性别  0:全部 1: 男 2:女  整型数字
@property (nonatomic,strong)NSString *population;//人群  0:全部1:成人2:儿童  整型数字
@end



@interface spminfoDetailPropertiesModel : BaseModel
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *title;
@end


@interface QueryProductClassModel : BaseAPIModel
@property (nonatomic,strong) NSString *currPage;
@property (nonatomic,strong) NSArray  *list;
@property (nonatomic,strong) NSString *pageSize;
@property (nonatomic,strong) NSString *totalPage;
@property (nonatomic,strong) NSString *totalRecord;

@end
@interface QueryProductClassItemModel : BaseModel

@property (nonatomic,strong) NSString *classDesc;
@property (nonatomic,strong) NSString *classId;
@property (nonatomic,strong) NSString *name;

@end
@interface QueryProductByClassItemModel : BaseModel

@property (nonatomic ,strong) NSString *barCode;
@property (nonatomic ,strong) NSString *makeplace;
@property (nonatomic ,strong) NSString *price;
@property (nonatomic ,strong) NSString *proId;
@property (nonatomic ,strong) NSString *proName;
@property (nonatomic ,strong) NSString *registerNo;
@property (nonatomic ,strong) NSString *sid;
@property (nonatomic ,strong) NSString *spec;
@property (nonatomic ,strong) NSString *unit;
@property (nonatomic ,strong) NSString *factory;
@end
@interface FetchProFactoryByClassModel : BaseAPIModel


@property (nonatomic ,strong) NSString *factory;

@end
@interface DiseaseFormulaPruduct : BaseAPIModel
@property (nonatomic,strong)NSString *page;
@property (nonatomic,strong)NSString *pageSize;
@property (nonatomic,strong)NSString *pageSum;
@property (nonatomic,strong)NSString *totalRecords;
@property (nonatomic,strong)NSArray  *list;
@end
@interface DiseaseFormulaPruductclass : BaseModel
//@property (nonatomic,strong)NSString *makePlace;
//@property (nonatomic,strong)NSString *proId;
//@property (nonatomic,strong)NSString *proName;
//@property (nonatomic,strong)NSString *sid;
//@property (nonatomic,strong)NSString *spec;
//@property (nonatomic,strong) NSString *imgUrl;//商品图片的地址
@property (nonatomic,strong)NSString *factory;
@property (nonatomic,strong)NSString *proId;
@property (nonatomic,strong)NSString *proName;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *spec;
@property (nonatomic,strong)NSString *promotionType;

@property (nonatomic,strong) NSString *imgUrl;//商品图片的地址

@property (nonatomic,assign) BOOL gift;
@property (nonatomic,assign) BOOL discount;
@property (nonatomic,assign) BOOL voucher;
@property (nonatomic,assign) BOOL special;
@property (nonatomic,strong)NSString *label;

@property (nonatomic,strong)NSString *desc;
@property (nonatomic,strong)NSString *promotionId;
@property (nonatomic,strong)NSString *multiPromotion;
@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong)NSString *startDate;
@property (nonatomic,strong)NSString *endDate;
@property (nonatomic,strong)NSString *source;
@end
@interface DiseaseProductList : BaseAPIModel
@property (nonatomic,strong)NSString *page;
@property (nonatomic,strong)NSString *pageSize;
@property (nonatomic,strong)NSString *pageSum;
@property (nonatomic,strong)NSString *totalRecords;
@property (nonatomic,strong)NSArray  *list;
@end
@interface DiseaseProductListclass : BaseModel
@property (nonatomic,strong)NSString *makePlace;
//@property (nonatomic,strong)NSString *factory;
@property (nonatomic,strong)NSString *proId;
@property (nonatomic,strong)NSString *proName;
@property (nonatomic,strong)NSString *spec;
@property (nonatomic,strong)NSString *sid;
@end
@interface FactoryProductListname : BaseModel
@property (nonatomic,strong)NSString *currPage;
@property (nonatomic,strong)NSString *pageSize;
@property (nonatomic,strong)NSString *totalPage;
@property (nonatomic,strong)NSString *totalRecord;
@property (nonatomic,strong)NSArray  *list;

@end
@interface pharmacyProduct : BaseAPIModel

@property (nonatomic,strong)NSString *currPage;
@property (nonatomic,strong)NSString *pageSize;
@property (nonatomic,strong)NSString *totalPage;
@property (nonatomic,strong)NSString *totalRecord;
@property (nonatomic,strong)NSArray  *list;

@end
@interface PromoteComplete : BaseAPIModel
@property (nonatomic,strong)NSString *status;

@end

@interface ClientHistoryOrder : BaseAPIModel
@property (nonatomic,strong) NSString *orderId;
@property (nonatomic,strong) NSString *customerName;
@property (nonatomic,strong) NSString *orderTime;
@property (nonatomic,strong) NSString *type;
@end

@interface ClientHistoryOrderList : BaseAPIModel
@property (strong, nonatomic) NSArray *orders;
@end

@interface HistoryOrderDetail : BaseAPIModel
@property (nonatomic,strong) NSString *orderId;
@property (nonatomic,strong) NSString *customerName;
@property (nonatomic,strong) NSString *orderTime;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *groupName;
@property (nonatomic,strong) NSString *branchName;
@property (nonatomic,strong) NSString *condition;
@end

@interface ExchangeListModel : BaseAPIModel
@property (nonatomic,strong) NSArray *orders; //兑换商品列表数组
@end

@interface ExchangeProModel : BaseAPIModel
@property (nonatomic,strong) NSString *title;        //标题
@property (nonatomic,strong) NSString *imgUrl;       //图片地址
@property (nonatomic,strong) NSString *drawId;       //兑换订单ID
@property (nonatomic,strong) NSString *score;        //兑换消耗积分
@property (nonatomic,strong) NSString *level;        //兑换所需等级
@property (nonatomic,strong) NSString *chargeNo;     //虚拟充值账号
@property (nonatomic,strong) NSString *postAddress;  //邮寄地址
@property (nonatomic,strong) NSString *drawRemark;   //买家领取留言
@property (nonatomic,strong) NSString *drawDate;     //领取时间
@property (nonatomic,strong) NSString *exchangeCode; //兑换码
@property (nonatomic,strong) NSString *exchangeDate; //领取时间
@property (nonatomic,strong) NSString *status;       // 状态（1:领取, 2:完成, 3:过期, 4:作废）
@end

@interface OrderMessageArrayVo : BaseModel

@property (nonatomic, strong) NSString *apiStatus;
@property (nonatomic, strong) NSString *apiMessage;
@property (nonatomic, strong) NSString *lastTimestamp;
@property (nonatomic, strong) NSArray *messages;

@end

@interface OrderMessageVo : BaseModel

@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *showTime;
@property (nonatomic, strong) NSString *unreadCounts;
@property (nonatomic, strong) NSString *messageId;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *showRedPoint;
@property (nonatomic, strong) NSString *objId;
@property (nonatomic, strong) NSString *objType;
@end

@interface OrderNotiModel : BasePrivateModel
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *showTime;
@property (nonatomic, strong) NSString *unreadCounts;
@property (nonatomic, strong) NSString *showRedPoint;
@property (nonatomic, strong) NSString *messageId;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *objId;
@property (nonatomic, strong) NSString *objType;
@end

@interface OrderNewCountModel : BasePrivateModel
@property (nonatomic, strong) NSString *count;
@end

//员工分享转化订单统计
@interface ShareOrderPageModel : BaseAPIModel
@property (strong, nonatomic) NSArray *resultList; // 集合
@end

@interface ShareOrderListModel : BaseAPIModel
@property (strong, nonatomic) NSString *name;      // 姓名,
@property (strong, nonatomic) NSString *mobile;    // 手机,
@property (assign, nonatomic) int changeOrder;     // 转化数
@end
