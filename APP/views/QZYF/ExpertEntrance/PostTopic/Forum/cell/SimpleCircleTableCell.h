//
//  SimpleCircleTableCell.h
//  APP
//
//  Created by Martin.Liu on 16/6/22.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleCircleTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *chooseBtn;
- (void)setCell:(id)obj;
@end
