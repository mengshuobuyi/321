//
//  AllCircleCell.m
//  wenYao-store
//
//  Created by Yang Yuexia on 15/12/18.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "AllCircleCell.h"
#import "NSString+WPAttributedMarkup.h"
#import "CircleModel.h"

@implementation AllCircleCell

- (void)UIGlobal
{
    [super UIGlobal];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    self.attentionLabel.layer.cornerRadius = 4.0;
    self.attentionLabel.layer.masksToBounds = YES;
    
    self.cancelAttentionLabel.layer.cornerRadius = 4.0;
    self.cancelAttentionLabel.layer.masksToBounds = YES;
    
    self.circleIcon.layer.cornerRadius = 3.0;
    self.circleIcon.layer.masksToBounds = YES;
    self.circleIcon.layer.borderWidth = 0.5;
    self.circleIcon.layer.borderColor = RGBHex(qwColor9).CGColor;
}

#pragma mark ---- 全部圈子列表 ----

- (void)configureData:(id)data withType:(int)type
{
    self.separatorLine.hidden = NO;
    CircleListModel *model = (CircleListModel *)data;
    
    [self commonData:model];
    
    if (model.allCircleType == 1)
    {
        //本商家圈
        self.isMaster.hidden = NO;
        self.isMaster.text = @"本商家圈";
        self.attentionLabel.hidden = YES;
        self.cancelAttentionLabel.hidden = YES;
        self.attentionButton.hidden = YES;
        self.attentionButton.enabled = NO;
        
    }else if (model.allCircleType == 2)
    {
        if (model.flagMaster)
        {
            //我是圈主
            self.isMaster.hidden = NO;
            self.isMaster.text = @"我是圈主";
            self.attentionLabel.hidden = YES;
            self.cancelAttentionLabel.hidden = YES;
            self.attentionButton.hidden = YES;
            self.attentionButton.enabled = NO;
        }else
        {
            //推荐圈子 可关注／取消关注
            self.isMaster.hidden = YES;
            self.attentionButton.hidden = NO;
            self.attentionButton.enabled = YES;
            
            if (model.flagAttn)
            {
                //已关注 显示取消关注
                self.attentionLabel.hidden = YES;
                self.cancelAttentionLabel.hidden = NO;
            }else
            {
                //未关注 显示关注
                self.attentionLabel.hidden = NO;
                self.cancelAttentionLabel.hidden = YES;
            }
        }
        
    }else if (model.allCircleType == 3)
    {
        //推荐圈子 可关注／取消关注
        self.isMaster.hidden = YES;
        self.attentionButton.hidden = NO;
        self.attentionButton.enabled = YES;
        
        if (model.flagAttn)
        {
            //已关注 显示取消关注
            self.attentionLabel.hidden = YES;
            self.cancelAttentionLabel.hidden = NO;
        }else
        {
            //未关注 显示关注
            self.attentionLabel.hidden = NO;
            self.cancelAttentionLabel.hidden = YES;
        }
    }
}

#pragma mark ---- 我关注的圈子列表 ----

- (void)attenCircle:(id)data;
{
    self.separatorLine.hidden = YES;
    CircleListModel *model = (CircleListModel *)data;
    
    [self commonData:model];
    
    //关注按钮隐藏
    self.attentionLabel.hidden = YES;
    self.cancelAttentionLabel.hidden = YES;
    self.attentionButton.hidden = YES;
    self.attentionButton.enabled = NO;
    
    //我是圈主
    if (model.flagAttenMaster) {
        self.isMaster.hidden = NO;
        self.isMaster.text = @"我是圈主";
    }else
    {
        self.isMaster.hidden = YES;
    }
}

#pragma mark ---- Ta关注的圈子列表 ----

- (void)TattenCircle:(id)data;
{
    self.separatorLine.hidden = YES;;
    CircleListModel *model = (CircleListModel *)data;
    
    [self commonData:model];
    
    //关注按钮隐藏
    self.attentionLabel.hidden = YES;
    self.cancelAttentionLabel.hidden = YES;
    self.attentionButton.hidden = YES;
    self.attentionButton.enabled = NO;
    
    //ta是圈主
    if (model.flagMaster) {
        self.isMaster.hidden = NO;
        self.isMaster.text = @"Ta是圈主";
    }else
    {
        self.isMaster.hidden = YES;
    }
}

#pragma mark ---- 圈子基本设置 ----
- (void)commonData:(id)data
{
    CircleListModel *model = (CircleListModel *)data;
    
    //头像
    [self.circleIcon setImageWithURL:[NSURL URLWithString:model.teamLogo] placeholderImage:[UIImage imageNamed:@"bg_tx_circletouxiang"]];
    
    //圈子名称
    self.circleName.text = model.teamName;
    
    //关注 帖子 数
    self.attentionNum.text = [NSString stringWithFormat:@"关注 %d    帖子 %d",model.attnCount,model.postCount];
    
}

#pragma mark ---- 关注圈子 ----
- (IBAction)attentionAction:(id)sender
{
    QWButton *btn = (QWButton *)sender;
    NSIndexPath *indexPath = (NSIndexPath *)btn.obj;
    if (self.allCircleCellDelegate && [self.allCircleCellDelegate respondsToSelector:@selector(payAttentionCircleAction:)]) {
        [self.allCircleCellDelegate payAttentionCircleAction:indexPath];
    }
}

@end
