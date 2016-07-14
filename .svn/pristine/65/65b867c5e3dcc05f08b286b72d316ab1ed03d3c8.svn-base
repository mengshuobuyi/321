//
//  TrainModel.h
//  wenYao-store
//
//  Created by PerryChen on 5/12/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "BaseAPIModel.h"

@interface TrainRootModel : BaseAPIModel

@end

@interface TrainListVoModel : TrainRootModel
@property (nonatomic, strong) NSArray *trainList;
@end

@interface TrainVoModel : TrainRootModel
@property (nonatomic, strong) NSString *trainId;        // 培训ID,
@property (nonatomic, strong) NSString *bizCode;        // 业务编码,
@property (nonatomic, strong) NSString *type;           // 分类（1:问卷, 2:生意经, 3:工业品, 4:版本说明）,
@property (nonatomic, strong) NSString *title;          // 标题,
@property (nonatomic, strong) NSString *tag;            // 标签
@property (nonatomic, strong) NSString *icon;           // 图标,
@property (nonatomic, strong) NSString *content;        // 培训内容,
@property (nonatomic, strong) NSString *readCount;      // 阅读数,
@property (nonatomic, strong) NSString *joinCount;      // 参与数,
@property (nonatomic, strong) NSString *score;          // 奖励积分,
@property (nonatomic, strong) NSString *flagTop;        // 是否置顶(Y/N),
@property (nonatomic, strong) NSString *flagfinis;      // 任务是否完成(Y/N),
@property (nonatomic, strong) NSString *publishDate;    // 上线时间
@end
