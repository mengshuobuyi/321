//
//  OrganInfoEditCell.h
//  wenYao-store
//
//  Created by YYX on 15/8/19.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseTableCell.h"

@protocol OrganInfoEditCellDelegaet <NSObject>

- (void)locationAction;

@end

@interface OrganInfoEditCell : QWBaseTableCell

@property (assign, nonatomic) id <OrganInfoEditCellDelegaet>organInfoEditCellDelegaet;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@property (weak, nonatomic) IBOutlet UIView *locationBg;

@property (weak, nonatomic) IBOutlet UIImageView *locationImage;

@property (weak, nonatomic) IBOutlet UIButton *locationButton;

- (IBAction)clickLocation:(id)sender;

@end
