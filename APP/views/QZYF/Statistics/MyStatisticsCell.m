//
//  MyStatisticsCell.m
//  wenYao-store
//
//  Created by Yang Yuexia on 15/12/22.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "MyStatisticsCell.h"

@implementation MyStatisticsCell

- (void)awakeFromNib
{
    self.redDot.layer.cornerRadius = 3.0;
    self.redDot.layer.masksToBounds = YES;
}

@end
