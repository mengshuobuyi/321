//
//  VerifyRecordListCell.h
//  wenYao-store
//
//  Created by PerryChen on 6/15/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "QWBaseCell.h"

@interface VerifyRecordListCell : QWBaseCell
@property (weak, nonatomic) IBOutlet UIImageView *imgViewContent;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblRecordOwner;
@property (weak, nonatomic) IBOutlet UILabel *lblRecordScore;
@property (weak, nonatomic) IBOutlet UILabel *lblVerifyTime;

@end
