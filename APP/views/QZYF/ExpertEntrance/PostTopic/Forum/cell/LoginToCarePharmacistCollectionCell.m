//
//  LoginToCarePharmacistCollectionCell.m
//  APP
//
//  Created by Martin.Liu on 15/12/30.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "LoginToCarePharmacistCollectionCell.h"

@implementation LoginToCarePharmacistCollectionCell

- (void)awakeFromNib {
    [self.loginBtn setTitleColor:RGBHex(qwColor4) forState:UIControlStateNormal];
    self.loginBtn.backgroundColor = RGBHex(qwColor2);
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 4;
}

@end
