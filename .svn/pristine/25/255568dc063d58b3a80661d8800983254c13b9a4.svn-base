//
//  NotifyMsgTableViewCell.m
//  wenYao-store
//
//  Created by  ChenTaiyu on 16/5/17.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "NotifyMsgTableViewCell.h"
#import "NotifyMsgCellModel.h"
#import "MsgBox.h"
#import "IphoneAutoSizeHelper.h"

@interface NotifyMsgTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UIImageView *redPoint;

@end

@implementation NotifyMsgTableViewCell

static NSString *reuseId = @"NotifyMsgTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NotifyMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = (NotifyMsgTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"NotifyMsgTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
    self.title.font = fontSystem(kFontS4);
    self.detail.font = fontSystem(kFontS5);
    self.title.textColor = RGBHex(qwColor6);
    self.detail.textColor = RGBHex(qwColor7);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setMsgBoxCell:(id)data
{
    MsgBoxNotiMessageVo *msgModel = (MsgBoxNotiMessageVo *)data;
    self.title.text = msgModel.title;
    self.detail.text = msgModel.content;
    self.redPoint.hidden = msgModel.read.boolValue;
}

- (void)setCell:(NotifyMsgCellModel *)model
{
    self.title.text = model.title;
    self.detail.text = model.detail;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!iOSv8) {
        self.detail.preferredMaxLayoutWidth = SCREEN_W - 30.f;
    }
}

@end
