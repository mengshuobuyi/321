//
//  test3Cell.h
//  APP
//
//  Created by Yan Qingyang on 15/2/27.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseTableCell.h"

@interface test3Cell : QWBaseTableCell
@property (nonatomic, strong) IBOutlet  QWImageView     *iconUrl;
@property (nonatomic, strong) IBOutlet  QWLabel         *title;
//@property (nonatomic, strong) IBOutlet  UILabel         *lblDate;
@property (nonatomic, strong) IBOutlet  QWLabel         *introduction;
//@property (nonatomic, strong) IBOutlet  UILabel         *readedLabel;
//@property (nonatomic, strong) IBOutlet  UILabel         *praiseLabel;
@property (nonatomic, strong) IBOutlet  UIImageView     *backImage;
@end
