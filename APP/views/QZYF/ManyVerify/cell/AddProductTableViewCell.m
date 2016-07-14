//
//  ManageTableViewCell.m
//  wenyao-store
//
//  Created by caojing on 15/1/19.
//  Copyright (c) 2015年 xiezhenghong. All rights reserved.
//

#import "AddProductTableViewCell.h"
#import "Tips.h"
#import "Coupn.h"
#import "UIImageView+WebCache.h"
#import "Drug.h"
#import "Verify.h"
#import <QuartzCore/QuartzCore.h>
@implementation AddProductTableViewCell

+ (CGFloat)getCellHeight:(id)data{
    return 104;
}

- (void)awakeFromNib {
    self.textField.keyboardType =  UIKeyboardTypeNumberPad;
    self.textField.delegate=self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@""]) {//删除
        return YES;
    }
    NSString *strWillChange = [self.textField.text stringByAppendingString:string];
    if (strWillChange.intValue > 999 || strWillChange.intValue == 0) {//超过数字
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.delegate btnChange:self andField:self.textField.text];
    if(self.textField.text.length>0){
    }else{
        self.textField.text=@"1";
    }
}


-(void)UIGlobal{
    [super UIGlobal];
    self.textField.layer.borderColor=RGBHex(qwColor9).CGColor;
    self.textField.textColor=RGBHex(qwColor6);
    self.textField.layer.borderWidth = 1.0;
}
-(void)setCell:(id)data{
    [super setCell:data];
    CouponProductVo *model=(CouponProductVo *)data;
    self.proName.text=model.productName;
    self.spec.text=model.spec;
    [self.productImage setImageWithURL:[NSURL URLWithString:model.productLogo] placeholderImage:[UIImage imageNamed:@"img_goods_default"] options:SDWebImageRetryFailed|SDWebImageContinueInBackground];
    self.textField.text=[NSString stringWithFormat:@"%d",model.quantity];

}

- (IBAction)deleteButton:(UIButton*)sender {
    [self.delegate btnClick:self andFlag:(int)sender.tag andField:self.textField.text];
}

- (IBAction)addButton:(UIButton*)sender {
    [self.delegate btnClick:self andFlag:(int)sender.tag andField:self.textField.text];
}



@end
