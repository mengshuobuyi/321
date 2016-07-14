//
//  PerformanceOrderTableViewCell.h
//  wenYao-store
//
//  Created by qw_imac on 16/5/6.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListModel.h"
@interface PerformanceOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imgs;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *alert2;
@property (weak, nonatomic) IBOutlet UILabel *alert1;
-(void)setCell:(MicroMallShopOrderVO *)vo;
@end
