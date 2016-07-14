//
//  ToStorePickCell.h
//  wenYao-store
//
//  Created by Yang Yuexia on 16/5/6.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWBaseTableCell.h"

@protocol ToStorePickCellDelegate <NSObject>

- (void)editToStorePickAction:(NSIndexPath *)indexPath;

@end

@interface ToStorePickCell : QWBaseTableCell

@property (assign, nonatomic) id <ToStorePickCellDelegate> toStorePickCellDelegate;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;  //营业时间

@property (weak, nonatomic) IBOutlet UIImageView *rightIcon;

@property (weak, nonatomic) IBOutlet QWButton *editButton;

- (IBAction)editToStorePickAction:(id)sender;

@end
