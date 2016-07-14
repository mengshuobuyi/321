//
//  DoorDeliveryCell.h
//  wenYao-store
//
//  Created by Yang Yuexia on 16/5/6.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWBaseTableCell.h"

@protocol DoorDeliveryCellDelegate <NSObject>

- (void)editDoorDeliveryAction:(NSIndexPath *)indexPath;

@end

@interface DoorDeliveryCell : QWBaseTableCell

@property (assign, nonatomic) id <DoorDeliveryCellDelegate> doorDeliveryCellDelegate;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;        //配送时间

@property (weak, nonatomic) IBOutlet UILabel *sendPriceLabel;   //起送价

@property (weak, nonatomic) IBOutlet UILabel *sendRuleTip;

@property (weak, nonatomic) IBOutlet UILabel *sendRuleOne;      //有配送费

@property (weak, nonatomic) IBOutlet UILabel *sendRuleTwo;      //有配送费

@property (weak, nonatomic) IBOutlet UILabel *sendRuleThree;    //有配送费

@property (weak, nonatomic) IBOutlet UILabel *freePriceTip;

@property (weak, nonatomic) IBOutlet UILabel *freePriceLabel;   //免费配送

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *freeOne_layout_top;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *freeTwo_layout_top;

@property (weak, nonatomic) IBOutlet UIImageView *rightIcon;

@property (weak, nonatomic) IBOutlet QWButton *editButton;

- (IBAction)editDoorDeliveryAction:(id)sender;

@end
