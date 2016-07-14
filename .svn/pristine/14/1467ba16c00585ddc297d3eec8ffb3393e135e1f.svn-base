//
//  InterLocutionAnswerCell.h
//  wenYao-store
//
//  Created by Yang Yuexia on 16/4/1.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWBaseTableCell.h"

@interface InterLocutionAnswerCell : QWBaseTableCell

@property (nonatomic, strong) IBOutlet QWImageView    *customerAvatarUrl;  //头像
@property (nonatomic, strong) IBOutlet QWLabel        *phoneNum;           //姓名
@property (nonatomic, strong) IBOutlet QWLabel        *consultCreateTime;  //时间
@property (nonatomic, strong) IBOutlet QWLabel        *consultTitle;       //问答标题
@property (nonatomic, strong) IBOutlet QWLabel        *closeStatus;        //已关闭
@property (nonatomic, strong) IBOutlet UIImageView    *failureStatus;      //失败标识
@property (weak, nonatomic) IBOutlet UIImageView      *unReadStatus;       //未读标识

//解答中
- (void)setCell:(id)data type:(int)type;

//已关闭
- (void)setCell:(id)data status:(int)status body:(NSString*)body;

@end
