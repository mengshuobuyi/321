//
//  ScoreModel.h
//  wenYao-store
//
//  Created by Yang Yuexia on 16/5/16.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "BaseAPIModel.h"

@interface ScoreModel : BaseAPIModel

@end

@interface ScoreRankListModel : BaseAPIModel
@property (assign, nonatomic) int rank;             // 排名
@property (strong, nonatomic) NSString *empId;      // 店员ID
@property (strong, nonatomic) NSString *empName;    // 店员姓名
@property (assign, nonatomic) int lvl;          // 店员等级
@property (assign, nonatomic) int totalScore;       // 历史总积分
@property (assign, nonatomic) int score;            // 当前积分
@property (assign, nonatomic) BOOL clerk;           // 是否本店店员
@property (assign, nonatomic) BOOL isDog;           // 是否是本店店员
@end

@interface ScoreRankPageModel : BaseAPIModel
@property (assign, nonatomic) int totalAmount;      // 总记录数
@property (strong, nonatomic) NSArray *list;        // 积分排行
@property (strong, nonatomic) ScoreRankListModel *self;
@end



@interface ScoreRankDetailModel : BaseAPIModel
@property (assign, nonatomic) int rank;             // 排名
@property (strong, nonatomic) NSString *empId;      // 店员ID
@property (strong, nonatomic) NSString *empName;    // 店员姓名
@property (assign, nonatomic) int lvl;              // 店员等级
@property (strong, nonatomic) NSString *headImg;    // 店员头像
@property (assign, nonatomic) int totalScore;       // 历史总积分
@property (assign, nonatomic) int score;            // 当前总积分
@property (assign, nonatomic) int train;            // 培训积分
@property (assign, nonatomic) int market;           // 营销积分
@property (assign, nonatomic) int daily;            // 日常积分
@property (assign, nonatomic) int other;            // 其他积分
@property (assign, nonatomic) BOOL mshopFlag;       // 是否开通微商
@end