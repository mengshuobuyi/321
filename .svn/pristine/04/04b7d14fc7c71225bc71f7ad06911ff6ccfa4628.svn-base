//
//  WechatActivityCell.m
//  wenYao-store
//
//  Created by qw_imac on 16/3/8.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "WechatActivityCell.h"
#import "UIImageView+WebCache.h"
@implementation WechatActivityCell

-(void)setCell:(MicroMallActivityVO *)data {
    self.title.text = data.title;
    self.date.text = [NSString stringWithFormat:@"活动日期:%@",data.date];
    if ([data.type integerValue] == 2) {
        self.proImg.image = [UIImage imageNamed:@"img_snapup"];
    }else if ([data.type integerValue] == 3) {
        self.proImg.image = [UIImage imageNamed:@"img_package"];
    }else {
        [self.proImg setImageWithURL:[NSURL URLWithString:data.imgUrl] placeholderImage:[UIImage imageNamed:@"药品默认图片"]];
    }
    switch ([data.type integerValue]) {
        case 1:
            self.activityImg.image  = [UIImage imageNamed:@"label_hui"];
            break;
        case 2:
            self.activityImg.image  = [UIImage imageNamed:@"label_rob"];
            break;
        case 3:
            self.activityImg.image  = [UIImage imageNamed:@"label_tao"];
            break;
        case 4:
            self.activityImg.image  = [UIImage imageNamed:@"label_huan"];
            break;
        default:
            self.activityImg.hidden = YES;
            break;
    }
    self.statusImg.hidden = YES;
    switch ([data.status integerValue]) {
        case 2:
            self.statusImg.hidden = NO;
            self.statusImg.image  = [UIImage imageNamed:@"lable_audit"];
            break;
        case 7:
            self.statusImg.hidden = NO;
            self.statusImg.image  = [UIImage imageNamed:@"label_shelves"];
            break;
        }
}

@end
