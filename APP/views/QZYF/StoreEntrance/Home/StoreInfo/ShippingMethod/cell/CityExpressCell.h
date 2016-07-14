//
//  CityExpressCell.h
//  wenYao-store
//
//  Created by Yang Yuexia on 16/5/6.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWBaseTableCell.h"

@protocol CityExpressCellDelegate <NSObject>

- (void)editCityExpressAction:(NSIndexPath *)indexPath;

@end

@interface CityExpressCell : QWBaseTableCell

@property (assign, nonatomic) id <CityExpressCellDelegate> cityExpressCellDelegate;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;      //发货时间

@property (weak, nonatomic) IBOutlet UILabel *freeTipLabel;

@property (weak, nonatomic) IBOutlet UILabel *freePostLabel;  //包邮

@property (weak, nonatomic) IBOutlet UILabel *EMSLabel;       //有快递费

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *EMSOne_layout_top;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *EMSTwo_layout_top;

@property (weak, nonatomic) IBOutlet UIImageView *rightIcon;

@property (weak, nonatomic) IBOutlet QWButton *editButton;

- (IBAction)editCityExpressAction:(id)sender;

@end
