//
//  AnswerCell.m
//  wenyao-store
//
//  Created by Meng on 14-10-9.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "AnswerCell.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "MKNumberBadgeView.h"

#import "QWGlobalManager.h"

@implementation AnswerCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setUpAnswer:(QWMessage *)msg
{
    NSUInteger timestamp = [msg.timestamp intValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSString *displayTime = [QWGLOBALMANAGER updateDisplayTime:date];
    NSString *avatarUrl = msg.avatorUrl;
    NSString *relatedName = msg.nickname;
    self.lbl_Time.text = displayTime;
    
    NSString *name = relatedName;
    if (name.length > 7) {
        name = [name substringToIndex:7];
        name = [NSString stringWithFormat:@"%@...",name];
    }
    self.lbl_DefineName.text = name;
    self.lbl_Answercontent.text = msg.body;
    self.img_head.layer.masksToBounds = YES;
    self.img_head.layer.cornerRadius = 7.5;
    [self.img_head setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:@"药品默认图片.png"]];
    
    NSString* where = [NSString stringWithFormat:@"isRead = 0 and (sendname = '%@' or recvname = '%@')",msg.relatedid,msg.relatedid];
    
    NSUInteger unreadCount = [QWMessage getcountFromDBWithWhere:where];
    
    MKNumberBadgeView *badgeView = (MKNumberBadgeView *)[self.contentView viewWithTag:888];
    if(!badgeView) {
        badgeView = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(55, -5, 35, 35)];
        badgeView.shadow = NO;
        badgeView.tag = 888;
    }
    if(unreadCount != 0 )
    {
        badgeView.value = unreadCount;
        [self.contentView addSubview:badgeView];
    }else{
        [badgeView removeFromSuperview];
    }
    
    
    
}
@end
