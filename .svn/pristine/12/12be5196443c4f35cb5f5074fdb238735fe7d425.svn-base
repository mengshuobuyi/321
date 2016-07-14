//
//  IndexTopCollectionCell.m
//  wenYao-store
//
//  Created by YYX on 15/8/18.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "IndexTopCollectionCell.h"

@implementation IndexTopCollectionCell

- (void)awakeFromNib
{
    if (IS_IPHONE_6) {
        self.scanLeftConstraint.constant = 15*2;
        self.uploadLeftConstraint.constant = 15*2;
    }else if (IS_IPHONE_6P){
        self.scanLeftConstraint.constant = 15*3;
        self.uploadLeftConstraint.constant = 15*3;
    }
}


// 扫码验证
- (IBAction)scanVerifyAction:(id)sender
{
    if (self.indexTopCollectionCellDelegate && [self.indexTopCollectionCellDelegate respondsToSelector:@selector(scanVerifyCodeAction)]) {
        [self.indexTopCollectionCellDelegate scanVerifyCodeAction];
    }
}

//  上传小票
- (IBAction)uploadReceiptAction:(id)sender
{
    if (self.indexTopCollectionCellDelegate && [self.indexTopCollectionCellDelegate respondsToSelector:@selector(uploadReceiptAction)]) {
        [self.indexTopCollectionCellDelegate uploadReceiptAction];
    }
}
@end
