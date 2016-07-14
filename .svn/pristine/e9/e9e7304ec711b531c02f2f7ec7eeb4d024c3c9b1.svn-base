//
//  ProductSearchTableVCell.m
//  wenYao-store
//
//  Created by Martin.Liu on 16/5/13.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ProductSearchTableVCell.h"
#import "UIImageView+WebCache.h"
#import "Store.h"
@interface ProductSearchTableVCell()
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *myTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *specificationLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *salesCountLabel;

@end
@implementation ProductSearchTableVCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCell:(id)obj
{
    if ([obj isKindOfClass:[ProductStatiticsModel class]]) {
        ProductStatiticsModel* model = obj;
        [self.myImageView setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:nil];
        self.myTitleLabel.text = model.proName;
        self.specificationLabel.text = model.spec;
        self.companyLabel.text = model.factory;
        self.salesCountLabel.text = [NSString stringWithFormat:@"销量%@", StrDFString(model.quantity, @"0")];
    }
}

@end
