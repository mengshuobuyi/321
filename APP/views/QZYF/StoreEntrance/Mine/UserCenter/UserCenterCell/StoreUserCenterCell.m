//
//  StoreUserCenterCell.m
//  wenYao-store
//
//  Created by Martin.Liu on 16/5/5.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "StoreUserCenterCell.h"

@implementation StoreUserCenterCell

+ (CGFloat)getCellHeight:(id)data{
    return 45;
}
- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)UIGlobal{
    [super UIGlobal];
    
    self.budge.layer.cornerRadius = 4.0f;
    self.budge.layer.masksToBounds = YES;
    
    self.separatorLine.backgroundColor = RGBHex(qwColor10);
    [self setSeparatorMargin:0 edge:EdgeLeft];
}

@end

@implementation StoreUserCenterCreditCell
@synthesize titleLabel;
@synthesize icon;

- (void)UIGlobal{
    [super UIGlobal];
    
    self.creditLabel.font = [UIFont boldSystemFontOfSize:kFontS2];
    self.creditLabel.textColor = RGBHex(qwColor3);
}


@end

@implementation StoreUserCenterHotLineCell
@synthesize titleLabel;
@synthesize icon;

- (void)UIGlobal{
    [super UIGlobal];
    
    self.hotLineLabel.font = [UIFont systemFontOfSize:kFontS4];
    self.hotLineLabel.textColor = RGBHex(qwColor9);
}

@end
