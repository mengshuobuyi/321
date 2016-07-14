//
//  AllCircleCell.h
//  wenYao-store
//
//  Created by Yang Yuexia on 15/12/18.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "QWBaseTableCell.h"
#import "QWButton.h"

@protocol AllCircleCellDelegate <NSObject>

- (void)payAttentionCircleAction:(NSIndexPath *)indexPath;

@end

@interface AllCircleCell : QWBaseTableCell

@property (assign, nonatomic) id <AllCircleCellDelegate> allCircleCellDelegate;
@property (weak, nonatomic) IBOutlet UIImageView *circleIcon;       //圈子icon
@property (weak, nonatomic) IBOutlet UILabel *circleName;           //圈子名称e
@property (weak, nonatomic) IBOutlet UILabel *attentionNum;         //圈子关注数
@property (weak, nonatomic) IBOutlet QWButton *attentionButton;     //关注按钮
@property (weak, nonatomic) IBOutlet UILabel *attentionLabel;       //关注
@property (weak, nonatomic) IBOutlet UILabel *cancelAttentionLabel; //取消关注
@property (weak, nonatomic) IBOutlet UILabel *isMaster;             //我是圈主

- (IBAction)attentionAction:(id)sender;

//全部圈子列表
- (void)configureData:(id)data withType:(int)type;

//我关注的圈子列表
- (void)attenCircle:(id)data;

//Ta关注的圈子列表
- (void)TattenCircle:(id)data;

@end
