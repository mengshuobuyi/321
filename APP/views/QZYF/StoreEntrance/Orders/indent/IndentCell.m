//
//  IndentCell.m
//  APP
//
//  Created by qw_imac on 15/12/29.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "IndentCell.h"
#import "UIImageView+WebCache.h"
@implementation IndentCell

- (void)awakeFromNib {
    self.consigneeBtn.layer.cornerRadius = 3.0;
    self.consigneeBtn.layer.borderWidth = 0.5;
    self.consigneeBtn.layer.borderColor = RGBHex(qwColor7).CGColor;
    [self.consigneeBtn setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
    self.consigneeBtn.layer.masksToBounds = YES;
    
    self.checkPostBtn.layer.cornerRadius = 3.0;
    self.checkPostBtn.layer.borderColor = RGBHex(qwColor7).CGColor;
    self.checkPostBtn.layer.borderWidth = 0.5;
    [self.checkPostBtn setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
    self.checkPostBtn.layer.masksToBounds = YES;
    
    self.cancelBtn.layer.cornerRadius = 3.0;
    self.cancelBtn.layer.borderWidth = 0.5;
    self.cancelBtn.layer.borderColor = RGBHex(qwColor7).CGColor;
    [self.cancelBtn setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
    self.cancelBtn.layer.masksToBounds = YES;
    
    _postStyleLabel.layer.cornerRadius = 3.0;
    _payStyleLabel.layer.cornerRadius = 3.0;
    _payStyleLabel.layer.masksToBounds = YES;
    _postStyleLabel.layer.masksToBounds = YES;
    self.postStyleLabel.edgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
    self.payStyleLabel.edgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
    // Initialization code
}

-(void)setCellWith:(MicroMallShopOrderVO *)vo {
    [self.checkPostBtn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [self.consigneeBtn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    self.line.hidden = NO;
    self.consigneeBtn.layer.borderColor = RGBHex(qwColor7).CGColor;
    [self.consigneeBtn setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
    if (vo.uploadBill) {
        self.pmtImg.hidden = NO;
    }else {
        self.pmtImg.hidden = YES;
    }
    _cancelBtn.hidden = YES;
    if ([vo.payType integerValue] == 2) {
        _payStatusLabel.hidden = NO;
    }else {
        _payStatusLabel.hidden = YES;
    }
    if(!StrIsEmpty(vo.receiverTel)){
        self.nameLabel.text =[NSString stringWithFormat:@"%@:",vo.receiver];
        _tel.hidden = NO;
        _underLine.hidden = NO;
        self.tel.text = [NSString stringWithFormat:@"%@",vo.receiverTel];
    }else {
        self.nameLabel.text =[NSString stringWithFormat:@"%@",vo.receiver];
        _tel.hidden = YES;
        _underLine.hidden = YES;
    }
    self.messageLabel.text =[NSString stringWithFormat:@"下单时间：%@",vo.createStr];
    switch ([vo.deliver intValue]) {
        case 1:
            self.postStyleLabel.text = @"到店取货 ";
            break;
        case 2:
            self.postStyleLabel.text = @"送货上门 ";
            break;
        default:
            self.postStyleLabel.text = @"同城快递 ";
            break;
    }
    switch ([vo.payType integerValue]) {
        case 1:
            _payStyleLabel.text = @"当面支付";
            
            break;
        case 2:
            if (StrIsEmpty(vo.onLinePayType)) {
                _payStyleLabel.text = @"在线支付";
                
            }else {
                if (vo.onLinePayType.integerValue == 1) {
                    _payStyleLabel.text = @"在线支付(支付宝)";
                    
                }else {
                    _payStyleLabel.text = @"在线支付(微信)";
                    
                }
            }
            break;
    }
    /**
     *  comment by perry
     *  Workaround for the bug that AFNetWoking framework will give the wrong decimals on 54.56
     *  Refrence on http://stackoverflow.com/questions/8581212/removing-characters-after-the-decimal-point-for-a-double
     */
    float pay = [vo.finalAmount floatValue];
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterRoundFloor;
    [formatter setMaximumFractionDigits:2];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",[formatter stringFromNumber:[NSNumber numberWithFloat:pay]]];
    
    self.space.constant = 94;
    switch ([vo.orderStatus intValue]) {
        case 1:
           self.stateLabel.text = @"待接单";
            self.checkPostBtn.hidden = NO;
            self.consigneeBtn.hidden = NO;
            self.consigneeBtn.layer.borderColor = RGBHex(qwColor2).CGColor;
            [self.consigneeBtn setTitleColor:RGBHex(qwColor2) forState:UIControlStateNormal];
            [self.consigneeBtn setTitle:@"接单" forState:UIControlStateNormal];
            [self.checkPostBtn setTitle:@"拒绝" forState:UIControlStateNormal];
            break;
        case 2:
            self.stateLabel.text = @"待配送";
            self.checkPostBtn.hidden = NO;
            self.consigneeBtn.hidden = NO;
            [self.checkPostBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            if ([vo.deliver intValue] == 2) {//送货上门
                [self.consigneeBtn setTitle:@"去配送" forState:UIControlStateNormal];
            }else if ([vo.deliver intValue] == 3){//同城快递
                [self.consigneeBtn setTitle:@"填写物流" forState:UIControlStateNormal];
            }else {//到店自取
                self.line.hidden = YES;
                self.consigneeBtn.hidden = YES;
            }
            break;
        case 3:
            self.stateLabel.text = @"配送中";
            _cancelBtn.hidden = NO;
            self.consigneeBtn.hidden = NO;
           
            [self.consigneeBtn setTitle:@"确认订单" forState:UIControlStateNormal];
            if([vo.deliver intValue] == 3){
                self.checkPostBtn.hidden = NO;
                [self.checkPostBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                self.paggingSpace.constant = 99.0;
            }else {
                self.checkPostBtn.hidden = YES;
                self.paggingSpace.constant = 7.0;
            }
            break;
        case 5:
            self.stateLabel.text = @"已拒绝";
//             self.stateLabel.textColor = RGBHex(qwColor6);
            self.checkPostBtn.hidden = YES;
            self.consigneeBtn.hidden = YES;
            self.line.hidden = YES;
            break;
        case 6:
            self.stateLabel.text = @"待取货";
            self.checkPostBtn.hidden = NO;
            self.consigneeBtn.hidden = NO;
            [self.checkPostBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [self.consigneeBtn setTitle:@"确认订单" forState:UIControlStateNormal];
            break;
        case 8:
            self.stateLabel.text = @"已取消";
//             self.stateLabel.textColor = RGBHex(qwColor6);
            self.checkPostBtn.hidden = YES;
            self.consigneeBtn.hidden = YES;
            self.line.hidden = YES;
            break;
        case 9:
            self.stateLabel.text = @"已完成";
//            self.stateLabel.textColor = RGBHex(qwColor6);
            self.consigneeBtn.hidden = YES;
        //已完成的同城快递可以查看物流
            if ([vo.deliver intValue] == 3) {
                self.space.constant = 7;
                self.checkPostBtn.hidden = NO;
                [self.checkPostBtn setTitle:@"查看物流" forState:UIControlStateNormal];
            }else {
                self.checkPostBtn.hidden = YES;
                self.line.hidden = YES;
            }
            break;
    }
    NSArray *imgList = vo.microMallOrderDetailVOs;
    switch (imgList.count) {
        case 0:
            self.firstDrugImg.hidden = YES;
            self.secondDrugImg.hidden = YES;
            self.thirdDrugImg.hidden = YES;
            self.lastDrugImg.hidden = YES;
            break;
        case 1:
            self.firstDrugImg.hidden = NO;
            self.secondDrugImg.hidden = YES;
            self.thirdDrugImg.hidden = YES;
            self.lastDrugImg.hidden = YES;
            break;
        case 2:
            self.firstDrugImg.hidden = NO;
            self.secondDrugImg.hidden = NO;
            self.thirdDrugImg.hidden = YES;
            self.lastDrugImg.hidden = YES;
            break;
        case 3:
            self.firstDrugImg.hidden = NO;
            self.secondDrugImg.hidden = NO;
            self.thirdDrugImg.hidden = NO;
            self.lastDrugImg.hidden = YES;
            break;
        default:
            self.firstDrugImg.hidden = NO;
            self.secondDrugImg.hidden = NO;
            self.thirdDrugImg.hidden = NO;
            self.lastDrugImg.hidden = NO;
            break;
    }
    NSArray *drugImgArray = @[self.firstDrugImg,self.secondDrugImg,self.thirdDrugImg,self.lastDrugImg];
    for (int i = 0; i < (imgList.count<4 ? imgList.count:4); i ++) {
        MicroMallOrderDetailVO *orderVo = imgList[i];
        UIImageView *imgView = drugImgArray[i];
        [imgView setImageWithURL:[NSURL URLWithString:orderVo.imgUrl] placeholderImage:[UIImage imageNamed:@"药品默认图片"]];
    }

}

+(CGFloat)setHeight {
    return 241.0;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
