//
//  InstitutionListCell.m
//  wenYao-store
//
//  Created by qwfy0006 on 15/4/1.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "InstitutionListCell.h"
#import "PharmacyModel.h"

@implementation InstitutionListCell

@synthesize lbl_storeName = lbl_storeName;
@synthesize lbl_storeAddress = lbl_storeAddress;
@synthesize btn_chose = btn_chose;


+ (CGFloat)getCellHeight:(id)data{
    
    return 80;
}

- (void)UIGlobal{
    [super UIGlobal];
    self.separatorLine.hidden = YES;
    
    self.btn_chose.layer.masksToBounds = YES;
    self.btn_chose.layer.cornerRadius = 4.0;
    [self.lbl_storeName setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    [self.btn_chose addTarget:self action:@selector(ChoseInstitution:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setCell:(id)data{
    [self UIGlobal];
    [super setCell:data];
    QueryStoreModel *model = (QueryStoreModel *)data;
    self.lbl_storeName.text = model.name;
    self.lbl_storeAddress.text = model.address;
}

-(void)ChoseInstitution:(id)sender{
    UIButton *btn = sender;
    [self.institutiondelegate ChoseInstitution:btn.tag];
}


@end
