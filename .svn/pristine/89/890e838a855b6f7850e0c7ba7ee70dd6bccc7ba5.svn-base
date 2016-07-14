//
//  drug.h
//  APP
//
//  Created by carret on 15/3/3.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseAPIModel.h"

@interface DrugModel : BaseAPIModel
@property (nonatomic,strong) NSArray  *list;
@end

//扫码获取商品
@interface CoupnProductModel : BaseAPIModel

@property (nonatomic ,strong) NSString *id;
@property (nonatomic ,strong) NSString *factory;
@property (nonatomic ,strong) NSString *proId;
@property (nonatomic ,strong) NSString *proName;
@property (nonatomic ,strong) NSString *spec;
@property (nonatomic ,strong) NSString *promotionType;
@property (nonatomic,strong) NSString *imgUrl;//商品图片的地址

@end
//扫码获取商品的用法用量
@interface ProductUsage : BaseAPIModel
@property (nonatomic ,strong) NSString *dayPerCount;
@property (nonatomic ,strong) NSString *drugTag;
@property (nonatomic ,strong) NSString *perCount;
@property (nonatomic ,strong) NSString *unit;
@property (nonatomic ,strong) NSString *useMethod;
@property (nonatomic ,strong) NSString *drugTime;
@end

//扫码获取药品信息
@interface DrugScanModel : BaseAPIModel

@property (nonatomic, strong) NSArray *list;

@end

//我的用药
@interface QueryProductByKeywordModel : DrugModel

@property (nonatomic,strong)NSString *proId;
@property (nonatomic,strong)NSString *proName;
@property (nonatomic,strong)NSString *spec;
@property (nonatomic,strong)NSString *factory;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *price;
@property (nonatomic,strong)NSString *registerNo;
@property (nonatomic,strong)NSString *promotionType;
@property (nonatomic,strong)NSString *imgUrl;

@end

@interface DrugSellWellProductsModel : BaseAPIModel

@property (nonatomic ,strong) NSString *currPage;
@property (nonatomic ,strong) NSString *pageSize;
@property (nonatomic ,strong) NSString *pageSum;
@property (nonatomic ,strong) NSString *totalRecords;
@property (nonatomic ,strong) NSString *page;
@property (nonatomic ,strong) NSArray  *list;

@end

@interface DrugSellWellProductsFactoryModel :BaseModel

@property (nonatomic ,strong) NSString *factory;
@property (nonatomic ,strong) NSString *proId;
@property (nonatomic ,strong) NSString *proName;
@property (nonatomic ,strong) NSString *spec;
@property (nonatomic ,strong) NSString *tag;
@property (nonatomic,strong) NSString *imgUrl;//商品图片的地址

@end




//----------------搜索----------------------------

@interface GetSearchKeywordsModel : BaseAPIModel
@property (nonatomic,strong)NSString *page;
@property (nonatomic,strong)NSString *pageSize;
@property (nonatomic,strong)NSString *pageSum;
@property (nonatomic,strong)NSString *totalRecords;
@property (nonatomic,strong)NSArray  *list;
@end

//优惠商品搜索
@interface BranchSearchPromotionProVO : BaseAPIModel
@property (nonatomic,strong)NSString *productId;
@property (nonatomic,strong)NSString *proId;
@property (nonatomic,strong)NSString *proName;
@property (nonatomic,strong)NSString *spec;
@property (nonatomic,strong)NSString *factory;
@property (nonatomic,strong)NSString *imgUrl;
@property (nonatomic,strong)NSNumber *saleNum;
@property (nonatomic,strong)NSString *promotionId;
@property (nonatomic,strong)NSString *lable;
@property (nonatomic,strong)NSNumber *type;
@property (nonatomic,strong)NSString *source;
@property (nonatomic,strong)NSString *startDate;
@property (nonatomic,strong)NSString *endDate;
@end




@interface GetSearchKeywordsclassModel : BaseModel
@property(nonatomic,strong)NSString *gswId;
@property(nonatomic,strong)NSString *gswCname;
@property(nonatomic,strong)NSString *gswPym;
@end


@interface DiseaseSpmProductbykwid : BaseAPIModel
@property (strong, nonatomic) NSString          *page;
@property (strong, nonatomic) NSString          *pageSize;
@property (strong, nonatomic) NSString          *pageSum;
@property (strong, nonatomic) NSString          *totalRecords;
@property (strong, nonatomic) NSArray           *list;
@end


