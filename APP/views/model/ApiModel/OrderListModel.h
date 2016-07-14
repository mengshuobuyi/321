//
//  OrderListModel.h
//  wenYao-store
//
//  Created by qw_imac on 16/1/15.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "BaseModel.h"
#import "BaseAPIModel.h"
/*****************
 * 3.0订单相关
 *****************/
@interface OrderListModel : BaseAPIModel
@property (nonatomic,strong)NSString *page;
@property (nonatomic,strong)NSString *pageSize;
@property (nonatomic,strong)NSString *pageSum;
@property (nonatomic,strong)NSString *totalRecords;
@property (nonatomic,strong)NSArray *list;
@end


@interface MicroMallShopOrderVO : BaseModel
@property (nonatomic,strong)NSString *orderId;//订单id
@property (nonatomic,strong)NSString *orderCode;//订单编码,
@property (nonatomic,strong)NSString *create; //订单创建时间,
@property (nonatomic,strong)NSString *receiver; //收货人姓名,
@property (nonatomic,strong)NSString *receiverTel; // 收货人手机号,
@property (nonatomic,strong)NSString *orderStatus; // 商家订单显示状态（1:待接单 2:待配送 3:配送中 5:已拒绝 6:待取货 8:已取消 9:已完成）,
@property (nonatomic,strong)NSString *deliver; // 配送方式（1:到店自提 2:送货上门 3:快递）,
@property (nonatomic,strong)NSString *waybillNo;// 快递单号,
@property (nonatomic,strong)NSString *expressCompany; // 快递公司,
@property (nonatomic,strong)NSString *finalAmount; //商品总额,
@property (nonatomic,strong)NSString *createStr;
@property (nonatomic,assign)BOOL uploadBill;//是否已上传小票,
@property (nonatomic,strong)NSString *payType;
@property (nonatomic,strong)NSString *onLinePayType;//在线支付方式(1:支付宝;2:微信),
@property (nonatomic,strong)NSArray *microMallOrderDetailVOs;// 订单商品列表
@property (nonatomic,strong)NSString *rewardScore;//  订单奖励积分,
@property (nonatomic,assign)BOOL overLimit;// 是否超出奖励积分的限制
@end


@interface MicroMallOrderDetailVO : BaseModel
@property (nonatomic,strong)NSString *productCode;//商品编码,
@property (nonatomic,strong)NSString *imgUrl;//商品图片地址
@end

@interface OperateShopOrderModel : BaseAPIModel

@end

@interface LCModel : BaseAPIModel
@property (nonatomic,strong) NSArray *list;
@end

@interface ExpressCompanyVO : BaseModel
@property (nonatomic,strong)NSString *code; //快递公司编码
@property (nonatomic,strong)NSString *name; // 快递公司名字
@end

@interface FillLogisticsModel : BaseAPIModel

@end

