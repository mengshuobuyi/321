//
//  InternalProductSubtitleCell.h
//  wenYao-store
//
//  Created by PerryChen on 3/10/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "QWBaseCell.h"
#import "CustomMultiLineLabel.h"

@interface InternalProductSubtitleCell : QWBaseCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet CustomMultiLineLabel *contentLabel;

@end
