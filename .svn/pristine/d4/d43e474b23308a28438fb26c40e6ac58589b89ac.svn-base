//
// 
//  wenyao-store
//
//  Created by xiezhenghong on 14-10-22.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "DoingActivityTableViewCell.h"
#import "Activity.h"

@implementation DoingActivityTableViewCell

+ (CGFloat)getCellHeight:(id)data{
    return 95;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)UIGlobal{
    [super UIGlobal];
    self.separatorLine.hidden=NO;
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCell:(id)data{
    BranchPromotionModel *model = (BranchPromotionModel *)data;
    [super setCell:data];
    if(model.imgUrl&&model.imgUrl.length>0){
        self.imageUrl.hidden=NO;
        self.leftTextCon.constant=92;
        self.leftTitleCon.constant=92;
        [self.imageUrl setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"img_goods_default"]];
    }else{
        self.imageUrl.hidden=YES;
        self.leftTextCon.constant=12;
        self.leftTitleCon.constant=12;
    }
    
    
}

@end