@interface ShopOrderDetailVO : BaseAPIModel
@property (nonatomic,strong)NSString *orderId;// 订单id,
@property (nonatomic,strong)NSString *orderCode;// 订单编码,
@property (nonatomic,strong)NSString *branchName;// 门店名称,
@property (nonatomic,strong)NSString *branchMobile;// 门店联系方式,
@property (nonatomic,strong)NSString *orderStatus;//商家订单显示状态（1:待接单 2:待配送 3:配送中 5:已拒绝 6:待取货 8:已取消 9:已完成）,
@property (nonatomic,strong)NSString *workStart;// 营业开始时间,
@property (nonatomic,strong)NSString *workEnd;// 营业结束时间,
@property (nonatomic,strong)NSString *deliverStart;// 配送开始时间,
@property (nonatomic,strong)NSString *deliverEnd;// 配送结束时间,
@property (nonatomic,strong)NSString *finalAmount;// 合计金额,
@property (nonatomic,strong)NSString *proAmount ;// 商品总额,
@property (nonatomic,strong)NSString *create;//下单时间,
@property (nonatomic,strong)NSString *receiver;// 收货人姓名,
@property (nonatomic,strong)NSString *receiverTel;// 收货人手机号,
@property (nonatomic,strong)NSString *deliverType;//配送方式（1:到店自提 2:送货上门 3:快递）,
@property (nonatomic,strong)NSString *deliverStatus;//配送状态（1:待配送 2:配送中 3:已配送）,
@property (nonatomic,strong)NSString *waybillNo;// 快递单号,
@property (nonatomic,strong)NSString *expressCompany;// 快递公司名称,
@property (nonatomic,strong)NSString *receiveCode;// 收获码,
@property (nonatomic,strong)NSString *receiveAddr;// 收货人地址,
@property (nonatomic,strong)NSString *payType;//支付方式（1:当面支付 2:网上支付）,
@property (nonatomic,strong)NSString *discountAmount;// 优惠多少钱,
@property (nonatomic,strong)NSString *deliverAmount;// 配送费,
@property (nonatomic,strong)NSString *actTitle;// 优惠标题,
@property (nonatomic,strong)NSString *orderDescUser;// 卖家备注,
@property (nonatomic,strong)NSString *giftName;//赠品名称,
@property (nonatomic,strong)NSString *receiveLnt;// 收货人定位经度,
@property (nonatomic,strong)NSString *receiveLat;// 收货人定位纬度,
@property (nonatomic,strong)NSString *orderDesc;// 订单状态描述,
@property (nonatomic,strong)NSString *createStr;// 格式化后的下单时间,
@property (nonatomic,strong)NSString *branchPmt;// 店铺优惠,
@property (nonatomic,strong)NSArray *microMallOrderDetailVOs;// 订单商品列表
@property (nonatomic,strong)NSArray *orderComboVOs;  //套餐列表,
@property (nonatomic,strong)NSArray *redemptionPro;   //换购列表
@property (nonatomic,strong)NSString *refundStatus; //在线支付退款状态（0:无 1:退款中 2:已退款）
@property (nonatomic,assign)long paySeconds; // 剩余支付时间，单位：秒,
@property (nonatomic,assign)BOOL uploadBill;// 是否已上传小票,
@property (nonatomic,strong)NSString *orderPmt;//订单优惠
@property (nonatomic,strong)NSString *invoiceUrl;//订单小票的URL
@property (nonatomic,strong)NSString *dealer;//处理人
@property (nonatomic,strong)NSString *userId;//用户id
@property (nonatomic,strong)NSString *onLinePayType;//支付方式(1:支付宝;2:微信),
@end

@interface OrderComboVo : BaseModel
@property (nonatomic,strong)NSString *comboName;    //套餐名字
@property (nonatomic,strong)NSString *comboPrice;   //套餐价格
@property (nonatomic,strong)NSString * comboAmount;  //套餐数量
@property (nonatomic,strong)NSArray *microMallOrderDetailVOs; //套餐商品列表
@end

@interface ShopMicroMallOrderDetailVO : BaseModel
@property (nonatomic,strong)NSString *productCode;//商品编码,
@property (nonatomic,strong)NSString *imgUrl;// 商品图片地址,
@property (nonatomic,strong)NSString *proName;// 商品名称,
@property (nonatomic,strong)NSString *price;//商品价格,
@property (nonatomic,strong)NSString *priceDiscount;// 优惠价,
@property (nonatomic,strong)NSString *actType;//微商优惠活动类型（1:微商优惠商品 2:抢购 3:优惠券）,
@property (nonatomic,strong)NSString *actId;//优惠活动ID,
@property (nonatomic,strong)NSString *actTitle;//优惠活动标题,
@property (nonatomic,strong)NSString *proAmount;//商品件数
@property (nonatomic,strong)NSString *freeBieQty;// 赠品数量,
@property (nonatomic,strong)NSString *freeBieName;// 赠品名称
@property (nonatomic,strong)NSString *actDesc;// 优惠活动描述,
@property (nonatomic,strong)NSString *spec;
@property (nonatomic,strong)NSString *branchProId;//门店商品id,
@property (nonatomic,strong)NSString *proTag;//工业品赠送店员积分tag
@end

@interface CancelReasonModel : BaseAPIModel
@property (nonatomic,strong) NSArray *list;
@end

@interface PerformanceOrdersVO : BaseAPIModel
@property (nonatomic,strong)NSString *totalAmount;          // 总订单数
@property (nonatomic,strong)NSArray *microMallShopOrderVOs; // 订单列表
@end
