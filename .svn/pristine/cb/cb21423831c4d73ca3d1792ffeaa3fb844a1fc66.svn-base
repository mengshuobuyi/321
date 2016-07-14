//
//  CloseMedicineTableViewCell.m
//  wenYao-store
//
//  Created by garfield on 15/5/4.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "CloseMedicineTableViewCell.h"
#import "ConsultModel.h"
#import "QWGlobalManager.h"
#import "ConsultPTPModel.h"
@implementation CloseMedicineTableViewCell
- (void)UIGlobal{
    [super UIGlobal];
    self.contentView.backgroundColor=RGBAHex(qwColor2, 0);
    self.customerAvatarUrl.layer.masksToBounds = YES;
    self.customerAvatarUrl.layer.cornerRadius = 5.0;
    
    self.phoneNum.textColor = RGBHex(qwColor6);
    self.phoneNum.font = fontSystem(kFontS4);
    
    
    self.consultCreateTime.textColor = RGBHex(qwColor8);
    self.consultCreateTime.font = fontSystem(kFontS5);
    
    self.customerDistance.textColor = RGBHex(qwColor8);
    self.customerDistance.font = fontSystem(kFontS5);
    
    self.consultTitle.textColor = RGBHex(qwColor6);
    self.consultTitle.font = fontSystem(kFontS1);
}
- (void)setCell:(id)data
{
    [super setCell:data];
    self.separatorHidden=YES;
    
    self.customerDistance.hidden=NO;
    self.vBadge.hidden=YES;
    if ([data isKindOfClass:[ConsultConsultingModel class]]) {

        ConsultConsultingModel *model = (ConsultConsultingModel *)data;
        [self.closeStatus setText:@"已关闭"];
        
        self.consultCreateTime.text = model.consultFormatShowTime;
        self.phoneNum.text = model.customerIndex;

        if (model.unreadCounts.integerValue>0) {
            self.vBadge.hidden=NO;
            self.vBadge.value=model.unreadCounts.integerValue;
        }
    }
    
    
//    else if([data isKindOfClass:[PharSessionVo class]]){
//        self.customerDistance.hidden=YES;
//
//        PharSessionVo *model = (PharSessionVo *)data;
//     
//        
//        
//        self.consultCreateTime.text = model.sessionFormatShowTime;
//        self.phoneNum.text = model.customerIndex;
//        self.consultTitle.text=model.sessionLatestContent;
//        
//        if (model.unreadCounts.integerValue>0) {
//            self.vBadge.hidden=NO;
//            self.vBadge.value=model.unreadCounts.integerValue;
//        }
//    }
}

- (void)setCell:(id)data status:(int)status body:(NSString*)body{
    [self setCell:data];

    CGRect frm=_consultTitle.frame;
    frm.size.width=CGRectGetWidth(vContent.frame);
    _consultTitle.frame=frm;
    
    self.sendingActivity.hidden=YES;
    self.failureStatus.hidden = YES;
    
//    DebugLog(@"=====status==== : %d",status);
    if(status == SendFailure) {//3
  
        self.sendingActivity.hidden=YES;
        self.failureStatus.hidden = NO;
        
        frm.size.width=CGRectGetWidth(vContent.frame)-CGRectGetWidth(_failureStatus.frame)-2;
        _consultTitle.frame=frm;
        
        
    }
    else if(status == Sending){//1
        DebugLog(@"=====发送中==== : %d",status);
        self.sendingActivity.hidden=NO;
        self.failureStatus.hidden = YES;
        [self.sendingActivity startAnimating];
        frm.size.width=CGRectGetWidth(vContent.frame)-CGRectGetWidth(_failureStatus.frame)-2;
        _consultTitle.frame=frm;
    }
//    else {
//        self.sendingActivity.hidden=YES;
//        self.failureStatus.hidden = YES;
//    }
    
//    if (body.length) {
//        self.consultTitle.text=body;
//    }

}
@end
