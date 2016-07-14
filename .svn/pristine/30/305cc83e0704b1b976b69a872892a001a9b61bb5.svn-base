//
//  QWBaseTableCell.m
//  APP
//
//  Created by Yan Qingyang on 15/2/27.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseTableCell.h"
@interface QWBaseTableCell ()
{

 
}
@end

@implementation QWBaseTableCell

/**
 *  无xib调用initWithStyle，需要在此初始化控件
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        /**
         *  不在xib的控件在此初始化
         */
        
    }
    return self;
}


/**
 *  对控件颜色，字体，字体大小写在此方法体内
 */
- (void)UIGlobal{
    [super UIGlobal];
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor=RGBAHex(qwColor4, 1);
    self.separatorLine.backgroundColor = RGBAHex(qwColor10, 1);
    
//    [self setSelectedBGColor:RGBHex(qwColor10)];
}

/**
 *  控件加载数据
 *
 *  @param data 来源数据，默认都是已定义model
 */
- (void)setCell:(id)data{
    [super setCell:data];
    
}


@end
