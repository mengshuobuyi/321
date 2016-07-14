//
//  TrainModelR.h
//  wenYao-store
//
//  Created by PerryChen on 5/12/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "BaseAPIModel.h"

@interface TrainModelR : BaseAPIModel
@property (nonatomic, strong) NSString *token;
@end

@interface TrainListModelR : TrainModelR
@property (nonatomic, strong) NSString *viewType;   // 显示列表（0：培训，1：生意经）
@property (nonatomic, strong) NSString *searchSource;   //查询来源(1:全部, 2:商家)
@property (nonatomic, strong) NSString *page;
@property (nonatomic, strong) NSString *pageSize;
@end

@interface TrainDetailModelR : TrainModelR
@property (nonatomic, strong) NSString *trainId;
@property (nonatomic, strong) NSString *reqChannel; // 请求的渠道(0:列表 1:超链接)
@end
