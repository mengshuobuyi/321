//
//  EditDoorDeliveryCell.h
//  wenYao-store
//
//  Created by Yang Yuexia on 16/7/12.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWBaseTableCell.h"
#import "QWButton.h"

@protocol EditDoorDeliveryCellDelegate <NSObject>

- (void)addPriceCell:(NSIndexPath *)indexPath;

- (void)deletePriceCell:(NSIndexPath *)indexPath;

@end

@interface EditDoorDeliveryCell : QWBaseTableCell

@property (assign, nonatomic) id <EditDoorDeliveryCellDelegate> editDoorDeliveryCellDelegate;

@property (weak, nonatomic) IBOutlet UITextField *kilometerLabel;

@property (weak, nonatomic) IBOutlet UITextField *priceLabel;

@property (weak, nonatomic) IBOutlet UIView *topSepratorLine;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteBtn_layout_left;

@property (weak, nonatomic) IBOutlet QWButton *deleteBtn;

@property (weak, nonatomic) IBOutlet QWButton *addBtn;

- (IBAction)deleteAction:(id)sender;

- (IBAction)addAction:(id)sender;

- (void)configureData:(NSMutableArray *)dataArray indexPath:(NSIndexPath *)indexPath;

@end
