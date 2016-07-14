//
//  InternalProductSubtitleWithAccessoryCell.h
//  wenYao-store
//
//  Created by PerryChen on 3/10/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "QWBaseCell.h"

@interface InternalProductSubtitleWithAccessoryCell : QWBaseCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *stackLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrowImgView;

@end
