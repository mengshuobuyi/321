//
//  ReceiverAddressCell.m
//  APP
//
//  Created by qw_imac on 15/12/30.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "ReceiverAddressCell.h"

@implementation ReceiverAddressCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setCellWith:(EmpAddressVo *)vo {
    self.receiverName.text = vo.receiver;
    self.address.text = [NSString stringWithFormat:@"%@",vo.receiverAddr];
    self.phoneNumber.text = vo.receiverTel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
