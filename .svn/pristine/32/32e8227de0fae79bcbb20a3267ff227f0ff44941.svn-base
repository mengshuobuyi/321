//
//  InternalCateSelectCell.m
//  wenYao-store
//
//  Created by PerryChen on 7/12/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "InternalCateSelectCell.h"
#import "InternalProductModel.h"
@implementation InternalCateSelectCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setCell:(id)data
{
    InternalProductCateModel *model = (InternalProductCateModel *)data;
    self.lblCateContent.text = model.className;
    if ([model.check boolValue]) {
        self.imgViewSelectStatus.image = [UIImage imageNamed:@"btn_list_selected"];
    } else {
        self.imgViewSelectStatus.image = [UIImage imageNamed:@"btn_list_normal"];
    }
}

@end
