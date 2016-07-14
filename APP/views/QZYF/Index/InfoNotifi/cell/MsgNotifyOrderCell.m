//
//  MsgNotifyOrderCell.m
//  APP
//
//  Created by PerryChen on 1/19/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "MsgNotifyOrderCell.h"
#import "Order.h"
#import "QWGlobalManager.h"
#import "MsgBox.h"
#import "IphoneAutoSizeHelper.h"

@implementation MsgNotifyOrderCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//消息中心使用的setter
- (void)setMsgBoxCell:(id)data
{
    MsgBoxOrderMessageVo *msgModel = (MsgBoxOrderMessageVo *)data;
    self.lblTitle.text = msgModel.title;
    self.lblContent.text = msgModel.content;
    self.lblTime.text = msgModel.showTime;
    self.lblTitle.textColor = RGBHex(qwColor6);
    self.lblTitle.font = fontSystem(QWFontS4);
    self.lblContent.textColor = RGBHex(qwColor7);
    self.lblContent.font = fontSystem(QWFontS5);
    self.lblTime.textColor = RGBHex(qwColor8);
    self.lblTime.font = fontSystem(QWFontS5);
    if ([msgModel.read intValue] == 0) {
        self.imgViewRedPoint.hidden = NO;
    } else {
        self.imgViewRedPoint.hidden = YES;
    }}

- (void)setCell:(id)data
{
    //    [super setCell:data];
    OrderNotiModel *msgModel = (OrderNotiModel *)data;
    self.lblTitle.text = msgModel.title;
    self.lblContent.text = msgModel.content;
    self.lblTime.text = msgModel.showTime;
    self.lblContent.textColor = RGBHex(qwColor6);
    self.lblContent.font = fontSystem(QWFontS4);
    self.lblTime.textColor = RGBHex(qwColor8);
    self.lblTime.font = fontSystem(QWFontS5);
    if ([msgModel.showRedPoint intValue] == 1) {
        self.imgViewRedPoint.hidden = NO;
    } else {
        self.imgViewRedPoint.hidden = YES;
    }
    
}
@end
