//
//  EditDoorDeliveryCell.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/7/12.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "EditDoorDeliveryCell.h"

@implementation EditDoorDeliveryCell

- (void)UIGlobal
{
    [super UIGlobal];
    
    self.separatorLine.hidden = YES;
    
    self.deleteBtn.layer.borderColor = RGBHex(qwColor10).CGColor;
    self.deleteBtn.layer.borderWidth = 1.0;
    self.deleteBtn.layer.cornerRadius = 2;
    self.deleteBtn.layer.masksToBounds = YES;
    
    self.addBtn.layer.borderColor = RGBHex(qwColor2).CGColor;
    self.addBtn.layer.borderWidth = 1.0;
    self.addBtn.layer.cornerRadius = 2;
    self.addBtn.layer.masksToBounds = YES;
    
    self.kilometerLabel.keyboardType = UIKeyboardTypeNumberPad;
    self.priceLabel.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)configureData:(NSMutableArray *)dataArray indexPath:(NSIndexPath *)indexPath
{
    if (dataArray.count == 1)
    {
        self.deleteBtn.hidden = NO;
        self.deleteBtn.enabled = YES;
        self.addBtn.hidden = NO;
        self.addBtn.enabled = YES;
        self.deleteBtn_layout_left.constant = 57;
        
    }else if (dataArray.count == 2)
    {
        if (indexPath.row == 0)
        {
            self.deleteBtn.hidden = NO;
            self.deleteBtn.enabled = YES;
            self.addBtn.hidden = YES;
            self.addBtn.enabled = NO;
            self.deleteBtn_layout_left.constant = (APP_W-94)/2;
            
        }else if (indexPath.row == 1)
        {
            self.deleteBtn.hidden = NO;
            self.deleteBtn.enabled = YES;
            self.addBtn.hidden = NO;
            self.addBtn.enabled = YES;
            self.deleteBtn_layout_left.constant = 57;
        }
        
    }else if (dataArray.count == 3)
    {
        self.deleteBtn.hidden = NO;
        self.deleteBtn.enabled = YES;
        self.addBtn.hidden = YES;
        self.addBtn.enabled = NO;
        self.deleteBtn_layout_left.constant = (APP_W-94)/2;
    }
}

- (IBAction)deleteAction:(id)sender
{
    QWButton *btn = (QWButton *)sender;
    NSIndexPath *indexPath = (NSIndexPath *)btn.obj;
    
    if (self.editDoorDeliveryCellDelegate && [self.editDoorDeliveryCellDelegate respondsToSelector:@selector(deletePriceCell:)]) {
        [self.editDoorDeliveryCellDelegate deletePriceCell:indexPath];
    }
}

- (IBAction)addAction:(id)sender
{
    QWButton *btn = (QWButton *)sender;
    NSIndexPath *indexPath = (NSIndexPath *)btn.obj;
    
    if (self.editDoorDeliveryCellDelegate && [self.editDoorDeliveryCellDelegate respondsToSelector:@selector(addPriceCell:)]) {
        [self.editDoorDeliveryCellDelegate addPriceCell:indexPath];
    }
}

@end
