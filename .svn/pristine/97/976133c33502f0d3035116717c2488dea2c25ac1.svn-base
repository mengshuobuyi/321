//
//  ManageTableViewCell.m
//  wenyao-store
//
//  Created by caojing on 15/1/19.
//  Copyright (c) 2015年 xiezhenghong. All rights reserved.
//

#import "SlowAddProductTableViewCell.h"
#import "Tips.h"
#import "Coupn.h"
#import "UIImageView+WebCache.h"
#import "Drug.h"
#import "Verify.h"
#import <QuartzCore/QuartzCore.h>
@implementation SlowAddProductTableViewCell

+ (CGFloat)getCellHeight:(id)data{
    return 104;
}


- (void)awakeFromNib {
    self.textField.keyboardType =  UIKeyboardTypeNumberPad;
    self.textField.delegate=self;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (_selectState == YES)
    {
        return YES;
    }else{
        return NO;
    }

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

- (BOOL)stringNumber:(NSString *)str{
    
    NSString *c = @"^[0-9.]+$";
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",c];
    return [pre evaluateWithObject:str];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)UIGlobal{
    [super UIGlobal];
}
-(void)setCell:(id)data{
    [super setCell:data];
    CouponProductVo *model=(CouponProductVo *)data;
    self.proName.text=model.productName;
    self.spec.text=model.spec;
    [self.productImage setImageWithURL:[NSURL URLWithString:model.productLogo] placeholderImage:[UIImage imageNamed:@"img_goods_default"] options:SDWebImageRetryFailed|SDWebImageContinueInBackground];
    self.textField.text=[NSString stringWithFormat:@"%d",model.quantity];
    if(model.isSelect){
         [self.checkBox setImage:[UIImage imageNamed:@"img_choice"]  forState:UIControlStateNormal];
        self.selectState=YES;
        model.quantity=self.textField.text.intValue;
        //样式的改变
        self.textField.layer.borderColor=RGBHex(qwColor9).CGColor;
        self.textField.textColor=RGBHex(qwColor6);
        self.textField.layer.borderWidth = 1.0;
        [self.deleButton setBackgroundImage:[UIImage imageNamed:@"number_btn_subtract_click"] forState:UIControlStateNormal];
        [self.addButton setBackgroundImage:[UIImage imageNamed:@"number_btn_add_click"] forState:UIControlStateNormal];
    }else{
        [self.checkBox setImage:[UIImage imageNamed:@"img_noChoice"]  forState:UIControlStateNormal];
        self.selectState=NO;
        self.textField.text=@"1";
        model.quantity=1;
        
        //样式的改变
        self.textField.layer.borderColor=RGBHex(qwColor10).CGColor;
        self.textField.textColor=RGBHex(qwColor9);
        self.textField.layer.borderWidth = 1.0;
        [self.deleButton setBackgroundImage:[UIImage imageNamed:@"number_btn_subtract"] forState:UIControlStateNormal];
        [self.addButton setBackgroundImage:[UIImage imageNamed:@"number_btn_add"] forState:UIControlStateNormal];
    }
    
    
}
- (IBAction)deleteButton:(UIButton*)sender  {
    if (_selectState == YES)
    {
        [self.delegate btnClick:self andFlag:(int)sender.tag andField:self.textField.text];
    }
}

- (IBAction)addButton:(UIButton*)sender {
    if (_selectState == YES)
    {
        [self.delegate btnClick:self andFlag:(int)sender.tag andField:self.textField.text];
    }
}
- (IBAction)isCheckButton:(UIButton *)sender {
    [self.delegate btnClick:self andFlag:(int)sender.tag andField:@"1"];
}

@end
