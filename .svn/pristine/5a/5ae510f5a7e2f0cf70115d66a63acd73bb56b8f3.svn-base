//
//  RptModel.h
//  wenYao-store
//
//  Created by Yang Yuexia on 15/12/9.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "BaseAPIModel.h"

@interface RptModel : BaseAPIModel

@end

@interface RptListModel : BaseAPIModel
@property (strong, nonatomic) NSString *mktgId; // 营销方案ID
@property (strong, nonatomic) NSString *mktgTitle; // 营销方案标题
@property (strong, nonatomic) NSString *date; // 时间。已格式化
@end

@interface RptPageModel : BaseAPIModel
@property (strong, nonatomic) NSArray *mktgs;
@end

@interface RptDetailModel : BaseAPIModel
@property (strong, nonatomic) NSArray *charts; //饼图百分比
@property (strong, nonatomic) NSArray *labels; //文字信息
@end

@interface RptDetailTextModel : BaseAPIModel
@property (strong, nonatomic) NSString *label; //文案信息
@property (strong, nonatomic) NSString *value; //数值
@end