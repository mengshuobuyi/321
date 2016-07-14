//
//  UploadLicenseCell.h
//  wenYao-store
//
//  Created by YYX on 15/8/24.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseTableCell.h"
#import "QWTextField.h"
#import "QWView.h"

@protocol UploadLicenseCellDelegate <NSObject>

- (void)clickImageActionWithIndexPath:(NSIndexPath *)indexPath;

- (void)getDateActionWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface UploadLicenseCell : QWBaseTableCell

@property (assign, nonatomic) id <UploadLicenseCellDelegate> uploadLicenseCellDelegate;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet QWTextField *inputTextField;

@property (weak, nonatomic) IBOutlet QWView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *uploadImage;

@property (weak, nonatomic) IBOutlet UIImageView *noImageView;

@property (weak, nonatomic) IBOutlet UILabel *tipsOne;

@property (weak, nonatomic) IBOutlet UILabel *tipsTwo;

@property (weak, nonatomic) IBOutlet QWButton *dateButton;

@property (weak, nonatomic) IBOutlet UIImageView *rightArrowImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldLeftConstraint;



- (IBAction)getDateAction:(id)sender;

@end
