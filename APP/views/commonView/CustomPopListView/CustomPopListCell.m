//
//  CustomPopListCell.m
//  wenYao-store
//
//  Created by Yang Yuexia on 15/12/18.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "CustomPopListCell.h"
//#import "Constant.h"

@implementation CustomPopListCell

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

//在自定义cell中实现，两种方法都可行，一个是改颜色，一个是用图片
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if(highlighted) {
        self.bg.backgroundColor = RGBHex(qwColor1);
    } else {
        self.bg.backgroundColor = RGBHex(qwColor1);
    }

}

@end
