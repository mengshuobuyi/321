//
//  InternalProductSelectCell.h
//  wenYao-store
//
//  Created by PerryChen on 6/13/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "QWBaseCell.h"

@interface InternalProductSelectCell : QWBaseCell
@property (weak, nonatomic) IBOutlet UIImageView *imgViewSelect;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewContent;
@property (weak, nonatomic) IBOutlet UILabel *lblProductTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblProductSpec;
@property (weak, nonatomic) IBOutlet UILabel *lblProductFactory;

@end
