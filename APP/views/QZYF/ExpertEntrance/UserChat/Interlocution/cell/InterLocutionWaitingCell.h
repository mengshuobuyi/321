//
//  InterLocutionWaitingCell.h
//  wenYao-store
//
//  Created by Yang Yuexia on 16/4/1.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWBaseTableCell.h"

@interface InterLocutionWaitingCell : QWBaseTableCell

@property (nonatomic, strong) IBOutlet  QWImageView  *customerAvatarUrl;  //头像
@property (nonatomic, strong) IBOutlet  QWLabel      *phoneNum;           //姓名
@property (nonatomic, strong) IBOutlet  QWLabel      *consultCreateTime;  //时间
@property (nonatomic, strong) IBOutlet  QWLabel      *consultTitle;       //最后一条聊天内容
@property (nonatomic, strong) IBOutlet  QWButton     *ignoreButton;       //忽略按钮
@property (nonatomic, strong) IBOutlet  QWButton     *answerButton;       //我来抢答

@end
