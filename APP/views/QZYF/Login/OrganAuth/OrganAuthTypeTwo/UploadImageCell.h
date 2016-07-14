//
//  UploadImageCell.h
//  wenYao-store
//
//  Created by YYX on 15/8/24.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseTableCell.h"

@interface UploadImageCell : QWBaseTableCell

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *uploadImage;

@property (weak, nonatomic) IBOutlet UILabel *tipsOne;

@property (weak, nonatomic) IBOutlet UILabel *tipsTwo;

@end
