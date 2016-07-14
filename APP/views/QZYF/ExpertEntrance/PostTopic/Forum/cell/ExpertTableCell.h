//
//  ExpertTableCell.h
//  APP
//
//  Created by Martin.Liu on 16/1/14.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAButtonWithTouchBlock.h"
@interface ExpertTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet MAButtonWithTouchBlock *chooseBtn;
- (void)setCell:(id)obj;
- (void)showChooseBtn:(BOOL)show;

@end
