//
//  MedicineListCell.m
//  wenyao
//
//  Created by Meng on 14-9-28.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "MedicineListCell.h"
#import "UIImageView+WebCache.h"
#import "DrugModel.h"

@implementation MedicineListCell
@synthesize proName=proName;
@synthesize spec=spec;
@synthesize factory=factory;
@synthesize headImageView=headImageView;
@synthesize tagLabel=tagLabel;


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

+ (CGFloat)getCellHeight:(id)data{
    
    return 95.0f;
}

//setSenaioCell

#pragma mark ---- 本店咨询 搜索药品
- (void)configureStoreData:(id)data
{
    [super setCell:data];
    
    ExpertSearchMedicineListModel *productModel=(ExpertSearchMedicineListModel *)data;
    
    [self.headImageView setImageWithURL:[NSURL URLWithString:productModel.imgUrl] placeholderImage:[UIImage imageNamed:@"药品默认图片.png"]];
    self.proName.text = productModel.proName;
    self.spec.text = productModel.spec;
    self.factory.text = productModel.factory;
}

- (void)configureExpertData:(id)data
{
    [super setCell:data];
    
    ExpertSearchMedicineListModel *productModel=(ExpertSearchMedicineListModel *)data;
    
    [self.headImageView setImageWithURL:[NSURL URLWithString:productModel.imgUrl] placeholderImage:[UIImage imageNamed:@"药品默认图片.png"]];
    self.proName.text = productModel.proName;
    self.spec.text = productModel.spec;
    self.factory.text = productModel.factory;
}


- (void)setCell:(id)data{
    [super setCell:data];
    productclassBykwId *productModel=(productclassBykwId *)data;
    if (productModel.proId) {
//        NSString *imageUrl = PORID_IMAGE(productModel.proId);
        [self.headImageView setImageWithURL:[NSURL URLWithString:productModel.imgUrl]];
    }
    if (self.headImageView.image == nil) {
        self.headImageView.image = [UIImage imageNamed:@"药品默认图片.png"];
    }
    self.proName.text = productModel.proName;
    self.spec.text = productModel.spec;
    if(productModel.factory){
        self.factory.text = productModel.factory;
    }else if (productModel.makeplace) {
        self.factory.text = productModel.makeplace;
    }
    
}

- (void)UIGlobal{
    [super UIGlobal];
    [self setSelectedBGColor:RGBHex(qwColor11)];
}
@end
