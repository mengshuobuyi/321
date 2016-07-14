//
//  ProfessionAuthInfoCell.h
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/5.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWBaseTableCell.h"

@protocol ProfessionAuthInfoCellDelegate <NSObject>

- (void)selectedTagAction:(UIButton *)button;

@end

@interface ProfessionAuthInfoCell : QWBaseTableCell

@property (assign, nonatomic) id <ProfessionAuthInfoCellDelegate> professionAuthInfoCellDelegate;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgView_layout_height;

- (void)setUpTagsWithAllList:(NSArray *)allList selectedList:(NSArray *)selectedList;

@end
