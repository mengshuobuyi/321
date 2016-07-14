//
//  PossibleDiseaseCell.h
//  quanzhi
//
//  Created by Meng on 14-8-13.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QWBaseTableCell.h"
#import "DrugModel.h"


@interface PossibleDiseaseCell : QWBaseTableCell
@property (strong, nonatomic) IBOutlet UIImageView *leftImageView;
@property (strong, nonatomic) IBOutlet QWLabel *name;
@property (strong, nonatomic) IBOutlet QWLabel *desc;
@property (strong, nonatomic) IBOutlet UILabel *numLabel;
- (void)setPossibleCell:(id)data row:(NSInteger)number fontSize:(UIFont *)fontSize contentSize:(UIFont *)contentSize;


+ (CGFloat)getCellHeight:(PossibleDisease *)data withFont:(UIFont *)fontTitle descFont:(UIFont *)fontDesc;
@end
