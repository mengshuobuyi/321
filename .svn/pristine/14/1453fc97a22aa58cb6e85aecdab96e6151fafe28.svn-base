//
//  EditAddressTableViewCell.m
//  wenYao-store
//
//  Created by qw_imac on 16/5/9.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "EditAddressTableViewCell.h"

@implementation EditAddressTableViewCell

- (void)awakeFromNib {
    _wBtn.layer.cornerRadius = 14.0;
    _wBtn.layer.masksToBounds = YES;
    [_wBtn setBackgroundColor:RGBHex(qwColor4)];
    [_wBtn setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
    _wBtn.layer.borderWidth = 1.0;
    _wBtn.layer.borderColor = RGBHex(qwColor11).CGColor;
    _mBtn.layer.cornerRadius = 14.0;
    _mBtn.layer.masksToBounds = YES;
    [_mBtn setBackgroundColor:RGBHex(qwColor4)];
    [_mBtn setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
    _mBtn.layer.borderWidth = 1.0;
    _mBtn.layer.borderColor = RGBHex(qwColor11).CGColor;
}

-(CGFloat)getCellHeight {
    return 230.0;
}

-(void)setDelegate:(id<UITextFieldDelegate>)obj {
    [_eventBtn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    _receiver.delegate = obj;
    _tel.delegate = obj;
    _formatAddress.delegate = obj;
    [_eventBtn addTarget:obj action:@selector(chooseCity:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)selectSex:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
            [sender setSelected:!sender.isSelected];
            [_wBtn setSelected:NO];
            break;
        case 2:
            [sender setSelected:!sender.isSelected];
            [_mBtn setSelected:NO];
            break;
    }
    [self setSex];
}

-(void)setSex {
    if (_wBtn.isSelected) {
        [_wBtn setBackgroundColor:RGBHex(qwColor1)];
        [_wBtn setTitleColor:RGBHex(qwColor4) forState:UIControlStateNormal];
        [_mBtn setBackgroundColor:RGBHex(qwColor4)];
        [_mBtn setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
        _mBtn.layer.borderWidth = 1.0;
        _mBtn.layer.borderColor = RGBHex(qwColor11).CGColor;
        _wBtn.layer.borderWidth = 0.0;
    }
    if (_mBtn.isSelected) {
        [_mBtn setBackgroundColor:RGBHex(qwColor1)];
        [_mBtn setTitleColor:RGBHex(qwColor4) forState:UIControlStateNormal];
        [_wBtn setBackgroundColor:RGBHex(qwColor4)];
        [_wBtn setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
        _wBtn.layer.borderWidth = 1.0;
        _wBtn.layer.borderColor = RGBHex(qwColor11).CGColor;
        _mBtn.layer.borderWidth = 0.0;
    }
}

-(void)setCell:(id)model {
    SetCellModel *setModel = (SetCellModel *)model;
    EmpAddressVo *addressModel = (EmpAddressVo *)setModel.dataModel;
    if (!addressModel) {
        return;
    }else {
        _receiver.text = addressModel.receiver;
        _tel.text = addressModel.receiverTel;
        _cityName.text = [NSString stringWithFormat:@"%@%@",addressModel.receiverProvinceName,addressModel.receiverCityName];
        _formatAddress.text = addressModel.receiverAddr;
        if ([addressModel.receiverGender isEqualToString:@"M"]) {
            _mBtn.selected = YES;
            _wBtn.selected = NO;
        }else {
            _wBtn.selected = YES;
            _mBtn.selected = NO;
        }
        [self setSex];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
