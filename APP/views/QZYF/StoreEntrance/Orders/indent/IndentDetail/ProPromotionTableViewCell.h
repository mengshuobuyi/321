//
//  ProPromotionTableViewCell.h
//  APP
//
//  Created by qw_imac on 15/12/29.
//  Copyright © 2015年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProPromotionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *allPrice;
@property (weak, nonatomic) IBOutlet UILabel *discountPrice;
@property (weak, nonatomic) IBOutlet UILabel *promotion;
@property (weak, nonatomic) IBOutlet UILabel *postPrice;
@property (weak, nonatomic) IBOutlet UILabel *finalPrice;

@end
