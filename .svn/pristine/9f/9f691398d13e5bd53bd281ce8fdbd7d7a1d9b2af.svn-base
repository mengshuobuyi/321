//
//  CreditMsgTableViewCell.m
//  wenYao-store
//
//  Created by  ChenTaiyu on 16/5/18.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "CreditMsgTableViewCell.h"
#import "MsgBox.h"
#import "CreditMsgLabel.h"
#import "IphoneAutoSizeHelper.h"

@interface CreditMsgTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet CreditMsgLabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabelTopMargin;

@end

@implementation CreditMsgTableViewCell

static NSString *reuseId = @"CreditMsgTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    CreditMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = (CreditMsgTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"CreditMsgTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib
{
    self.timeLabel.font = fontSystem(QWFontS5);
    self.timeLabel.textColor = RGBHex(qwColor8);
    self.contentLabel.font = fontSystem(QWFontS4);
    self.contentLabel.textColor = RGBHex(qwColor7);
    self.contentLabel.layer.cornerRadius = 4.0f;
    self.contentLabel.clipsToBounds = YES;
    self.contentLabel.edgeInsets = UIEdgeInsetsMake(11, 9, 11, 9);
}

- (void)setMsgBoxCell:(id)data
{
    MsgBoxCreditMessageVo *msgModel = (MsgBoxCreditMessageVo *)data;
    self.timeLabel.text = msgModel.showTime;
    
    NSString *labelText = msgModel.content;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5.0f];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    
    self.contentLabel.attributedText = attributedString;
    
    self.timeLabelHeight.constant = msgModel.showTime.length ? 21.f : 0.f;
    self.timeLabelTopMargin.constant = msgModel.showTime.length ? 20.f : 0.f;
    [self layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentLabel.preferredMaxLayoutWidth = SCREEN_W - 30.f - self.contentLabel.edgeInsets.left * 2;
}

@end
