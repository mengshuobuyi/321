//
//  FinderSearchModel.h
//  APP
//
//  Created by 李坚 on 16/1/13.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "BaseModel.h"
#import "BaseAPIModel.h"
#import "SearchModel.h"

@interface FinderSearchModel : BaseModel

@end

//疾病Model
@interface DiscoveryDiseaseVo : BaseModel
@property (nonatomic,strong) NSString *id;          //疾病ID
@property (nonatomic,strong) NSString *diseaseName; //疾病名称
@property (nonatomic,strong) NSString *diseaseDesc; //疾病描述
@property (nonatomic,strong) NSString *diseaseType; //疾病描述
@end

//症状Model
@interface DiscoverySpmVo : BaseModel
@property (nonatomic,strong) NSString *spmId;   //症状ID
@property (nonatomic,strong) NSString *spmName; //症状名称
@property (nonatomic,strong) NSString *spmDesc; //症状描述
@end

//商品Model
@interface DiscoveryProductVo : BaseModel
@property (nonatomic,strong) NSString *prodId;      //商品ID
@property (nonatomic,strong) NSString *prodName;    //商品名称
@property (nonatomic,strong) NSString *prodImg;     //商品图片
@property (nonatomic,strong) NSString *prodSpec;    //商品规格
@property (nonatomic,strong) NSString *prodSignCode;//商品显示控制码
@property (nonatomic,strong) NSString *prodContent; //商品说明里显示的内容
@end


//问题Model
@interface DiscoveryProblemVo : BaseModel
@property (nonatomic,strong) NSString *questionId;          //问题ID
@property (nonatomic,strong) NSString *question;            //问题内容
@property (nonatomic,strong) NSString *answerId;            //答案ID
@property (nonatomic,strong) NSString *answer;              //答案内容
@property (nonatomic,strong) NSArray *highlightPositionList;//问题内容高亮位置列表
@end


//发现搜索主列表
@interface DiscoverySearchVo : BaseAPIModel

@property (nonatomic,strong) NSArray *diseaseList;  //疾病列表
@property (nonatomic,strong) NSString *diseaseCount;//疾病总数量
@property (nonatomic,strong) NSArray *spmList;      //症状列表
@property (nonatomic,strong) NSString *spmCount;    //症状总数量
@property (nonatomic,strong) NSArray *productList;  //药品列表
@property (nonatomic,strong) NSString *productCount;//药品总数量
@property (nonatomic,strong) NSArray *problemList;  //问题列表
@property (nonatomic,strong) NSString *problemCount;//问题总数量
@property (nonatomic,strong) NSString *hitContentType;//全匹配命中的内容类型：0-全匹配未命中; 1-疾病; 2-症状; 3-药
@property (nonatomic,strong) DiscoveryDiseaseVo *discoveryDiseaseVo;//匹配疾病
@property (nonatomic,strong) DiscoverySpmVo *discoverySpmVo;//匹配症状
@property (nonatomic,strong) DiscoveryProductVo *discoveryProductVo;//匹配药品
@end

//发现搜索主列表
@interface DiscoveryVo : BaseAPIModel

@property (nonatomic,strong) NSArray *list;//列表

@end




