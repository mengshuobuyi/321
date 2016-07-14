//
//  test3Cell.m
//  APP
//
//  Created by Yan Qingyang on 15/2/27.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "test3Cell.h"
//#import "HealthinfoModel.h"

//#import "UIImageView+WebCache.h"

@implementation test3Cell
@synthesize iconUrl=iconUrl;
@synthesize introduction=introduction;
@synthesize title=title;



+ (CGFloat)getCellHeight:(id)data{
    return 120;
    
//    if ([QWGLOBALMANAGER object:data isClass:[HealthinfoAdvicel class]]) {
//        HealthinfoAdvicel *mod=(HealthinfoAdvicel*)data;
//        
//        CGSize sz = [QWGLOBALMANAGER sizeText:mod.introduction font:fontSystem(kFontS4) limitWidth:230];
//        float hh =38+sz.height+20;
////        NSLog(@"%@ %@",NSStringFromCGSize(sz),mod.introduction);
//        hh= (hh>80)?hh:80;
//        return hh;
//    }
//    return 0;
}


- (void)UIGlobal{
    [super UIGlobal];
    
    self.contentView.backgroundColor=RGBAHex(qwColor11, 1);
    self.separatorLine.backgroundColor = RGBAHex(qwColor2, 1);
    
    self.introduction.font=fontSystem(kFontS4);
    self.introduction.textColor=RGBHex(qwColor6);
    
    [self setSeparatorMargin:30 edge:EdgeLeft];
    
    [self setSelectedBGColor:RGBHex(qwColor1)];

//    NSLog(@"%@ - %@",NSStringFromCGRect(self.separatorLine.frame),NSStringFromCGRect(self.bounds));
}

- (void)setCell:(id)data{
    NSLog(@"%@",data);
    [super setCell:data];
    
    CGRect frm;
    CGSize sz = [QWGLOBALMANAGER sizeText:self.introduction.text font:fontSystem(kFontS4) limitWidth:230];
    frm=self.introduction.frame;
    frm.size.height=sz.height;
    self.introduction.frame=frm;
}

@end
