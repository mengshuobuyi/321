//
//  NewExpertTableCell.h
//  wenYao-store
//
//  Created by Martin.Liu on 16/6/23.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAButtonWithTouchBlock.h"
@interface NewExpertTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet MAButtonWithTouchBlock *chooseBtn;
- (void)setCell:(id)obj;
- (void)showChooseBtn:(BOOL)show;

@end
