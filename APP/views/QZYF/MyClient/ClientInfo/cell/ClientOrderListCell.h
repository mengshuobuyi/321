//
//  ClientOrderListCell.h
//  wenYao-store
//
//  Created by PerryChen on 5/16/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "QWBaseCell.h"
#import "MyCustomerBaseModel.h"

@interface ClientOrderListCell : QWBaseCell
@property (weak, nonatomic) IBOutlet UILabel *lblOrderStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderNum;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderDate;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderPrice;

- (void)setCell:(CustomerOrderVoModel *)data;

@end
