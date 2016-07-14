//
//  UploadLicenseCell.m
//  wenYao-store
//
//  Created by YYX on 15/8/24.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "UploadLicenseCell.h"

@implementation UploadLicenseCell

- (void)awakeFromNib
{
    self.bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.bgView.layer.borderWidth = 0.5;
    
    self.bgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedImage:)];
    [self.bgView addGestureRecognizer:tap];
}

- (void)selectedImage:(UITapGestureRecognizer *)tap
{
    QWView *bgView = (QWView *)tap.view;
    NSIndexPath *indexpath = bgView.obj;
    
    if (self.uploadLicenseCellDelegate && [self.uploadLicenseCellDelegate respondsToSelector:@selector(clickImageActionWithIndexPath:)]) {
        [self.uploadLicenseCellDelegate clickImageActionWithIndexPath:indexpath];
    }
}

- (IBAction)getDateAction:(id)sender
{
    QWButton *ben = (QWButton *)sender;
    NSIndexPath *indexPath = ben.obj;
    
    if (self.uploadLicenseCellDelegate && [self.uploadLicenseCellDelegate respondsToSelector:@selector(getDateActionWithIndexPath:)]) {
        [self.uploadLicenseCellDelegate getDateActionWithIndexPath:indexPath];
    }
}
@end
