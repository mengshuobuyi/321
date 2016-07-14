//
//  AnswerTableViewCell.m
//  wenYao-store
//
//  Created by 李坚 on 15/7/7.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "AnswerTableViewCell.h"
#import "ConsultPTPModel.h"
#import "QWGlobalManager.h"
#import "XHMessage.h"
#import "UIImageView+WebCache.h"
@implementation AnswerTableViewCell

- (void)awakeFromNib {
    // Initialization code
    

}

- (void)UIGlobal{
    [super UIGlobal];
    self.customerAvatarUrl.layer.masksToBounds = YES;
    self.customerAvatarUrl.layer.cornerRadius = 4.0f;
    
    self.separatorLine.backgroundColor = RGBHex(qwColor10);
    self.separatorLine.hidden = NO;
    [self setSeparatorMargin:15 edge:EdgeLeft];
}

- (void)setCell:(id)data{
    
    [super setCell:data];
    
    
    self.vBadge.hidden=YES;

    PharSessionVo *model = (PharSessionVo *)data;

    self.consultTitle.text = model.sessionLatestContent;
    self.consultCreateTime.text = model.sessionFormatShowTime;
    self.phoneNum.text = model.customerIndex;
        
    if (model.unreadCounts.integerValue>0) {
        self.vBadge.hidden=NO;
        self.vBadge.value=model.unreadCounts.integerValue;
    }
    
    if (model.customerAvatarUrl)
//        [UIImageView setImageWithURL]
        [self.customerAvatarUrl setImageWithURL:[NSURL URLWithString:model.customerAvatarUrl] placeholderImage:[UIImage imageNamed:@"answer-head"] options:SDWebImageRetryFailed|SDWebImageContinueInBackground];
    
}

- (void)setCell:(id)data msg:(QWMessage*)msg{
    [self setCell:data];
    
    self.failureStatus.hidden = YES;
    self.sendingActivity.hidden = YES;
    DebugLog(@"=====status==== : %@ \n%@",data ,msg);
    
    CGRect rect = self.consultTitle.frame;
    rect.size.width = APP_W - 75;
    rect.origin.x = 72.0f;
    self.consultTitle.frame = rect;
    
    PharSessionVo *model = (PharSessionVo *)data;
//    DebugLog(@"%f-%f:%@",model.sessionLatestTime.doubleValue,msg.timestamp.doubleValue,model.sessionLatestContent);
    if ((model.sessionLatestTime.doubleValue-msg.timestamp.doubleValue)>0) {
        
        return;
    }
    
    if(msg.issend.intValue == SendFailure) {//3

        self.failureStatus.hidden = NO;
  
        if (msg.body.length) {
            CGRect rect = self.consultTitle.frame;
            rect.size.width = APP_W - 186;
            rect.origin.x = 102.0f;
            self.consultTitle.frame = rect;
            self.consultTitle.text = msg.body;
        }
    }
    else if(msg.issend.intValue == Sending){//1

        CGRect rect = self.consultTitle.frame;
        rect.size.width = APP_W - 186;
        rect.origin.x = 102.0f;
        self.consultTitle.frame = rect;
        self.consultTitle.text = msg.body;
        self.sendingActivity.hidden=NO;
        self.failureStatus.hidden = YES;
        [self.sendingActivity startAnimating];
    }else{
        
    }
    self.consultTitle.text = msg.body;
    
}

@end
