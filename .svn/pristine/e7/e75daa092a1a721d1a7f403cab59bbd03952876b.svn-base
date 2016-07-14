//
//  OrganAuthEditCell.h
//  wenYao-store
//
//  Created by YYX on 15/8/19.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseTableCell.h"

@protocol  OrganAuthEditCellDelegate <NSObject>

- (void)provinceAndCityUp;

@end

@interface OrganAuthEditCell : QWBaseTableCell

@property (assign, nonatomic) id <OrganAuthEditCellDelegate> organAuthEditCellDelegate;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@property (weak, nonatomic) IBOutlet UIButton *cityButton;

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

- (IBAction)provinceAndCityUp:(id)sender;

@end
