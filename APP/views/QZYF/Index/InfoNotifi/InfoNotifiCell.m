//
//  InfoNotifiCell.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/4.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "InfoNotifiCell.h"

@implementation InfoNotifiCell

- (void)UIGlobal
{
    [super UIGlobal];
    self.redPoint.layer.cornerRadius = 4.0;
    self.redPoint.layer.masksToBounds = YES;
}

- (void)setCell:(id)data
{
    [super setCell:data];
    
    //title
    self.title.text = @"您有新的订单，请及时接单";
    CGSize titleSize = [self.title.text sizeWithFont:fontSystem(kFontS4) constrainedToSize:CGSizeMake(APP_W-140, CGFLOAT_MAX)];
    self.title_layout_width.constant = titleSize.width;
    
    //content
    self.content.text = @"用户提交了送货上门的订单，请及时接单";
    
    //time
    self.time.text = @"1分钟前";
    
}

@end
