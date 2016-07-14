//
//  InternalProductSelectCell.m
//  wenYao-store
//
//  Created by PerryChen on 6/13/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "InternalProductSelectCell.h"
#import "InternalProduct.h"

@implementation InternalProductSelectCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setCell:(id)data
{
    InternalProductQueryProductModel *model = (InternalProductQueryProductModel *)data;
    self.lblProductTitle.text = model.proName;
    self.lblProductSpec.text = model.spec;
    self.lblProductFactory.text = model.factory;
    if (model.imgUrls.count > 0) {
        [self.imgViewContent setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"news_placeholder"]];
    } else {
        [self.imgViewContent setImage:[UIImage imageNamed:@"news_placeholder"]];
    }

}

@end
