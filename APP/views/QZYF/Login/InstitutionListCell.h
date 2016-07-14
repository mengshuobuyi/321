//
//  InstitutionListCell.h
//  wenYao-store
//
//  Created by qwfy0006 on 15/4/1.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseTableCell.h"

@protocol ChoseInstitutionDelegate <NSObject>

-(void)ChoseInstitution:(NSInteger)indexpath;

@end

@interface InstitutionListCell : QWBaseTableCell

@property (weak, nonatomic) id<ChoseInstitutionDelegate> institutiondelegate;

@property (strong, nonatomic) IBOutlet QWLabel  *lbl_storeName;
@property (strong, nonatomic) IBOutlet QWLabel  *lbl_storeAddress;
@property (strong, nonatomic) IBOutlet QWButton *btn_chose;

@end
