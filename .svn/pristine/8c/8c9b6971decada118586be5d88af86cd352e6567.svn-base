//
//  SoftwareUserInfoCell.h
//  wenYao-store
//
//  Created by YYX on 15/7/6.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseTableCell.h"

@protocol SoftwareUserInfoCellDelegate <NSObject>

// 添加图片代理
- (void)addImageAction:(NSInteger)indexPath;

//删除图片代理
- (void)deleteImageAction:(NSInteger)indexPath;

//跳转到下一页
- (void)pushToNextDelegate:(id)sender;

@end

@interface SoftwareUserInfoCell : QWBaseTableCell

@property (assign, nonatomic) id <SoftwareUserInfoCellDelegate>softwareUserInfoCellDelegate;

// 分类名称
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

// 银行等账号的内容
@property (weak, nonatomic) IBOutlet UILabel *label;

// 姓名 内容
@property (weak, nonatomic) IBOutlet UILabel *namelabel;

// 手机 内容
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

// 审核中 状态
@property (weak, nonatomic) IBOutlet UILabel *checkLabel;

// 审核中的图片状态
@property (weak, nonatomic) IBOutlet UIImageView *checkImage;

// 添加身份证 图片
@property (weak, nonatomic) IBOutlet UIImageView *addImage;

// 删除身份证 图片
@property (weak, nonatomic) IBOutlet UIImageView *deleteImage;

// 添加身份证 tap 区
@property (weak, nonatomic) IBOutlet UIImageView *addTapBg;

// 删除身份证 tap 区
@property (weak, nonatomic) IBOutlet UIImageView *deleteTapBg;

// 跳转到下一页 按钮 
@property (weak, nonatomic) IBOutlet QWButton *pushButton;
//未完善
@property (weak, nonatomic) IBOutlet UILabel *noOKUser;

- (IBAction)pushToNext:(id)sender;

@end
