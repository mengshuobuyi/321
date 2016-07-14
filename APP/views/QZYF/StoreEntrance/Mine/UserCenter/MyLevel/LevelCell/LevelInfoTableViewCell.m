//
//  LevelInfoTableViewCell.m
//  wenYao-store
//
//  Created by qw_imac on 16/5/5.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "LevelInfoTableViewCell.h"

@implementation LevelInfoTableViewCell

- (void)awakeFromNib {
    _info.preferredMaxLayoutWidth = APP_W - 45.0;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setCell:(NSString *)str With:(ShowType)type {   
    switch (type) {
        case ShowTypeTop:
            _bottomSpace.constant = 1.0;
            _topSpace.constant = 13.0;
            break;
        case ShowTypeBottom:
             _topSpace.constant = 1.0;
            _bottomSpace.constant = 13.0;
            break;
        case ShowTypeOnlyOne:
            _topSpace.constant = 13.0;
            _bottomSpace.constant = 13.0;
            break;
        case ShowTypeMid:
            _topSpace.constant = 1.0;
            _bottomSpace.constant = 1.0;
            break;
    }
    _info.text = str;
}
@end