@interface Diseaseclasskwid : BaseModel
@property (strong,nonatomic) NSString *diseaseId;//疾病ID
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *nodeDesc;
@property (strong,nonatomic) NSString *sortNo;
@property (strong,nonatomic) NSString *type;

@end

@interface Spmclasskwid : BaseModel
@property (strong,nonatomic) NSString *spmCode;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *liter;
@property (strong,nonatomic) NSString *usual;
@property (strong,nonatomic) NSString *sortNo;
@property (strong,nonatomic) NSString *sex;
@property (strong,nonatomic) NSString *population;

@end

@interface productclassBykwId : BaseModel
@property (nonatomic,strong)NSString *proId;
@property (nonatomic,strong)NSString *proName;
@property (nonatomic,strong)NSString *spec;
@property (nonatomic,strong)NSString *makeplace;
@property (nonatomic,strong)NSString *factory;
@property (nonatomic,strong) NSString *imgUrl;//商品图片的地址
@property (nonatomic,assign)BOOL gift;
@property (nonatomic,assign)BOOL discount;
@property (nonatomic,assign)BOOL voucher;
@property (nonatomic,assign)BOOL special;
@property (nonatomic,assign)BOOL multiPromotion;
@property (nonatomic,strong)NSString *productId;
@property (nonatomic,strong)NSString *label;
@property (nonatomic,strong)NSString *desc;
@property (nonatomic,strong)NSString *promotionId;
@property (nonatomic,strong)NSNumber *type;
@property (nonatomic,strong)NSString *startDate;
@property (nonatomic,strong)NSString *endDate;
@property (nonatomic,strong)NSString *source;
@end


//疾病分类分页
@interface DiseaseClassPage : BaseModel

@property (strong, nonatomic) NSString          *page;          //当前页数（分页使用）
@property (strong, nonatomic) NSString          *pageSize;          //每页显示数据条数（分页使用，不使用分页时候可以传入0
@property (strong, nonatomic) NSString          *pageSum;
@property (strong, nonatomic) NSString          *totalRecords;
@property (strong, nonatomic) NSArray           *list;

@end
@interface PossibleDisease : BaseModel
@property (strong,nonatomic) NSString *diseaseId;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *desc;
@property (strong,nonatomic) NSString *type;
@property (strong,nonatomic) NSString *sortNo;
@end


//---------------------------

//本店咨询 搜索药品
@interface StoreSearchMedicinePageModel : BaseAPIModel
@property (strong, nonatomic) NSArray *productList;        //搜索结果
@end
//
//@interface StoreSearchMedicineListModel : BaseAPIModel
//@property (strong, nonatomic) NSString * proId;         //商品编码,
//@property (strong, nonatomic) NSString * proName;       //商品名称,
//@property (strong, nonatomic) NSString * imgUrl;        //商品图片地址,
//@property (strong, nonatomic) NSString * content;       //商品需要展示的说明内容,
//@property (strong, nonatomic) NSString * showPrice;     //商品展示价。无值表示无药店售卖,
//@property (strong, nonatomic) NSString * spec;          //商品规格,
//@property (strong, nonatomic) NSString * branchProId;   //门店商品id。仅店内搜索时才有值
//@end

//专家咨询 搜索药品
@interface ExpertSearchMedicinePageModel : BaseAPIModel
@property (strong, nonatomic) NSArray *qwProductList;   //全维商品列表
@end

@interface ExpertSearchMedicineListModel : BaseAPIModel
@property (strong, nonatomic) NSString * productId;     //商品ID,
@property (strong, nonatomic) NSString * proId;         //商品编码,
@property (strong, nonatomic) NSString * proName;       //商品名称,
@property (strong, nonatomic) NSString * spec;          //规格,
@property (strong, nonatomic) NSString * factory;       //生产企业,
@property (strong, nonatomic) NSString * imgUrl;        //商品图片
@end

@interface  ShitSearchPageModel : BaseAPIModel
@property (strong, nonatomic) NSArray *list;
@end

@interface ShitSearchListModel : BaseAPIModel
@property (strong, nonatomic) NSString *content;        //高亮联想词内容
@end



