//
//  ManageTableViewCell.m
//  wenyao-store
//
//  Created by chenpeng on 15/1/19.
//  Copyright (c) 2015年 xiezhenghong. All rights reserved.
//

#import "ManageTableViewCell.h"
#import "OrderModel.h"
#import "UIImageView+WebCache.h"
@implementation ManageTableViewCell

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)UIGlobal{
    [super UIGlobal];
    self.backgraoundView.layer.borderWidth=1.0f;
    self.backgraoundView.layer.cornerRadius=5.0f;
    self.backgraoundView.layer.masksToBounds=YES;
    self.backgraoundView.layer.borderColor = [UIColor clearColor].CGColor;
    self.contentView.backgroundColor=RGBAHex(qwColor11, 1);
    
    [self setSeparatorMargin:12 edge:EdgeLeft | EdgeRight];
    [self.line setFrame:CGRectMake(self.line.frame.origin.x, self.line.frame.origin.y, self.line.frame.size.width, 0.5)];
    
}
-(void)setCell:(id)data{
    [super setCell:data];
    OrderclassBranch *branchclass=(OrderclassBranch *)data;
    int tagImage=[branchclass.type intValue];
    if (tagImage==1) {
        self.orderClass.image=[UIImage imageNamed:@"折扣.png"];
        self.classLable.text=@"折扣";
    }
    if (tagImage==2) {
        self.orderClass.image=[UIImage imageNamed:@"抵现.png"];
        self.classLable.text=@"抵现";
    }
    if (tagImage==3) {
        self.orderClass.image=[UIImage imageNamed:@"买赠.png"];
        self.classLable.text=@"买赠";
    }
    [self.productImage setImageWithURL:[NSURL URLWithString:branchclass.banner] placeholderImage:[UIImage imageNamed:@""]];
    self.productName.text=[NSString stringWithFormat:@"用户:%@", branchclass.nick];
    self.couponsNumber.text=[NSString stringWithFormat:@"订单号：%@",branchclass.id];
    self.orderTime.text=branchclass.date;
}
@end
