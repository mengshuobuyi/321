//
//  InternalCateReorderCell.h
//  wenYao-store
//
//  Created by PerryChen on 7/12/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "QWBaseCell.h"

@interface InternalCateReorderCell : QWBaseCell
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewReorder;
@property (weak, nonatomic) IBOutlet UILabel *lblCateCount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLead;
- (void)setCell:(id)data;

@end
