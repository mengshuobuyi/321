//
//  MsgBoxTableViewCell.m
//  wenYao-store
//
//  Created by  ChenTaiyu on 16/5/11.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "MsgBoxTableViewCell.h"
#import "IphoneAutoSizeHelper.h"

@interface MsgBoxTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *hintPoint;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightMargin;

@end

@implementation MsgBoxTableViewCell

static NSString *reuseId = @"MsgBoxTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    MsgBoxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = (MsgBoxTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"MsgBoxTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
    self.titleLabel.font = fontSystem(QWFontS4);
    self.detailLabel.font = self.hintLabel.font = fontSystem(QWFontS5);
    self.titleLabel.textColor = RGBHex(qwColor6);
    self.detailLabel.textColor = RGBHex(qwColor7);
    self.hintLabel.textColor = RGBHex(qwColor8);

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setCell:(MsgBoxCellModel *)model
{
    self.iconImageView.image = model.icon;
    self.titleLabel.text = model.title;
    self.detailLabel.text = model.detail;
    self.hintLabel.text = model.hintText;
    self.hintPoint.hidden = model.redPointHidden;
    
    self.leftMargin.constant = self.rightMargin.constant = QWAutolayoutValue(15.f, 25.f);
    [self layoutIfNeeded];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
